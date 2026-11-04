#!/usr/bin/env sh
# Toggle gaming mode: fullscreen the focused window and remove the secondary
# monitors from the layout so the cursor is physically confined to the primary.
#
# Usage: gaming-mode.sh [OUTPUT:POSITION ...]
# Positions are used to restore the layout when gaming mode is turned off.

STATE=/tmp/hypr-gaming-mode

[ $# -eq 0 ] && set -- "DP-2:2560x0" "HDMI-A-1:320x1440"

if [ -f "$STATE" ]; then
  for mon in "$@"; do
    hyprctl eval "hl.monitor({ output = \"${mon%%:*}\", disabled = false, mode = \"preferred\", position = \"${mon#*:}\", scale = 1 })" >/dev/null
  done
  hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))' >/dev/null
  rm -f "$STATE"
  notify-send "Gaming mode OFF"
else
  hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))' >/dev/null
  for mon in "$@"; do
    hyprctl eval "hl.monitor({ output = \"${mon%%:*}\", disabled = true })" >/dev/null
  done
  touch "$STATE"
  notify-send "Gaming mode ON"
fi
