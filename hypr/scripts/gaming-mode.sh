#!/usr/bin/env sh
# Toggle gaming mode: fullscreen the focused window and remove the secondary
# monitor from the layout so the cursor is physically confined to the primary.

STATE=/tmp/hypr-gaming-mode
MON2="${1:-DP-2}"

if [ -f "$STATE" ]; then
  hyprctl eval "hl.monitor({ output = \"$MON2\", disabled = false, mode = \"preferred\", position = \"auto\", scale = \"auto\" })" >/dev/null
  hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))' >/dev/null
  rm -f "$STATE"
  notify-send "Gaming mode OFF"
else
  hyprctl eval 'hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))' >/dev/null
  hyprctl eval "hl.monitor({ output = \"$MON2\", disabled = true })" >/dev/null
  touch "$STATE"
  notify-send "Gaming mode ON"
fi
