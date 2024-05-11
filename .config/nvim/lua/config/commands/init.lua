local M = {}

M.plugins = {}

require("config.commands.auto")

local mappings = require("config.mappings")

local commands = {
  "dbquery",
  "devdocs_wrapper",
  "glow",
  "macro_edit",
  "prettify",
  "visual_qf",
}

for _, command in ipairs(commands) do
  local cmd = require("config.commands." .. command)
  vim.api.nvim_create_user_command(cmd.name, cmd.fn, cmd.opts)
  mappings.set_from_table(cmd.keys)
end

return M
