-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require 'nvim-tree'.setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
    root_folder_label = false,
    highlight_git = "name",
    indent_markers = {
      enable = true,
    },
    icons = {
      diagnostics_placement = "signcolumn",
    },
  },
  git = {
    timeout = 5000,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  filters = {
    enable = false,
    dotfiles = false,
  },
  actions = {
    change_dir = {
      restrict_above_cwd = true,
    },
  },
  modified = {
    enable = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  -- Don't watch big generated dirs for changes (still shown in the tree)
  filesystem_watchers = {
    ignore_dirs = {
      "/node_modules",
      "/\\.devenv",
      "/\\.terraform",
      "/\\.terragrunt",
      "/\\.terragrunt-cache",
    },
  },
})

local NAVIGATION = {}

-- The tree follows the opened file via update_focused_file
function NAVIGATION.find_file_and_focus()
  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "file", "--hidden", "--exclude", ".git/*" },
  })
end

function NAVIGATION.find_directory_and_focus()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function open_nvim_tree(prompt_bufnr, _)
    actions.select_default:replace(function()
      local api = require("nvim-tree.api")

      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local path = selection.cwd .. "/" .. selection.value
      api.tree.open()
      api.tree.find_file(path)
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
  })
end

function NAVIGATION.live_grep()
  require("telescope.builtin").live_grep()
end

function NAVIGATION.toggle_tree()
  local api = require("nvim-tree.api")
  api.tree.toggle({ focus = false })
end

local harpoon = require('harpoon')
local harpoon_extensions = require("harpoon.extensions")
harpoon:setup()
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

function NAVIGATION.harpoon_switch(index)
  local item = harpoon:list():get(index)
  if item then
    harpoon:list():select(index)
  else
    print('Harpoon selection is empty')
  end
end

function NAVIGATION.harpoon_add()
  harpoon:list():add()
end

function NAVIGATION.harpoon_toggle_quick_menu()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end

function NAVIGATION.jump_to_definition()
  vim.lsp.buf.definition({
    on_list = function(options)
      if options.items and #options.items > 0 then
        -- Jump straight to the first definition instead of opening a list
        vim.fn.setqflist({}, ' ', options)
        vim.cmd('cfirst')
      end
    end
  })
end

function NAVIGATION.jump_file(cmd)
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

return NAVIGATION
