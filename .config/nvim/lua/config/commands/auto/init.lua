local group = vim.api.nvim_create_augroup("GeneralGroup", {clear = true})
local commands = {"textyankpost", "saveindicator"}

for _, command in ipairs(commands) do
  local cmd = require("config.commands.auto." .. command)
  vim.api.nvim_create_autocmd(cmd.event,
                              {callback = cmd.callback, group = group})
end

return nil
