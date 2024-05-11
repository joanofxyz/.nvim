local M = {}

M.plugins = {
  {
    "nvim-treesitter/playground",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function()
      require("treesitter-context").setup({
        patterns = {default = {"class", "function", "method"}},
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "css",
          "dockerfile",
          "gitignore",
          "glsl",
          "go",
          "gomod",
          "haskell",
          "html",
          "http",
          "hurl",
          "gleam",
          "javascript",
          "jsdoc",
          "json",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rust",
          "scss",
          "sql",
          "supercollider",
          "svelte",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        highlight = {enable = true},
        matchup = {enable = true},
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aC"] = "@class.outer",
              ["iC"] = "@class.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]l"] = "@loop.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[l"] = "@loop.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]L"] = "@loop.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[L"] = "@loop.outer",
            },
          },
        },
      })
    end,
  },
}

return M
