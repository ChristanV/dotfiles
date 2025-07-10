-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require'nvim-tree'.setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    enable = false,
    dotfiles = false,
  },
})

local NAVIGATION = {}

function NAVIGATION.find_file_and_focus()
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
      api.node.open.edit()
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "file", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
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
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function open_nvim_tree(prompt_bufnr, _)
    actions.select_default:replace(function()
      local api = require("nvim-tree.api")

      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local split = {}
      for s in (selection.value .. ":"):gmatch("(.-)" .. ":") do
        table.insert(split, s)
      end
      local path = selection.cwd .. "/" .. split[1]
      api.tree.open()
      api.tree.find_file(path)
      api.node.open.edit()
      vim.api.nvim_win_set_cursor(0, { tonumber(split[2]), tonumber(split[3]) })
    end)
    return true
  end

  require("telescope.builtin").live_grep({
    attach_mappings = open_nvim_tree,
  })
end

function NAVIGATION.toggle_tree()
  local api = require("nvim-tree.api")
  api.tree.toggle({ focus = false })
end

function NAVIGATION.focus_on_current_file(path)
  local api = require("nvim-tree.api")
  api.tree.find_file(path, { focus = true, open = false })
end

local harpoon = require('harpoon')
local harpoon_extensions = require("harpoon.extensions")
harpoon:setup()
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

-- Bind harpoon with nvim tree to focus on file in tree
-- run toggle function before and after selection as workaround to not have
-- flashing text when switching from tree view
function NAVIGATION.harpoon_switch(index)

  local item = harpoon:list():get(index)
  if item then
    NAVIGATION.toggle_tree()
    harpoon:list():select(index)
    NAVIGATION.toggle_tree()
    NAVIGATION.focus_on_current_file(item.value)
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

return NAVIGATION
