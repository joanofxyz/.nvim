local M = {}

M.plugins = {
  {
    "akinsho/toggleterm.nvim",
    keys = {{"<leader>lg", "<cmd>lua LazygitToggle()<cr>"}},
    config = function()
      require("config.terminal.lazygit")
    end,
  },
}

return M
