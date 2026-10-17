local M = {}

vim.o.cmdheight = 0             -- statusline sits at the very bottom
vim.o.ruler = false             -- position is already in the statusline
vim.o.showcmdloc = 'statusline' -- partial commands (2d, "a, ...) shown via %S in lua/statusline
vim.opt.shortmess:append('sIc') -- no intro screen, no "search hit BOTTOM", no completion chatter

local c = {
  dark   = '#2e3440',
  seg    = '#3b4252',
  border = '#4c566a',
  fg     = '#d8dee9',
  cyan   = '#88c0d0',
  blue   = '#81a1c1',
  red    = '#bf616a',
  yellow = '#ebcb8b',
  green  = '#a3be8c',
}

local function set_highlights()
  local hl = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hl('MsgArea', { fg = c.fg, bg = 'NONE' })
  hl('ErrorMsg', { fg = c.red, bold = true })
  hl('WarningMsg', { fg = c.yellow })
  hl('MoreMsg', { fg = c.green })
  hl('Question', { fg = c.blue })
  hl('ModeMsg', { fg = c.cyan, bold = true })

  -- noice popups (noice only sets these as defaults, so ours win)
  hl('NoiceCmdlinePopup', { fg = c.fg, bg = c.seg })
  hl('NoiceCmdlinePopupBorder', { fg = c.blue, bg = c.seg })
  hl('NoiceCmdlinePopupTitle', { fg = c.cyan, bg = c.seg, bold = true })
  hl('NoiceCmdlineIcon', { fg = c.cyan, bg = c.seg })
  hl('NoiceCmdlinePopupBorderSearch', { fg = c.blue, bg = c.seg })
  hl('NoiceCmdlineIconSearch', { fg = c.blue, bg = c.seg })
  hl('NoiceMini', { fg = c.fg, bg = c.seg })
  hl('NoicePopup', { fg = c.fg, bg = c.seg })
  hl('NoicePopupBorder', { fg = c.blue, bg = c.seg })
end

set_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('Cmdline', { clear = true }),
  callback = set_highlights,
})

function M.setup()
  require('noice').setup({
    cmdline = {
      view = 'cmdline_popup', -- centered floating cmdline
    },
    messages = {
      view = 'mini',
      view_error = 'mini',
      view_warn = 'mini',
    },
    notify = {
      view = 'mini',
    },
    -- Leave LSP UI alone; cmp already handles signature help
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = {
      long_message_to_split = true,
    },
  })
end

return M
