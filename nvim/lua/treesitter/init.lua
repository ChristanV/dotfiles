-- Parsers are compiled locally and need the tree-sitter CLI and a C compiler
require('nvim-treesitter').install({
  'bash', 'diff', 'dockerfile', 'gitcommit', 'go', 'gomod', 'hcl', 'helm',
  'java', 'javascript', 'json', 'lua', 'markdown', 'markdown_inline', 'nix',
  'python', 'query', 'sql', 'terraform', 'typescript', 'vim', 'vimdoc', 'vue',
  'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
