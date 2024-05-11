local M = {}
M.name = "DevdocsWrapper"
M.opts = {}
M.keys = {}

M.fn = function()
  vim.ui.select(require("nvim-devdocs.config").options.ensure_installed,
                {prompt = "devdocs - select source"}, function(source)
    if source == nil then
      return
    end
    vim.cmd("DevdocsOpenFloat " .. source)
  end)
end

return M
