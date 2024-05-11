return {
  event = "BufWritePost",
  callback = function()
    local ns = vim.api.nvim_create_namespace("saveindicator")
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    vim.highlight.range(0, ns, "IncSearch", {0, 0}, {
      vim.api.nvim_buf_line_count(0) - 1,
      #vim.api.nvim_buf_get_lines(0, -2, -1, 0)[1],
    })
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end, 75)
  end,
}
