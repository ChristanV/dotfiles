local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.font_size = 14

--https://wezterm.org/colorschemes/index.html
--config.color_scheme = 'nord'
config.color_scheme = 'nightfox'

config.window_background_opacity = 0.5 --1.0 for full
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- timeout_milliseconds defaults to 1000 and can be omitted
config.keys = {
  {
      key = 'n',
      mods = 'CTRL|SHIFT',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
      key = 'm',
      mods = 'CTRL|SHIFT',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
      key = 'm',
      mods = 'CTRL|SHIFT',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
      key = 'd',
      mods = 'CTRL|SHIFT',
      action = act.SpawnTab 'CurrentPaneDomain'
  },
  {
      key = 't',
      mods = 'CTRL|SHIFT',
      action = act.SpawnWindow
  },
  {
    key = 'Tab',
    mods = 'SHIFT',
    action = act.ActivateTabRelative(1)
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Next'
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentPane { confirm = true }
  },
  {
    key = 'q',
    mods = 'CTRL|SHIFT',
    action = act.QuitApplication 
  },
  {
    key = 'H',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  {
    key = 'K',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Up', 5 }
  },
  {
    key = 'L',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = act.IncreaseFontSize
  },
  {
    key = 'o',
    mods = 'CTRL|SHIFT',
    action = act.DecreaseFontSize
  },
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = act.ToggleFullScreen
  }
}

-- Set num pad to tab keys
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
