local M = {}

local go = require("config.debuggers.go")
local python = require("config.debuggers.python")

M.plugins = {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {"<leader>dc", "<cmd>lua require('dapui').close()<cr>"},
      {"<leader>dg", "<cmd>lua require('dap').continue()<cr>"},
      {"<leader>dh", "<cmd>lua require('dap').step_back()<cr>"},
      {"<leader>dj", "<cmd>lua require('dap').step_into()<cr>"},
      {"<leader>dk", "<cmd>lua require('dap').step_out()<cr>"},
      {"<leader>dl", "<cmd>lua require('dap').step_over()<cr>"},
    },
    config = function()
      local dap = require("dap")
      go.setup(dap)
      python.setup(dap)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {"mfussenegger/nvim-dap"},
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {"python", "delve"},
        automatic_installation = true,
      })
    end,
  },
  {"nvim-neotest/nvim-nio"},
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      local function toggle_breakpoint()
        dap.toggle_breakpoint(nil, nil, nil)
      end
      vim.keymap.set("n", "<leader><cr>", toggle_breakpoint)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated["dapui_config"] = function()
        vim.ui.select({"Yes", "No"}, {prompt = "Debugger exited. Close?"},
                      function(choice)
          if string.lower(choice) == "yes" then
            dapui.close()
          end
        end)
      end
    end,
  },
}

return M
