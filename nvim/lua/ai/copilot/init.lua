require('CopilotChat').setup({
  highlight_headers = false,
  error_header = '> [!ERROR] Error',

  window = {
    layout = 'vertical',
    width = 0.5,
  },

  headers = {
    user = '👤 You',
    assistant = '🤖 Copilot',
    tool = '🔧 Tool',
  },

  separator = '━━',
  auto_fold = true,
})

-- Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})
