local M = {}

M.plugins = {
  {"folke/neodev.nvim", opts = {}},
  {"williamboman/mason.nvim", opts = {}},
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {"williamboman/mason.nvim"},
    opts = {automatic_installation = true},
  },
  unpack(require("config.lsp.lsp_signature")),
  unpack(require("config.lsp.lspconfig")),
  unpack(require("config.lsp.null_ls")),
}

return M
