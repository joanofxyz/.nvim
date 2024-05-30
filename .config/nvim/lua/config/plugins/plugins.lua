local M = {}

-- plugins with extensive/verbose config
local plugins = {"devdocs", "notify", "oil"}

M.plugins = {
  {"nvim-lua/plenary.nvim", lazy = false},
  {"tpope/vim-dadbod"},
  {"kristijanhusak/vim-dadbod-completion"},
  -- {"andymass/vim-matchup"},
  {"theprimeagen/vim-be-good"},
  {"numToStr/Comment.nvim", opts = {}},
  {"j-hui/fidget.nvim", event = "LspAttach", tag = "legacy", opts = {}},
  {"windwp/nvim-autopairs", opts = {disable_filetype = {"TelescopePrompt"}}},
  {
    "lewis6991/gitsigns.nvim",
    keys = {{"<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>"}},
    opts = {numhl = true, current_line_blame_opts = {delay = 100}},
  },
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
