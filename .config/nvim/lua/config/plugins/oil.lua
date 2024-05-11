local window = require("config.helpers").window

return {
  "stevearc/oil.nvim",
  keys = {{"<leader>o", "<cmd>Oil --float<cr>"}},
  opts = {
    delete_to_trash = true,
    view_options = {show_hidden = true},
    keymaps = {["q"] = "actions.close"},
    columns = {"icon", "permissions", "size", "mtime"},
    float = {
      max_height = window.scale_height(0, 0.5),
      max_width = window.scale_width(0, 0.5),
    },
  },
}
