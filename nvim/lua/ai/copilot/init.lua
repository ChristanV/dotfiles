-- Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

-- Retrigger Copilot suggestion with Ctrl+Space
vim.keymap.set('i', '<C-Space>', '<Cmd>call copilot#Suggest()<CR>', { silent = true, desc = 'Copilot: retrigger suggestion' })
