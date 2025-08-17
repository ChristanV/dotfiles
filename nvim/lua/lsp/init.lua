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

require 'lspconfig'.bashls.setup {
  capabilities = capabilities
}

require 'lspconfig'.nixd.setup {
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
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

require 'lspconfig'.dockerls.setup {
  capabilities = capabilities
}

require 'lspconfig'.jdtls.setup {
  capabilities = capabilities
}

require 'lspconfig'.gopls.setup {
  capabilities = capabilities
}

require 'lspconfig'.ts_ls.setup {
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
}

require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

require 'lspconfig'.yamlls.setup {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
      },
    },
  },
  filetypes = {
    "yaml",
    "yml",
  },
}

require 'lspconfig'.terraformls.setup {
  capabilities = capabilities,
  filetypes = { "terraform" },
  root_dir = function(fname)
    -- Explicitly exclude .tfvars files https://github.com/hashicorp/terraform-ls/issues/1838
    if fname:match("%.tfvars$") or fname:match("%.auto%.tfvars$") then
      return nil
    end
    return require('lspconfig.util').root_pattern('.terraform', '.git', '*.tf')(fname)
  end,
}

require 'lspconfig'.tflint.setup {
  capabilities = capabilities
}

vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

require 'lspconfig'.ansiblels.setup {
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
}

require 'lspconfig'['pyright'].setup {
  capabilities = capabilities,
  flags = lsp_flags,
}

require 'lspconfig'.helm_ls.setup {
  capabilities = capabilities
}

require 'lspconfig'.postgres_lsp.setup {
  capabilities = capabilities
}
