#!/usr/bin/env bash

# Init wallpaper deamon
swww init &
# swww image ~/Wallpapers/gruvbox.png &

# Applets - pkgs.networkmanagerapplet
nm-applet --indicator &

# The bar
waybar &

dunst
