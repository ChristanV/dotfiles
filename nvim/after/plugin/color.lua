require('nightfox').setup({
  groups = {
    all = {
      -- Hover over with cursor and :Inspect for details

      -- Terraform:
      ['@keyword.hcl'] = { fg = 'palette.orange.bright' },
      ['@variable.builtin.terraform'] = { link = '@lsp.type.type.terraform' },
      ['@variable.builtin.hcl'] = { link = '@lsp.type.type.terraform' },

      ['@lsp.type.enumMember.terraform'] = { fg = 'palette.green' },
      ['@label.terraform'] = { fg = 'palette.green' },
      ['@lsp.mod.defaultLibrary.terraform'] = { fg = 'palette.green' },
      ['@lsp.typemod.enumMember.defaultLibrary'] = { fg = 'palette.green' },

      -- Python:
      ['@keyword.return.python'] = { link = '@keyword' },
      ['@variable.builtin.python'] = { fg = 'palette.orange.bright' },
      ['@function.builtin.python'] = { fg = 'palette.orange.bright' },

      -- Lua
      ['@variable.builtin.lua'] = { fg = 'palette.orange.bright' },
      ['@function.builtin.lua'] = { fg = 'palette.orange.bright' },

      -- Bash
      ['@variable.builtin.bash'] = { fg = 'palette.orange.bright' },
      ['@function.builtin.bash'] = { fg = 'palette.orange.bright' },
      ['@variable.parameter.bash'] = { fg = 'palette.white' },
      ['@function.call.bash'] = { fg = 'palette.orange.bright' },

    },
  },
})


require('nord').setup({
  transparent = true,
})

vim.cmd("colorscheme nord")

vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#434c5e' })
