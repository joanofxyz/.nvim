local M = {}
M.name = "Glow"
M.opts = {}
M.keys = {{mode = "n", key = "<leader>gg", cmd = "<cmd>Glow<cr>"}}

local window = require("config.helpers").window

-- https://github.com/luckasRanarison/nvim-devdocs/blob/1ab982d3e069d191d9157b897c8b70cf48b7f77a/lua/nvim-devdocs/operations.lua#L229
M.fn = function()
  local job = require("plenary.job")

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].ft = "markdown"
  local chan = vim.api.nvim_open_term(bufnr, {})
  window.create_float({
    bufnr = bufnr,
    exit_key = "q",
    float_opts = {height = 0.7, width = 0.8},
  })

  local previewer = job:new({
    command = "glow",
    args = {"-s", "~/.config/.themes/oxocabron/oxocabron.json"},
    on_stdout = vim.schedule_wrap(function(_, data)
      if not data then
        return
      end
      local output_lines = vim.split(data, "\n", {})
      for _, line in ipairs(output_lines) do
        pcall(function()
          vim.api.nvim_chan_send(chan, line .. "\r\n")
        end)
      end
    end),
    writer = lines,
  })

  previewer:start()
end

return M
