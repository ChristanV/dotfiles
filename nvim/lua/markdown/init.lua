require('render-markdown').setup({
  file_types = { 'markdown' },
  completions = { lsp = { enabled = true } },
  heading = {
    width = 'block',
    left_pad = 1,
    right_pad = 2,
  },
  code = {
    width = 'block',
    left_pad = 1,
    right_pad = 2,
  },
  checkbox = {
    unchecked = { icon = '󰄱 ' },
    checked = { icon = '󰱒 ' },
  },
})

vim.keymap.set('n', '<leader>m', ':RenderMarkdown toggle<CR>',
  { desc = 'Toggle markdown render', noremap = true, silent = true })
