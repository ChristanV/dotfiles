-- Telescope mappings <leader> => \
vim.keymap.set('n', '<leader>r', ':source<CR>', { desc = 'Reload neovim', noremap = true, silent = false })

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
vim.keymap.set('n', 'f',function() builtin.live_grep { search_dirs = { vim.fn.expand('%:p') } } end)
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
vim.keymap.set('n', 's', ':w<CR>', { desc = "write file", noremap = true, silent = false })
vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = false })
--vim.keymap.sea('n', 'q', 'r', { noremap = true, silent = true }) --remap record

-- AI
vim.keymap.set('n', '<leader>c', ':Gen Chat<CR>', { desc = 'Open gen Chat', noremap = true, silent = false })
vim.keymap.set('n', '<leader>g', ':ChatGPT<CR>', { desc = 'Open Chatgpt Chat', noremap = true, silent = false })
vim.keymap.set('n', '<leader>ss', ':SupermavenStart<CR>', { desc = 'Start Super maven', noremap = true, silent = false })
vim.keymap.set('n', '<leader>st', ':SupermavenStop<CR>', { desc = 'Stop Super maven', noremap = true, silent = false })
vim.keymap.set('n', '<leader>sf', ':SupermavenUseFree<CR>', { desc = 'Use Supermaven Free tier', noremap = true, silent = false })
vim.keymap.set('n', '<leader>sp', ':SupermavenUsePro<CR>', { desc = 'Use supermaven pro tier', noremap = true, silent = false })

-- LSP goto's & diagnostic
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.get_next, opts)
vim.keymap.set('n', ']d', vim.diagnostic.get_prev, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<Space>', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Space>', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '<S-up>', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<S-down>', '<C-o>' , { noremap = true, silent = true })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Testing
--vim.keymap.set('n', '<Tab>', ':echo hello', { noremap = true, silent = true })
