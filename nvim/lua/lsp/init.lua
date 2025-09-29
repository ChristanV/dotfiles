-- https://github.com/neovim/nvim-lspconfig
local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

local lsp_flags = {
  debounce_text_changes = 150,
}

vim.diagnostic.config({
  virtual_text = {
    --severity = vim.diagnostic.severity.WARN, -- only show warnings
    source = true, -- show source like "pyright"
    spacing = 2,
    prefix = "●",
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.config('bashls', {
  capabilities = capabilities
})
vim.lsp.enable('bashls')

vim.lsp.config('nixd', {
  capabilities = capabilities,
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      }
    }
  }
})
vim.lsp.enable('nixd')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.lsp.config('dockerls', {
  capabilities = capabilities,
})
vim.lsp.enable('dockerls')

--vim.lsp.config('jdtls', {
--  capabilities = capabilities,
--  cmd = { 'jdtls' },
--})
--vim.lsp.enable('jdtls')

vim.lsp.config('gopls', {
  capabilities = capabilities,
})
vim.lsp.enable('gopls')

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  flags = lsp_flags,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
})
vim.lsp.enable('ts_ls')

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})
vim.lsp.enable('lua_ls')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.lsp.config('yamlls', {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
        "/*.k8s.yaml",
      },
    },
  },
  filetypes = {
    "yaml",
    "yml",
  },
})
vim.lsp.enable('yamlls')

vim.lsp.config('terraformls', {
  filetypes = { 'terraform', 'terraform-vars' },
  root_dir = vim.fs.root(0, { '.terraform', '.git' }),
})

vim.lsp.enable('terraformls')

vim.lsp.config('tflint', {
  capabilities = capabilities
})
vim.lsp.enable('tflint')

vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

vim.lsp.config('ansiblels', {
  capabilities = capabilities,
  filetypes = { "yml" },
  settings = {
    ansible = {
      path = "ansible"
    },
    executionEnvironment = {
      enabled = false
    },
    python = {
      interpreterPath = "python"
    },
    validation = {
      enabled = true,
      lint = {
        enabled = true,
        path = "ansible-lint"
      }
    }
  }
})
vim.lsp.enable('ansiblels')

vim.lsp.config('pyright', {
  capabilities = capabilities,
  flags = lsp_flags,
})
vim.lsp.enable('pyright')

vim.lsp.config('helm_ls', {
  capabilities = capabilities,
})
vim.lsp.enable('helm_ls')

vim.lsp.config('postgres_lsp', {
  capabilities = capabilities,
})
vim.lsp.enable('postgres_lsp')
