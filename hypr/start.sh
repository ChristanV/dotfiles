#!/usr/bin/env bash

# Init wallpaper deamon
swww-daemon &

# Applets - pkgs.networkmanagerapplet
nm-applet --indicator &

# The bar
waybar &

dunst &

# Polkit authentication daemon
systemctl --user start hyprpolkitagen &

pipewire 
