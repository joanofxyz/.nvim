local M = {}

M.plugins = {
  {"rktjmp/lush.nvim"},
  {"rktjmp/shipwright.nvim"},
  {"kyazdani42/nvim-web-devicons"},
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
      options = {theme = "auto"},
      sections = {lualine_c = {{"filename", path = 1}}},
      inactive_sections = {lualine_c = {{"filename", path = 1}}},
    },
  },
}

local theme = "oxocabron"
-- local theme = "oxocabron_light"
-- local theme = "miasma"
vim.cmd("colorscheme " .. theme)

return M
