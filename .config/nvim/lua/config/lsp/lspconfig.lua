return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    keys = {
      {"<leader>bf", vim.lsp.buf.format},
      {"<leader>gd", vim.lsp.buf.definition},
      {"<leader>gt", vim.lsp.buf.type_definition},
      {"<leader>gi", vim.lsp.buf.implementation},
      {"<leader>rn", vim.lsp.buf.rename},
      {"<leader>ca", vim.lsp.buf.code_action},
      {"<leader>fr", "<cmd>Telescope lsp_references<cr>"},
      {"<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>"},
      {"[d", vim.diagnostic.goto_prev},
      {"]d", vim.diagnostic.goto_next},
      {
        "[D",
        "<cmd>lua require(\"telescope.builtin\").diagnostics({bufnr=0})<cr>",
      },
      {
        "]D",
        "<cmd>lua require(\"telescope.builtin\").diagnostics({bufnr=nil})<cr>",
      },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local config = {
        capabilities = capabilities,
        on_attach = function()
          require("lsp_signature").on_attach()
        end,
      }

      local lspconfig = require("lspconfig")
      lspconfig["bashls"].setup({
        filetypes = {"sh", "bash", "zsh"},
        unpack(config),
      })
      lspconfig["cssls"].setup(config)
      lspconfig["gleam"].setup(config)
      lspconfig["gopls"].setup(config)
      lspconfig["html"].setup(config)
      lspconfig["lua_ls"].setup({
        settings = {Lua = {format = {enable = false}}},
        unpack(config),
      })
      lspconfig["prettierd"].setup(config)
      lspconfig["pyright"].setup(config)
      lspconfig["ruff_lsp"].setup(config)
      lspconfig["rust_analyzer"].setup(config)
      lspconfig["sqlls"].setup(config)
      lspconfig["stylelint_lsp"].setup({
        filetypes = {"css", "scss", "sass", "less", "svelte"},
        unpack(config),
      })
      lspconfig["svelte"].setup(config)
      lspconfig["tsserver"].setup(config)

      vim.cmd("LspStart")
    end,
  },
}
