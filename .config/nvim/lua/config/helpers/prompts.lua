local function get_file()
  return coroutine.create(function(dap_run_co)
    local file = ""
    vim.ui.input({prompt = "File: "}, function(input)
      file = input or vim.fn.getcwd()
      coroutine.resume(dap_run_co, file)
    end)
  end)
end

-- https://github.com/leoluz/nvim-dap-go/blob/36abe1d320cb61bfdf094d4e0fe815ef58f2302a/lua/dap-go.lua#L26
local function get_arguments()
  return coroutine.create(function(dap_run_co)
    local args = {}
    vim.ui.input({prompt = "Arguments: "}, function(input)
      args = vim.split(input or "", " ")
      coroutine.resume(dap_run_co, args)
    end)
  end)
end

-- https://github.com/mfussenegger/nvim-dap-python/blob/3dffa58541d1f52c121fe58ced046268c838d802/lua/dap-python.lua#L82
local function get_python_path()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    return venv_path .. "/bin/python"
  end

  venv_path = os.getenv("CONDA_PREFIX")
  if venv_path then
    return venv_path .. "/bin/python"
  end

  for root in coroutine.wrap(function()
    local cwd = vim.fn.getcwd()
    coroutine.yield(cwd)

    local wincwd = vim.fn.getcwd(0)
    if wincwd ~= cwd then
      coroutine.yield(wincwd)
    end

    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    for _, client in ipairs(get_clients()) do
      if client.config.root_dir then
        coroutine.yield(client.config.root_dir)
      end
    end
  end)() do
    for _, folder in ipairs({"venv", ".venv", "env", ".env"}) do
      local path = root .. "/" .. folder
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == "directory" then
        return path .. "/bin/python"
      end
    end
  end

  return nil
end

return {
  get_file = get_file,
  get_arguments = get_arguments,
  get_python_path = get_python_path,
}
