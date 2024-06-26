local M = {}

-- plugins with extensive/verbose config
local plugins = {"devdocs", "notify", "oil"}

M.plugins = {
  {"nvim-lua/plenary.nvim", lazy = false},
  {"lewis6991/gitsigns.nvim"},
  {"tpope/vim-dadbod"},
  {"kristijanhusak/vim-dadbod-completion"},
  {"tpope/vim-fugitive", keys = {{"<leader>gb", "<cmd>Git blame<cr>"}}},
  {"j-hui/fidget.nvim", event = "LspAttach", tag = "legacy", opts = {}},
  {"windwp/nvim-autopairs", opts = {disable_filetype = {"TelescopePrompt"}}},
  {
    "stevearc/dressing.nvim",
    opts = {input = {relative = "win", insert_only = false, prefer_width = 0.4}},
  },
}

for _, plugin in ipairs(plugins) do
  local p = require("config.plugins." .. plugin)
  table.insert(M.plugins, p)
end

return M
