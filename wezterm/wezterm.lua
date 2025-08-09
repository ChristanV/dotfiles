local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

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

-- Multiplexing
-- https://wezterm.org/multiplexing.html#ssh-domains
config.unix_domains = {
  {
    -- The name; must be unique amongst all domains
    name = 'nixos',

    -- The path to the socket.  If unspecified, a reasonable default
    -- value will be computed.

    -- socket_path = "/some/path",

    -- If true, do not attempt to start this server if we try and fail to
    -- connect to it.

    -- no_serve_automatically = false,

    -- If true, bypass checking for secure ownership of the
    -- socket_path.  This is not recommended on a multi-user
    -- system, but is useful for example when running the
    -- server inside a WSL container but with the socket
    -- on the host NTFS volume.

    -- skip_permissions_check = false,
  },
}

-- config.default_gui_startup_args = { 'connect', 'nixos' }

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'my.server',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = '192.168.1.1',
    -- The username to use on the remote host
    username = 'chrisdevops',
  },
}


return config
