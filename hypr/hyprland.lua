-- Hyprland Lua config (Hyprland >= 0.55).
-- See https://wiki.hypr.land/Configuring/Start/

------------------
--- VARIABLES ----
------------------

local wallpaper       = "/home/christan/Pictures/Wallpapers/neon.jpg"
local monitor1        = "DP-1"
local monitor2        = "DP-2"

local terminal        = "ghostty"
local browser         = "google-chrome-stable"
local fileManager     = "ghostty --title=yazi -e yazi"
local menu            = "rofi -show drun"
local hyprlock        = "hyprlock"
local passwordManager = "1password"


------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- (Defaults; declare explicit monitors here if you want fixed modes.)
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})


-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
  hl.exec_cmd(hyprlock)
  hl.exec_cmd(terminal)
  -- Legacy [workspace 2 silent] / [workspace 5 silent] prefixes translate
  -- to per-spawn window rules passed as the second arg to exec_cmd.
  hl.exec_cmd(browser, { workspace = "2 silent" })
  hl.exec_cmd(passwordManager, { workspace = "5 silent" })
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("waybar")
  hl.exec_cmd("dunst")
  hl.exec_cmd("hyprpolkitagent")
  hl.exec_cmd("awww-daemon & until awww query > /dev/null 2>&1; do sleep 0.1; done && awww img " .. wallpaper)
  hl.exec_cmd([[gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"]])
  hl.exec_cmd([[gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"]])
  hl.exec_cmd("wl-clip-persist --clipboard regular")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")


-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,
    border_size      = 2,

    col              = {
      active_border   = "rgba(268bd2ee)",
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = true,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 2,

    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 1,
    disable_hyprland_logo   = true,
  },

  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "",
    kb_rules     = "",
    follow_mouse = 1,
    sensitivity  = 0,
    touchpad     = {
      natural_scroll = false,
    },
  },
})


-- Bezier curves & animations
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })


-----------------------
---- WORKSPACE RULES --
-----------------------
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({ workspace = "1", monitor = monitor1 })
hl.workspace_rule({ workspace = "2", monitor = monitor1 })
hl.workspace_rule({ workspace = "3", monitor = monitor2 })
hl.workspace_rule({ workspace = "4", monitor = monitor2 })
hl.workspace_rule({ workspace = "5", monitor = monitor1 })


------------------
---- DEVICES -----
------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SHIFT + ALT"

-- App launchers / window actions
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind("CTRL + SHIFT + L", hl.dsp.exec_cmd(hyprlock))

-- Move / swap windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Focus
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces: switch (mainMod + N) and move active window (CTRL + SHIFT + N)
for i = 1, 10 do
  local key = i % 10 -- 10 -> 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind("CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Waybar restart
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("pkill waybar && waybar"))

-- Screen recording (wf-recorder + slurp). Toggle: region on first press, stop on second.
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(
  [[sh -c 'mkdir -p "$HOME/Videos"; if pgrep -x wf-recorder >/dev/null; then pkill -INT -x wf-recorder; ]] ..
  [[notify-send "Recording saved"; else geom=$(slurp) || exit 0; ]] ..
  [[wf-recorder -g "$geom" -f "$HOME/Videos/rec-$(date +%Y%m%d-%H%M%S).mp4" & ]] ..
  [[notify-send "Recording started"; fi']]))

-- swww / awww wallpaper reload
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("awww img " .. wallpaper))

-- Scratchpad (special workspace)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse-drag move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (bindel: locked + repeating)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Player keys (bindl: locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
  name           = "suppress-maximize",
  match          = { class = ".*" },
  suppress_event = "maximize",
})
