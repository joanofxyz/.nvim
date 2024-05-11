local window = require("config.helpers").window

return {
  "luckasRanarison/nvim-devdocs",
  keys = {
    {"<leader>sc", "<cmd>DevdocsOpenCurrentFloat<cr>"},
    {"<leader>sw", "<cmd>DevdocsWrapper<cr>"},
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "docker",
      "git",
      "go",
      "http",
      "jq",
      "kubernetes",
      "lua-5.4",
      "python-3.12",
      "redis",
    },
    previewer_cmd = "glow",
    cmd_args = {"-s", "dracula"},
    float_win = {
      height = window.scale_height(0, 0.7),
      width = window.scale_width(0, 0.8),
    },
    after_open = function(bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>bd!<cr>", {})
      vim.defer_fn(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>gg]],
                                                             true, true, true),
                              "t", false)
      end, 1000)
    end,
  },
}
