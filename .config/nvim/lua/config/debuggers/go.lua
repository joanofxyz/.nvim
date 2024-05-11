local helpers = require("config.helpers")

return {
  setup = function(dap)
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
    dap.adapters.delve = {
      type = "server",
      port = "${port}",
      executable = {command = "dlv", args = {"dap", "-l", "127.0.0.1:${port}"}},
    }
    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
        mode = "debug",
        args = helpers.prompts.get_arguments,
        buildFlags = {"-tags", "dynamic"},
      },
      {
        type = "delve",
        name = "Debug file",
        request = "launch",
        program = helpers.get_file,
        mode = "debug",
        args = helpers.prompts.get_arguments,
        buildFlags = {"-tags", "dynamic"},
      },
      {
        type = "delve",
        name = "Debug test",
        request = "launch",
        program = helpers.prompts.get_file,
        mode = "test",
        buildFlags = {"-tags", "dynamic", "-count=1"},
      },
    }
  end,
}
