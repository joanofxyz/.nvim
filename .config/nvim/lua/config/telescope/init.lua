local M = {}

M.plugins = {
  {
    "folke/todo-comments.nvim",
    keys = {{"<leader>ft", "<cmd>TodoTelescope<cr>"}},
    opts = {signs = false, keywords = {NOTE = {alt = {}}}},
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {"<leader>fb", "<cmd>Telescope buffers<cr>"},
      {"<leader>ff", "<cmd>Telescope find_files<cr>"},
      {"<leader>fg", "<cmd>Telescope live_grep<cr>"},
      {"<leader>fh", "<cmd>Telescope help_tags<cr>"},
      {"<leader>fm", "<cmd>Telescope man_pages<cr>"},
      {"<leader>fj", "<cmd>Telescope jumplist<cr>"},
      {"<leader>fk", "<cmd>Telescope keymaps<cr>"},
      {"<leader>fq", "<cmd>Telescope quickfix<cr>"},
      {"<leader>fy", "<cmd>Telescope registers<cr>"},
      {"<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>"},
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "^node_modules/",
            "^node_modules\\",
            "^venv/",
            "^venv\\",
          },
          layout_strategy = "vertical",
          layout_config = {mirror = true},
          mappings = {
            n = {
              ["<s-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          ["ui-select"] = {require("telescope.themes").get_dropdown()},
        },
      })
    end,
  },
}

return M
