#!/usr/bin/env bash

dotfiles=(
	"nvim"
	"starship-config"
	"hypr"
	"wezterm"
	"ghostty"
	"waybar"
	"dunst"
	"xdg-desktop-portal"
	"rofi"
  "zed"
  "zellij"
  "lazygit"
)

for dot in "${dotfiles[@]}"; do
	echo "Setup symlink for $dot"
	target=~/.config/"$dot"
	if [ -L "$target" ]; then
		echo "$dot already linked"
	elif [ -e "$target" ]; then
		echo "WARNING: $target exists and is not a symlink — skipping. Move or remove it, then re-run." >&2
	else
		ln -sfn ~/dotfiles/"$dot" "$target"
		echo "Linked $dot"
	fi
done
