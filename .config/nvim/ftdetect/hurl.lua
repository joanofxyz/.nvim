vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.hurl"},
  callback = function()
    vim.cmd.setfiletype("hurl")
  end,
})
