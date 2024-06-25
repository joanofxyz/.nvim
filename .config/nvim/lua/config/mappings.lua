local M = {}

M.common = {
  {mode = "n", key = "<C-d>", cmd = "<C-d>zz"},
  {mode = "n", key = "<C-u>", cmd = "<C-u>zz"},
  {mode = "n", key = "*", cmd = "*zz"},
  {mode = "n", key = "#", cmd = "#zz"},
  {mode = "n", key = "n", cmd = "nzz"},
  {mode = "n", key = "N", cmd = "Nzz"},
  {mode = "n", key = "<C-s>", cmd = "<cmd>w<cr>"},
  {mode = "i", key = "<C-s>", cmd = "<Esc><cmd>w<cr>"},
  {mode = "n", key = "<leader>p", cmd = "\"*p"},
  {mode = "v", key = "<leader>p", cmd = "\"*p"},
  {mode = "n", key = "<leader>P", cmd = "\"*P"},
  {mode = "v", key = "<leader>P", cmd = "\"*P"},
  {mode = "n", key = "<leader>y", cmd = "\"*y"},
  {mode = "n", key = "<leader>Y", cmd = "\"*Y"},
  {mode = "v", key = "<leader>y", cmd = "\"*y"},
  {mode = "v", key = "<leader>Y", cmd = "\"*Y"},
  {mode = "n", key = "<leader><leader>p", cmd = "\"_dP"},
  {mode = "x", key = "<leader><leader>p", cmd = "\"_dP"},
  {mode = "n", key = "<leader>cn", cmd = vim.cmd.cnext},
  {mode = "n", key = "<leader>cp", cmd = vim.cmd.cprev},
  {mode = "n", key = "<leader>bd", cmd = "<cmd>%bd!|e#<cr>"},
}

---@param t Keybinding[]
M.set_from_table = function(t)
  for i = 1, #t do
    vim.keymap.set(t[i].mode, t[i].key, t[i].cmd, {remap = false})
  end
end

return M
