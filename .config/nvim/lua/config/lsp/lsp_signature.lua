return {
  {
    "ray-x/lsp_signature.nvim",
    opts = {},
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if vim.tbl_contains({"null-ls"}, client.name) then
            return
          end
          require("lsp_signature").on_attach(opts, args.buf)
        end,
      })
    end,
  },
}
