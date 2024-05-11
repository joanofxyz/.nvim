local M = {}
M.name = "MacroEdit"
M.opts = {nargs = 1}
M.keys = {}

local keys = {
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "*",
  "+",
}

for _, k in ipairs(keys) do
  table.insert(M.keys, 1, {
    mode = "n",
    key = "<leader>q" .. k,
    cmd = "<cmd>MacroEdit " .. k .. "<cr>",
  })
end

local helpers = require("config.helpers").window

M.fn = function(args)
  local register = args.args
  helpers.create_float({
    float_opts = {
      title = "editing '" .. register .. "' macro",
      height = 1,
      relative = "editor",
    },
    keys = {
      {
        mode = "n",
        key = "q",
        cmd = function()
          local data = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1]
          vim.fn.setreg(register, data)
          vim.api.nvim_buf_delete(0, {})
        end,
      },
    },
    exit_key = "<Esc>",
  })

  local data = vim.fn.getreg(register)
  vim.api.nvim_paste(data, false, -1)
end

return M
