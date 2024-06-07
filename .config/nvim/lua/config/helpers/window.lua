---@param winnr integer
---@param scale number
---@return integer
local function scale_height(winnr, scale)
  return math.max(math.floor(vim.api.nvim_win_get_height(winnr) * scale), 1)
end

---@param winnr integer
---@param scale number
---@return integer
local function scale_width(winnr, scale)
  return math.max(math.floor(vim.api.nvim_win_get_width(winnr) * scale), 1)
end

---@param opts {bufnr?: number, start_in_insert?: boolean, keys?: Keybinding[], exit_key?: string, on_buf_create?: BufHook, float_opts?: FloatOpts}
---@return integer, integer
local function create_float(opts)
  local bufnr = opts.bufnr or vim.api.nvim_create_buf(false, true)
  if opts.on_buf_create then
    opts.on_buf_create(bufnr)
  end

  local keys = opts.keys or {}
  for _, key in ipairs(keys) do
    vim.keymap.set(key.mode, key.key, key.cmd, {buffer = bufnr})
  end
  if opts.exit_key then
    vim.keymap.set("n", opts.exit_key, function()
      vim.api.nvim_buf_delete(bufnr, {force = true})
    end, {buffer = bufnr})
  end

  local relative = opts.float_opts and opts.float_opts.relative or "win"
  local win_width = relative == "editor" and
                      vim.api.nvim_get_option_value("columns", {}) or
                      vim.api.nvim_win_get_width(0)
  local win_height = relative == "editor" and
                       vim.api.nvim_get_option_value("lines", {}) or
                       vim.api.nvim_win_get_height(0)
  local float_width = win_width / 2
  local float_height = win_height / 2

  local float_opts = {
    row = (win_height - float_height) / 2,
    col = (win_width - float_width) / 2,
    width = math.max(math.floor(float_width), 1),
    height = math.max(math.floor(float_height), 1),
    relative = "win",
    border = "rounded",
    style = "minimal",
  }
  for k, v in pairs(opts.float_opts) do
    if k == "width" and v % 1 ~= 0 then
      v = math.max(math.floor(win_width * v), 1)
      float_opts.col = math.max((win_width - v) / 2, 1)
    elseif k == "height" and v % 1 ~= 0 then
      v = math.max(math.floor(win_height * v), 1)
      float_opts.row = math.max((win_height - v) / 2, 1)
    end
    float_opts[k] = v
  end

  local winnr = vim.api.nvim_open_win(bufnr, true, float_opts)
  if opts.start_in_insert then
    vim.api.nvim_feedkeys("i", "n", false)
  end
  return bufnr, winnr
end

return {
  create_float = create_float,
  scale_height = scale_height,
  scale_width = scale_width,
}
