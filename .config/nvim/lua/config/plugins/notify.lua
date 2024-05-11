return {
  "rcarriga/nvim-notify",
  keys = {{"<leader>fn", "<cmd>Telescope notify<cr>"}},
  config = function()
    local notify = require("notify")
    notify.setup({timeout = 100})
    vim.notify = notify
  end,
}
