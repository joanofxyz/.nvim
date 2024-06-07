local M = {}
M.name = "Prettify"
M.opts = {nargs = 1}
M.keys = {
  {mode = "n", key = "<leader>bj", cmd = "<cmd>Prettify json<cr>"},
  {mode = "n", key = "<leader>bp", cmd = "<cmd>Prettify py<cr>"},
  {mode = "n", key = "<leader>b<leader>", cmd = "<cmd>Prettify empty<cr>"},
}

local function get_filename(filetype)
  return vim.fn.stdpath("cache") .. "/prettify." .. filetype
end

local function null_ls(bufnr)
  local null_ls_id = require("null-ls.client").start_client()
  if null_ls_id == nil then
    vim.notify("failed to start null_ls_id", vim.logs.levels.ERROR)
    return true
  end
  vim.lsp.buf_attach_client(bufnr, null_ls_id)
end

local filetype_mapping = {
  json = {"json", null_ls, nil},
  py = {"python", nil, nil},
  empty = {
    "",
    nil,
    function()
    end,
  },
}
local function handle_quit(bufnr, ignored_events)
  vim.api.nvim_del_augroup_by_name("prettify")
  vim.api.nvim_set_option_value("eventignore", ignored_events, {})
  vim.api.nvim_buf_delete(bufnr, {force = true})
end

local helpers = require("config.helpers").window

M.fn = function(args)
  local filetype = args.args
  local lsp_handler, lang, wrapper
  for t, tuple in pairs(filetype_mapping) do
    if filetype == t then
      lang = tuple[1]
      lsp_handler = tuple[2]
      wrapper = tuple[3]
      break
    end
  end
  if lang == nil then
    vim.notify("language '" .. filetype .. "' not implemented",
               vim.log.levels.ERROR)
    return
  end

  local ignored_events = vim.api.nvim_get_option_value("eventignore", {})
  local bufnr, _ = helpers.create_float({
    float_opts = {title = "prettifying '" .. lang .. "'", relative = "editor"},
    keys = {
      {
        mode = "n",
        key = "q",
        cmd = function()
          handle_quit(0, ignored_events)
        end,
      },
      {
        mode = "n",
        key = "<leader>bd",
        cmd = function()
          local text = vim.base64.decode(
                         vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})[1])
          vim.api.nvim_buf_set_lines(0, 0, -1, true, {text})
          vim.lsp.buf.format()
        end,
      },
      {
        mode = "n",
        key = "<leader>be",
        cmd = function()
          local text = vim.base64.encode(
                         vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})[1])
          vim.api.nvim_buf_set_lines(0, 0, -1, true, {text})
          vim.lsp.buf.format()
        end,
      },
    },
    on_buf_create = function(bufnr)
      vim.api.nvim_set_option_value("buftype", "", {buf = bufnr})
      vim.api.nvim_set_option_value("filetype", lang, {buf = bufnr})
      vim.api.nvim_set_option_value("eventignore", "BufWritePost", {})
      vim.api.nvim_create_augroup("prettify", {})
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = "prettify",
        buffer = bufnr,
        once = true,
        callback = function()
          if lang == "" then
            return
          end
          local path = get_filename(filetype)
          vim.cmd("silent write! " .. path)
          vim.defer_fn(function()
            local text
            if wrapper then
              text = wrapper(bufnr)
            else
              text = vim.fn.getreg()
            end
            vim.api.nvim_paste(text, false, -1)
            vim.lsp.buf.format()
          end, 150)
        end,
      })
      vim.api.nvim_create_autocmd("BufDelete", {
        group = "prettify",
        once = true,
        callback = function()
          handle_quit(bufnr, ignored_events)
        end,
      })
    end,
  })

  if lsp_handler ~= nil then
    local err = lsp_handler(bufnr)
    if err ~= nil then
      handle_quit(bufnr, ignored_events)
      return
    end
  end
end

return M
