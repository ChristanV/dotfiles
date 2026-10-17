local M = {}

local c = {
  dark   = '#2e3440',
  seg    = '#3b4252',
  muted  = '#616e88',
  fg     = '#d8dee9',
  frost  = '#8fbcbb',
  cyan   = '#88c0d0',
  blue   = '#81a1c1',
  red    = '#bf616a',
  orange = '#d08770',
  yellow = '#ebcb8b',
  green  = '#a3be8c',
  purple = '#b48ead',
}

local modes = {
  n = { 'NORMAL', 'Normal' },
  no = { 'O-PENDING', 'Normal' },
  i = { 'INSERT', 'Insert' },
  ic = { 'INSERT', 'Insert' },
  v = { 'VISUAL', 'Visual' },
  V = { 'V-LINE', 'Visual' },
  ['\22'] = { 'V-BLOCK', 'Visual' },
  s = { 'SELECT', 'Visual' },
  S = { 'S-LINE', 'Visual' },
  ['\19'] = { 'S-BLOCK', 'Visual' },
  R = { 'REPLACE', 'Replace' },
  Rv = { 'V-REPLACE', 'Replace' },
  c = { 'COMMAND', 'Command' },
  r = { 'PROMPT', 'Command' },
  ['!'] = { 'SHELL', 'Terminal' },
  t = { 'TERMINAL', 'Terminal' },
}

-- Powerline glyphs (Nerd Font), same style as zellij's compact-bar
local ARROW_R, THIN_R = '\238\130\176', '\238\130\177' -- U+E0B0, U+E0B1
local ARROW_L, THIN_L = '\238\130\178', '\238\130\179' -- U+E0B2, U+E0B3

local section_bg, sep_cache = {}, {}

local function set_highlights()
  local hl = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end

  -- Bar itself stays transparent so the terminal opacity shows through
  hl('StatusLine', { fg = c.fg, bg = 'NONE' })
  hl('StatusLineNC', { fg = c.muted, bg = 'NONE' })

  local sections = {
    StlNormal   = { fg = c.dark, bg = c.blue, bold = true },
    StlInsert   = { fg = c.dark, bg = c.cyan, bold = true },
    StlVisual   = { fg = c.dark, bg = c.cyan, bold = true },
    StlReplace  = { fg = c.dark, bg = c.red, bold = true },
    StlCommand  = { fg = c.dark, bg = c.blue, bold = true },
    StlTerminal = { fg = c.dark, bg = c.cyan, bold = true },
    StlRecord   = { fg = c.dark, bg = c.orange, bold = true },
    StlSeg      = { fg = c.fg, bg = c.seg },
  }
  section_bg = {}
  sep_cache = {}
  for name, opts in pairs(sections) do
    hl(name, opts)
    section_bg[name] = opts.bg
  end
  -- Thin divider between two grey sections
  hl('StlThin', { fg = c.dark, bg = c.seg })

  -- Coloured text inside the grey StlSeg sections
  hl('StlBranch', { fg = c.cyan, bg = c.seg, bold = true })
  hl('StlGitAdd', { fg = c.green, bg = c.seg })
  hl('StlGitChange', { fg = c.blue, bg = c.seg })
  hl('StlGitDelete', { fg = c.red, bg = c.seg })
  hl('StlModified', { fg = c.blue, bg = c.seg, bold = true })
  hl('StlReadonly', { fg = c.red, bg = c.seg })
  hl('StlError', { fg = c.red, bg = c.seg })
  hl('StlWarn', { fg = c.blue, bg = c.seg })
  hl('StlInfo', { fg = c.blue, bg = c.seg })
  hl('StlHint', { fg = c.frost, bg = c.seg })
  hl('StlLsp', { fg = c.cyan, bg = c.seg })
  hl('StlCopilot', { fg = c.frost, bg = c.seg })
  hl('StlMuted', { fg = c.muted, bg = c.seg })
end

-- Statusline strings treat % as special
local function esc(s)
  return (s:gsub('%%', '%%%%'))
end

local function section(group, body)
  return { group = group, body = body }
end

-- Arrow highlight: glyph in the colour of one section, background of the other
local function sep_group(fg_group, bg_group)
  local name = 'StlSep' .. fg_group .. (bg_group or 'None')
  if not sep_cache[name] then
    vim.api.nvim_set_hl(0, name, { fg = section_bg[fg_group], bg = bg_group and section_bg[bg_group] or 'NONE' })
    sep_cache[name] = true
  end
  return name
end

local function same_bg(a, b)
  return b and section_bg[a.group] == section_bg[b.group]
end

-- Left side: [A]▶[B]▶[C]▶
local function render_left(list)
  local out = {}
  for i, s in ipairs(list) do
    local nxt = list[i + 1]
    table.insert(out, ('%%#%s# %s '):format(s.group, s.body))
    if same_bg(s, nxt) then
      table.insert(out, '%#StlThin#' .. THIN_R)
    else
      table.insert(out, ('%%#%s#%s'):format(sep_group(s.group, nxt and nxt.group), ARROW_R))
    end
  end
  return table.concat(out)
end

-- Right side: ◀[A]◀[B]◀[C]
local function render_right(list)
  local out = {}
  for i, s in ipairs(list) do
    local prev = list[i - 1]
    if same_bg(s, prev) then
      table.insert(out, '%#StlThin#' .. THIN_L)
    else
      table.insert(out, ('%%#%s#%s'):format(sep_group(s.group, prev and prev.group), ARROW_L))
    end
    table.insert(out, ('%%#%s# %s '):format(s.group, s.body))
  end
  return table.concat(out)
end

local function compact(...)
  local out = {}
  for i = 1, select('#', ...) do
    local s = select(i, ...)
    if s then table.insert(out, s) end
  end
  return out
end

local function mode()
  local m = vim.api.nvim_get_mode().mode
  local info = modes[m] or modes[m:sub(1, 1)] or { m, 'Normal' }
  return info, 'Stl' .. info[2]
end

local function git()
  local branch = vim.b.gitsigns_head
  if not branch or branch == '' then return nil end

  local out = '%#StlBranch# ' .. esc(branch)
  local d = vim.b.gitsigns_status_dict or {}
  if (d.added or 0) > 0 then out = out .. ' %#StlGitAdd#+' .. d.added end
  if (d.changed or 0) > 0 then out = out .. ' %#StlGitChange#~' .. d.changed end
  if (d.removed or 0) > 0 then out = out .. ' %#StlGitDelete#-' .. d.removed end
  return section('StlSeg', out)
end

local function file()
  local name = vim.fn.expand('%:~:.')
  if name == '' then name = '[No Name]' end

  local ok, devicons = pcall(require, 'nvim-web-devicons')
  local icon = ok and devicons.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'), { default = true }) or ''

  local out = '%#StlSeg#' .. icon .. ' ' .. esc(name)
  if vim.bo.modified then out = out .. ' %#StlModified#●' end
  if vim.bo.readonly or not vim.bo.modifiable then out = out .. ' %#StlReadonly#' end
  return section('StlSeg', out)
end

local function recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then return nil end
  return section('StlRecord', ' @' .. reg)
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local s = vim.diagnostic.severity
  local parts = {}
  local function add(sev, group, icon)
    local n = counts[sev] or 0
    if n > 0 then table.insert(parts, ('%%#%s#%s %d'):format(group, icon, n)) end
  end
  add(s.ERROR, 'StlError', '')
  add(s.WARN, 'StlWarn', '')
  add(s.INFO, 'StlInfo', '')
  add(s.HINT, 'StlHint', '󰌵')
  if #parts == 0 then return nil end
  return section('StlSeg', table.concat(parts, ' '))
end

local COPILOT_ICON = '\239\146\184' -- U+F4B8 nf-oct-copilot

local function lsp()
  local names, copilot = {}, false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    -- copilot.vim runs as an LSP client; show it as an icon instead of its name
    if client.name:lower():find('copilot') then
      copilot = true
    else
      table.insert(names, client.name)
    end
  end
  if #names == 0 and not copilot then return nil end

  local out = {}
  if #names > 0 then table.insert(out, '%#StlLsp# ' .. esc(table.concat(names, ', '))) end
  if copilot then table.insert(out, '%#StlCopilot#' .. COPILOT_ICON) end
  return section('StlSeg', table.concat(out, ' '))
end

local function file_info()
  local parts = {}
  if vim.bo.filetype ~= '' then table.insert(parts, vim.bo.filetype) end
  table.insert(parts, vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding)
  table.insert(parts, vim.bo.expandtab and ('spaces:' .. vim.fn.shiftwidth()) or ('tab:' .. vim.bo.tabstop))

  local size = vim.fn.getfsize(vim.fn.expand('%:p'))
  if size > 0 then
    local units, i = { 'B', 'K', 'M', 'G' }, 1
    while size >= 1024 and i < #units do
      size, i = size / 1024, i + 1
    end
    table.insert(parts, (i == 1 and '%d%s' or '%.1f%s'):format(size, units[i]))
  end

  if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text' then
    table.insert(parts, vim.fn.wordcount().words .. ' words')
  end

  return section('StlSeg', '%#StlMuted#' .. esc(table.concat(parts, ' · ')))
end

local function position(group)
  return section(group, '%l:%c  %L')
end

function M.render()
  local info, group = mode()

  if vim.bo.filetype == 'NvimTree' then
    return table.concat({
      render_left(compact(
        section(group, info[1]),
        section('StlSeg', ' ' .. esc(vim.fn.fnamemodify(vim.fn.getcwd(), ':~')))
      )),
      '%#StatusLine#%=',
      render_right(compact(git())),
    })
  end

  return table.concat({
    render_left(compact(section(group, info[1]), git(), file())),
    '%#StatusLine#%=',
    '%S ',
    render_right(compact(recording(), lsp(), file_info(), position(group))),
  })
end

function M.setup()
  vim.o.laststatus = 3
  vim.o.showmode = false
  vim.o.statusline = "%!v:lua.require'statusline'.render()"

  set_highlights()
  local group = vim.api.nvim_create_augroup('Statusline', { clear = true })
  -- Re-apply after any :colorscheme, which clears custom highlights
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_highlights })

  -- Redraw when things the statusline shows change outside normal redraws
  vim.api.nvim_create_autocmd(
    { 'DiagnosticChanged', 'LspAttach', 'LspDetach', 'ModeChanged', 'RecordingEnter' },
    { group = group, callback = function() vim.cmd.redrawstatus() end }
  )
  -- reg_recording() is still set during RecordingLeave, so redraw after it
  vim.api.nvim_create_autocmd('RecordingLeave', {
    group = group,
    callback = function() vim.schedule(function() vim.cmd.redrawstatus() end) end,
  })
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'GitSignsUpdate',
    callback = function() vim.cmd.redrawstatus() end,
  })
end

M.setup()

return M
