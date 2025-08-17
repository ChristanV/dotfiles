#!/usr/bin/env bash

dotfiles=(
  "nvim"
  "starship-config"
  "hypr"
  "wezterm"
  "waybar"
  "xdg-desktop-portal"
  "rofi"
)

for dot in "${dotfiles[@]}"; do
  echo "Setup symlink for $dot"
  if [ ! -L ~/.config/"$dot" ]; then
    ln -sfn ~/dotfiles/"$dot" ~/.config/"$dot"
    echo "Linked $dot"
  else
    echo "$dot already linked"
  fi
done
