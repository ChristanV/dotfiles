-- https://github.com/nvim-telescope/telescope.nvim
require 'telescope'.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--follow",        -- Follow symbolic links
      "--hidden",        -- Search for hidden files
      "--no-heading",    -- Don't group matches by each file
      "--with-filename", -- Print the file path with the matched lines
      "--line-number",   -- Show line numbers
      "--column",        -- Show column numbers
      "--smart-case",    -- Smart case search

      "--glob=!**/.git/*",
      "--glob=!**/.idea/*",
      "--glob=!**/.vscode/*",
      "--glob=!**/build/*",
      "--glob=!**/dist/*",
      "--glob=!**/yarn.lock",
      "--glob=!**/package-lock.json",
      "--glob=**/.github/**", -- Allow searching github workflows
      "--glob=**"
    },
    layout_config = {
      horizontal = { width = 0.9, height = 0.9 }
    },
  },
})
