local M = {}
M.name = "VisualQf"
M.opts = {}
M.keys = {{mode = "v", key = "<leader>qf", cmd = "<cmd>VisualQf<cr>"}}

local split = require("config.helpers").strings.split

-- must have the format <filepath>|<row> col <col>| <text>
M.fn = function()
  vim.cmd("noau normal! \"vy\"")
  local lines = vim.fn.getreg("v")
  local qf_entries = {}
  local split_lines = split(lines, "\n")
  for _, l in ipairs(split_lines) do
    local split_line = split(l, "|")
    local split_location = split(split_line[2], " ")
    table.insert(qf_entries, {
      filename = split_line[1],
      lnum = split_location[1],
      col = split_location[3],
      text = split_line[3],
      type = "I",
    })
  end
  vim.fn.setqflist(qf_entries, "r")
  vim.cmd.copen()
end

return M
