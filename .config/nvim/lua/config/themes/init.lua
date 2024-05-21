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

if tonumber(vim.fn.strftime("%H")) < 18 then
  vim.cmd.colorscheme("oxocabron_light")
else
  vim.cmd.colorscheme("oxocabron")
end

return M
