-- Telescope mappings <leader> => \
vim.keymap.set('n', '<leader>r', ':edit<CR>', { desc = 'Reload buffer from disk', noremap = true, silent = false })
vim.keymap.set('n', '<leader>R', ':restart<CR>', { desc = 'Restart neovim', noremap = true, silent = false })

-- Nvim tree
local navigation = require('navigation')
vim.keymap.set('n', '<S-t>', navigation.toggle_tree, { desc = 'Toggle Tree', noremap = true, silent = true })
--vim.keymap.set('n', '<Tab>', ':NvimTreeFocus<CR>', { desc = 'Focus tree', noremap = true, silent = true })

-- Telescope
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<C-g>', navigation.find_file_and_focus)
vim.keymap.set('n', '<C-b>', navigation.find_directory_and_focus)
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', 'f', function() builtin.live_grep { search_dirs = { vim.fn.expand('%:p') } } end)
vim.keymap.set('n', '<C-f>', navigation.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Harpoon
vim.keymap.set('n', '<leader>a', navigation.harpoon_add)
vim.keymap.set('n', '<C-e>', navigation.harpoon_toggle_quick_menu)

vim.keymap.set('n', '1', function() navigation.harpoon_switch(1) end)
vim.keymap.set('n', '2', function() navigation.harpoon_switch(2) end)
vim.keymap.set('n', '3', function() navigation.harpoon_switch(3) end)
vim.keymap.set('n', '4', function() navigation.harpoon_switch(4) end)
vim.keymap.set('n', '5', function() navigation.harpoon_switch(5) end)

-- Open new windows
vim.keymap.set('n', '<S-n>', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  vim.cmd('vnew ' .. current_file)
end, { desc = 'Open current file in vertical split' })
vim.keymap.set('n', '<S-m>', ':split<CR>', { desc = 'Open current file in vertical split' })

-- General remappings
vim.keymap.set('n', '<S-Tab>', '<C-w>w', { desc = 'Cycle through windows', noremap = true, silent = true })
vim.keymap.set('n', '<S-l>', ':wincmd l<CR>', { desc = 'Move to the right window', noremap = true, silent = true })
vim.keymap.set('n', '<S-h>', ':wincmd h<CR>', { desc = 'Move to the left window', noremap = true, silent = true })
vim.keymap.set('n', '<S-k>', ':wincmd k<CR>', { desc = 'Move to the top window', noremap = true, silent = true })
vim.keymap.set('n', '<S-j>', ':wincmd j<CR>', { desc = 'Move to the bottom window', noremap = true, silent = true })
vim.keymap.set('n', '<S-w>', ':q<CR>', { desc = 'Quit window', noremap = true, silent = true })
vim.keymap.set('n', 'q', ':q<CR>', { desc = 'Quit window', noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = false }) --vim.keymap.sea('n', 'q', 'r', { noremap = true, silent = true }) --remap record

-- LSP goto's & diagnostic
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.get_next, opts)
vim.keymap.set('n', ']d', vim.diagnostic.get_prev, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Space>', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '<S-up>', navigation.jump_to_definition, { noremap = true, silent = true })
vim.keymap.set('n', '<S-down>', function() navigation.jump_file('<C-o>') end, { noremap = true, silent = true })
vim.keymap.set('n', '<S-right>', function() navigation.jump_file('<C-i>') end, { noremap = true, silent = true })
vim.keymap.set('n', '<S-left>', function() navigation.jump_file('<C-o>') end, { noremap = true, silent = true })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Format buffer: CLI formatter if one is defined for the filetype, otherwise LSP
local cli_formatters = {
  json = { 'jq', '.' },
  lua = function()
    return { 'stylua', '--search-parent-directories', '--stdin-filepath', vim.api.nvim_buf_get_name(0), '-' }
  end,
  nix = { 'nixfmt' },
  python = { 'ruff', 'format', '-' },
  -- --filename lets shfmt pick the dialect and any .editorconfig for the file
  sh = function()
    return { 'shfmt', '--filename', vim.api.nvim_buf_get_name(0), '-' }
  end,
  bash = function()
    return { 'shfmt', '--filename', vim.api.nvim_buf_get_name(0), '-' }
  end,
  -- no stdin support; `file` makes format_buffer pass a temp file path instead
  sql = { 'postgres-language-server', 'format', '--write', file = '.sql' },
  terraform = { 'terraform', 'fmt', '-' },
  ['terraform-vars'] = { 'terraform', 'fmt', '-' },
  yaml = { 'yq', '.', '-' },
}

local function format_buffer()
  local cmd = cli_formatters[vim.bo.filetype]
  if type(cmd) == 'function' then
    cmd = cmd()
  end
  if not cmd or vim.fn.executable(cmd[1]) == 0 then
    -- fall back to LSP; skip silently when no attached client can format (e.g. plain text)
    if #vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/formatting' }) > 0 then
      vim.lsp.buf.format({ async = false })
    end
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local result, output
  if cmd.file then
    local tmp = vim.fn.tempname() .. cmd.file
    vim.fn.writefile(lines, tmp)
    result = vim.system(vim.list_extend(vim.list_slice(cmd), { tmp })):wait()
    output = table.concat(vim.fn.readfile(tmp), '\n')
    vim.fn.delete(tmp)
  else
    result = vim.system(cmd, { stdin = table.concat(lines, '\n') .. '\n' }):wait()
    output = result.stdout
  end
  if result.code ~= 0 then
    vim.notify(cmd[1] .. ': ' .. (result.stderr ~= '' and result.stderr or result.stdout or ''), vim.log.levels.ERROR)
    return
  end
  local formatted = vim.split(output:gsub('\n$', ''), '\n', { plain = true })
  if not vim.deep_equal(lines, formatted) then
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted)
    vim.fn.winrestview(view)
  end
end

vim.keymap.set('n', '<leader>f', format_buffer, { desc = '[F]ormat buffer', noremap = true, silent = true })
vim.keymap.set('n', 's', function()
  format_buffer()
  vim.cmd('write')
end, { desc = 'Format and write file', noremap = true, silent = false })
