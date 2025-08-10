local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ========================================
-- Appearance
-- ========================================
config.font_size = 16
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

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ========================================
-- Multiplexing
-- ========================================
config.unix_domains = {
  {
    name = 'unix',
  }
}

config.default_gui_startup_args = { 'connect', 'unix' }

-- ========================================
-- Keybindings
-- ========================================
local default_mod = 'CTRL'
local default_shift_mod = 'CTRL|SHIFT'

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
      key = 't',
      mods = default_mod,
      action = act.SpawnTab 'CurrentPaneDomain'
  },
  {
      key = 'd',
      mods = default_mod,
      action = act.SpawnWindow
  },
  {
    key = ',',
    mods = default_mod,
    action = act.ActivatePaneDirection 'Next'
  },
  {
    key = 'Tab',
    mods = default_mod,
    action = act.ActivateTabRelative(1)
  },
  {
    key = 'Tab',
    mods = default_shift_mod,
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'i',
    mods = default_mod,
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
    action = act.CloseCurrentPane { confirm = false }
  },
  {
    key = 'q',
    mods = default_mod,
    action = act.QuitApplication
  },
  {
    key = 'H',
    mods = default_shift_mod,
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = default_shift_mod,
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  {
    key = 'K',
    mods = default_shift_mod,
    action = act.AdjustPaneSize { 'Up', 5 }
  },
  {
    key = 'L',
    mods = default_shift_mod,
    action = act.AdjustPaneSize { 'Right', 5 },
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
