return {
  event = "TextYankPost",
  callback = function()
    vim.highlight.on_yank({timeout = 75})
  end,
}
