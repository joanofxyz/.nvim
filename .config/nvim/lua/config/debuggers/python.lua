local helpers = require("config.helpers")

return {
  setup = function(dap)
    local python_path = vim.fn.stdpath("data") ..
                          "/mason/packages/debugpy/venv/bin/python"
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
    dap.adapters.python = function(cb, _)
      cb({
        type = "executable",
        command = python_path,
        args = {"-m", "debugpy.adapter"},
        options = {source_filetype = "python"},
      })
    end
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Debug",
        program = "${file}",
        pythonPath = helpers.prompts.get_python_path,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug (with arguments)",
        program = "${file}",
        args = helpers.prompts.get_arguments,
        pythonPath = helpers.prompts.get_python_path,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug file",
        program = helpers.get_file,
        pythonPath = helpers.prompts.get_python_path,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug file (with arguments)",
        program = helpers.prompts.get_file,
        args = helpers.prompts.get_arguments,
        pythonPath = helpers.prompts.get_python_path,
      },
    }
  end,
}
