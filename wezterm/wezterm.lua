local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.font_size = 14
config.font = wezterm.font 'Hack Nerd Font'

--https://wezterm.org/colorschemes/index.html
config.color_scheme = 'nord'
--config.color_scheme = 'nightfox'

config.window_background_opacity = 0.5 --1.0 for full
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local default_mod = 'CTRL|SHIFT'

-- timeout_milliseconds defaults to 1000 and can be omitted
config.keys = {
  {
      key = 'n',
      mods = default_mod,
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
      key = 'm',
      mods = default_mod,
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
      key = 'd',
      mods = default_mod,
      action = act.SpawnTab 'CurrentPaneDomain'
  },
  {
      key = 't',
      mods = default_mod,
      action = act.SpawnWindow
  },
  {
    key = 'Tab',
    mods = 'ALT|SHIFT',
    action = act.ActivateTabRelative(1)
  },
  {
    key = 'Tab',
    mods = default_mod,
    action = act.ActivatePaneDirection 'Next'
  },
  {
    key = 'Tab',
    mods = 'CTRL',
    action = act.DisableDefaultAssignment --Disable for reuse in neovim 
  },
  {
    key = 'i',
    mods = default_mod,
    action = act.DisableDefaultAssignment --Disable for reuse in neovim 
  },
  {
    key = 'w',
    mods = default_mod,
    action = act.CloseCurrentPane { confirm = true }
  },
  {
    key = 'q',
    mods = default_mod,
    action = act.QuitApplication
  },
  {
    key = 'H',
    mods = default_mod,
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = default_mod,
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  {
    key = 'K',
    mods = default_mod,
    action = act.AdjustPaneSize { 'Up', 5 }
  },
  {
    key = 'L',
    mods = default_mod,
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'i',
    mods = default_mod,
    action = act.IncreaseFontSize
  },
  {
    key = 'o',
    mods = default_mod,
    action = act.DecreaseFontSize
  },
  {
    key = 'f',
    mods = default_mod,
    action = act.ToggleFullScreen
  }
}

-- Set num pad to tab keys
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = default_mod,
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
