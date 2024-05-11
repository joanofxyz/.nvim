local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
})
function LazygitToggle()
  lazygit:toggle()
end

return nil
