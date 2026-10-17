eval "$(starship init zsh)"

# ========================================
# Highlighting
# ========================================
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'                # gray
ZSH_HIGHLIGHT_STYLES[command]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#81a1c1'  # if, for, while, do, ...
ZSH_HIGHLIGHT_STYLES[globbing]='fg=red'
ZSH_HIGHLIGHT_STYLES[path]='fg=white'

# Disable Alt+Number self-inserting characters
bindkey -r "^[0" "^[1" "^[2" "^[3" "^[4" "^[5" "^[6" "^[7" "^[8" "^[9"

# ========================================
# Environment
# ========================================
# Fix for D-Bus session for systemctl --user
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

export EDITOR="nvim"
export KUBE_CONFIG_PATH=~/.kube/config
export STARSHIP_CONFIG=~/.config/starship-config/starship.toml

# Disabling paging by default
export PAGER=cat
export LESS=

# ========================================
# Aliases
# ========================================
alias kc='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias tf='terraform'
alias tg='terragrunt'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lg=lazygit
alias kcgp='kc get pods -l app.kubernetes.io/instance='
alias kcgd='kc get deploy -l app.kubernetes.io/instance='
alias kctp='kc top pods --containers -l app.kubernetes.io/instance='
alias azlogin='az login'
alias awslogin='aws sso login'
alias awsconfigure='aws configure sso --profile '
alias awssso='aws configure sso-session'
alias show='fastfetch'
alias nix-shell='nix-shell --run zsh'
alias nixs='nix-shell --run zsh'
alias nixr='sudo nixos-rebuild switch'
alias nixb='nixos-rebuild build'
alias sprite='~/.local/bin/sprite'
alias explorer='yazi'
alias exp='yazi'

# ========================================
# Functions
# ========================================
# Attach to the session named after the current folder, or start a fresh one with the given layout
_zellij_dev() {
  local name="${PWD:t}"
  name="${name//[^A-Za-z0-9_-]/-}"
  if zellij list-sessions -n 2>/dev/null | grep "^$name " | grep -vq EXITED; then
    zellij attach "$name"
  else
    zellij delete-session "$name" >/dev/null 2>&1
    zellij --session "$name" --new-session-with-layout "$1"
  fi
}
dev() { _zellij_dev dev-copilot }
devc() { _zellij_dev dev-claude }

vi() {
  if [ $# -eq 0 ]; then
    nvim .;
  else
    nvim "$@";
  fi;
}

venv() {
   virtual_env_path="$HOME/.virtualenvs/${PWD##*/}"
   if [ ! -d "$virtual_env_path" ]; then
     echo "Creating virtual environment..."
     python3 -m venv $virtual_env_path
   fi
   echo "Activating virtual environment..."
   source $virtual_env_path/bin/activate
}

awsexport() {
  echo "Exporting AWS credentials for profile: $AWS_PROFILE"
  eval $(aws configure export-credentials --format env)
}

AWS_SECRETS_FILE="$HOME/.config/secrets/awsenv"
awsctx() {
    local profile

    # Create secrets directory if it doesn't exist
    mkdir -p "$(dirname "$AWS_SECRETS_FILE")"

    # Get profile selection
    profile=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)

    if [ -n "$profile" ]; then
        # Export for current session
        export AWS_PROFILE="$profile"

        # Update secrets file for persistence
        if [ -f "$AWS_SECRETS_FILE" ]; then
            # Remove existing AWS lines
            sed -i '/^export AWS_/d' "$AWS_SECRETS_FILE"
        else
            touch "$AWS_SECRETS_FILE"
            chmod 600 "$AWS_SECRETS_FILE"
        fi

        # Add AWS_PROFILE line
        echo "export AWS_PROFILE=\"$profile\"" >> "$AWS_SECRETS_FILE"

        # Add credential environment variables to secrets file
        if [ -n "$creds" ]; then
            echo "$creds" >> "$AWS_SECRETS_FILE"
        fi
    else
        echo "No profile selected"
    fi
}

ONEPASS_SECRETS_FILE="$HOME/.config/secrets/onepassenv"
oplogin() {
    local session_token
    local account_id

    # Create secrets directory if it doesn't exist
    mkdir -p "$(dirname "$ONEPASS_SECRETS_FILE")"

    echo "Signing in to 1Password..."
    session_token=$(op signin --raw)
    if [ -n "$session_token" ]; then
        # Get the account ID dynamically
        account_id=$(op account list --format=json | jq -r '.[0].user_uuid' 2>/dev/null)

        if [ -z "$account_id" ]; then
            echo "Warning: Could not determine account ID, using generic session variable"
            account_id="default"
        fi

        local session_var="OP_SESSION_$account_id"

        # Export for current session
        export "$session_var=$session_token"

        # Update secrets file for persistence
        if [ -f "$ONEPASS_SECRETS_FILE" ]; then
            # Remove any existing OP_SESSION_* variables
            sed -i '/^export OP_SESSION_.*=/d' "$ONEPASS_SECRETS_FILE"
        else
            touch "$ONEPASS_SECRETS_FILE"
            chmod 600 "$ONEPASS_SECRETS_FILE"
        fi

        echo "export $session_var=\"$session_token\"" >> "$ONEPASS_SECRETS_FILE"

        # Load env vars from ONEPASS
        if [ -f "$HOME/.config/secrets/env" ]; then
            source "$HOME/.config/secrets/env"
        fi

        echo "✅ Signed in to 1Password (session: $session_var)"
    else
        echo "❌ Failed to sign in to 1Password"
        return 1
    fi
}

# ========================================
# Secrets
# ========================================
if [ -f "$HOME/.config/secrets/awsenv" ]; then
    source "$HOME/.config/secrets/awsenv"
fi

if [ -f "$HOME/.config/secrets/onepassenv" ]; then
    source "$HOME/.config/secrets/onepassenv"
fi

# Source Other env vars - manually add these (only if 1Password CLI is logged in)
if op whoami >/dev/null 2>&1 && [ -f "$HOME/.config/secrets/env" ]; then
  source "$HOME/.config/secrets/env"
fi
