local lint = require('lint')

-- Only lint GitHub workflow files; actionlint errors on other YAML
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
  pattern = { '*/.github/workflows/*.yml', '*/.github/workflows/*.yaml' },
  callback = function()
    lint.try_lint('actionlint')
  end,
})
