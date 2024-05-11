local M = {}

M.plugins = {
  {"saadparwaiz1/cmp_luasnip", dependencies = {"L3MON4D3/LuaSnip"}},
  {
    "L3MON4D3/LuaSnip",
    keys = {
      {"<leader>n", "<Plug>luasnip-next-choice", mode = "s"},
      {"<leader>N", "<Plug>luasnip-prev-choice", mode = "s"},
      {
        "<leader>s",
        "<cmd>lua require('luasnip.extras.select_choice')()<cr>",
        mode = "s",
      },
    },
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.set_config({history = true, enable_autosnippets = true})
      require("config.snippets.go")
    end,
  },
}

return M
