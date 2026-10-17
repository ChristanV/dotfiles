local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'neovim/nvim-lspconfig',
  { 'EdenEast/nightfox.nvim',                          priority = 1000 },
  { 'gbprod/nord.nvim',                                priority = 1000 },
  { 'ellisonleao/gruvbox.nvim',                        lazy = true },
  { 'AlexvZyl/nordic.nvim',                            lazy = true },

  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function() require('treesitter') end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function() require('whichkey') end,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'mfussenegger/nvim-lint',
    config = function() require('linting') end,
  },

  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  {
    'petertriho/cmp-git',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('cmp_git').setup() end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ft = 'markdown',
    config = function() require('markdown') end,
  },

  -- setup() is called in lua/uml
  { url = 'https://gitlab.com/itaranto/plantuml.nvim', version = '*' },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Centered floating cmdline + message views (config in lua/cmdline)
  {
    'folke/noice.nvim',
    version = '*', -- tagged releases only
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('cmdline').setup() end,
  },

  -- AI Plugins
  'github/copilot.vim',
}, {
  install = { colorscheme = { 'nord' } },
  change_detection = { notify = false },
  rocks = { enabled = false },
})
