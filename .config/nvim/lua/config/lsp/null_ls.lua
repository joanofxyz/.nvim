return {
  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = {"jose-elias-alvarez/null-ls.nvim"},
    opts = {automatic_installation = true, automatic_setup = true},
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.formatting.beautysh.with({extra_args = {"-i", "2"}}),
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = {"svelte"},
        }),
        null_ls.builtins.formatting.lua_format.with({
          extra_args = {
            "--indent-width=2",
            "--tab-width=2",
            "--continuation-indent-width=2",
            "--single-quote-to-double-quote",
            "--chop-down-table",
            "--chop-down-kv-table",
            "--extra-sep-at-table-end",
            "--align-table-field",
            "--break-after-table-lb",
            "--break-before-table-rb",
            "--no-keep-simple-function-one-line",
            "--no-keep-simple-control-block-one-line",
          },
        }),
      }
      null_ls.setup({sources = sources})
    end,
  },
}
