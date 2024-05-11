local M = {}

M.plugins = {
  {"hrsh7th/cmp-buffer", dependencies = {"hrsh7th/nvim-cmp"}},
  {"hrsh7th/cmp-path", dependencies = {"hrsh7th/nvim-cmp"}},
  {"hrsh7th/cmp-nvim-lsp", dependencies = {"hrsh7th/nvim-cmp"}},
  {"hrsh7th/cmp-nvim-lua", dependencies = {"hrsh7th/nvim-cmp"}},
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "kristijanhusak/vim-dadbod-completion",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                 vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                            col)
                   :match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Esc>"] = cmp.mapping.abort(),
          ["<C-space>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.mapping.confirm({select = false}),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.expand_or_jumpable(-1) then
              ls.jump(-1)
            else
              fallback()
            end
          end, {"i", "s"}),
        }),
        sources = cmp.config.sources({
          {name = "nvim_lua"},
          {name = "nvim_lsp"},
          {name = "path"},
          {name = "luasnip"},
          -- {name = 'buffer', keyword_length = 5},
        }),
      })

      cmp.setup.filetype("sql", {sources = {{name = "vim-dadbod-completion"}}})
      cmp.setup
        .filetype("mysql", {sources = {{name = "vim-dadbod-completion"}}})
      cmp.setup
        .filetype("redis", {sources = {{name = "vim-dadbod-completion"}}})
    end,
  },
}

return M
