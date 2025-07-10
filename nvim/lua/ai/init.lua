require('gen').setup({
  model = "qwen2.5-coder:7b",
  url = "localhost",
  port = 11434,
  show_model = true,
  display_mode = "split",
  no_auto_close = true,
  file = false,
  result_filetype = "markdown",
})
