local M = {}
M.name = "DBQuery"
M.opts = {}
M.keys = {{mode = "n", key = "<leader>fd", cmd = "<cmd>DBQuery<cr>"}}

-- example .zshrc configuration
-- export DBQ_QUERIES_PATH="<path>/queries" # directory with queries by database (queries/<database>/<query_name>.sql)
-- export DBQ_DATABASES_PATH="<path>/dbq"   # file with database credentials separated by a newline
-- _dbq_env() {
--   if [[ "$#" -ne 1 || ("$1" != "dev" && "$1" != "stg" && "$1" != "prd") ]]; then
--     echo "usage: dbq_env <dev | stg | prd>"
--     return 2
--   fi
--
--   DB_USERNAME=
--   declare -A DBQ_PASSWORDS
--   DBQ_PASSWORDS=(
--     ["dev"]=""
--     ["stg"]=""
--     ["prd"]=""
--   )
--
--   DBQ_ENV="$1"
--   DBQ_PASSWORD=${DBQ_PASSWORDS[$DBQ_ENV]}
--
--   DBQ_DATABASES=""
--   DBQ_DATABASES="redis=redis://localhost:6379\n$DBQ_DATABASES"
--   DBQ_DATABASES="some_database=jdbc:mysql://$DB_USERNAME:$DBQ_PASSWORD@127.0.0.1:1080\n$DBQ_DATABASES"
--   echo "$DBQ_DATABASES" > "$DBQ_DATABASES_PATH"
-- }

local path, sd, query_float, update_line_count
local helpers = require("config.helpers").window
local LB_UI = "\r"
local LB_FILE = "\n"

local function short_path(full_path)
  return string.gsub(full_path, ".+/", "")
end

local function list_dir(path_dir)
  local query_dir = path_dir
  if not query_dir:exists() or not query_dir:is_dir() then
    return {}
  end

  local filenames = sd.scan_dir(query_dir:make_relative())
  local files = {}
  for _, filename in ipairs(filenames) do
    if string.sub(short_path(filename), 1, 1) ~= "_" then
      table.insert(files, filename)
    end
  end

  return files
end

local function write_file(filepath, filename, text)
  if not filepath:exists() then
    filepath:mkdir()
  end

  local save_path = path:new(filepath, filename)
  save_path:write(table.concat(text, LB_FILE), "w")

  return save_path
end

local function update_buffer(text, bufnr)
  local lines = {}
  for line in string.gmatch(text, "[^\n\r]+") do
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function perform_query(db_url, query)
  local augroup = vim.api.nvim_create_augroup("dbq", {})
  vim.api.nvim_create_autocmd("BufAdd", {
    group = augroup,
    pattern = "*.dbout",
    once = true,
    callback = function(event)
      local bufnr = event.buf
      vim.keymap.set("n", "q", function()
        vim.api.nvim_del_augroup_by_id(augroup)
        vim.api.nvim_buf_delete(bufnr, {})
      end, {buffer = bufnr})

      vim.schedule(function()
        local winnr = vim.fn.win_findbuf(bufnr)[1]
        helpers.create_float({
          bufnr = bufnr,
          exit_key = "q",
          float_opts = {
            title = "dbquery - result",
            width = 0.9,
            relative = "editor",
          },
        })
        vim.api.nvim_win_close(winnr, true)
      end)
    end,
  })

  -- might be redundant but still here in case something errors out and we didn't handle it properly
  vim.api.nvim_create_autocmd("BufDelete", {
    group = augroup,
    pattern = "*.dbout",
    once = true,
    callback = function(_)
      vim.api.nvim_del_augroup_by_id(augroup)
    end,
  })

  if query ~= nil then
    vim.cmd("DB " .. db_url .. " " .. query)
  end
end

local function load_query_from_file(db, url, path_queries, bufnr)
  local queries = list_dir(path:new(path_queries, db))
  if #queries == 0 then
    vim.notify("no queries found", vim.log.levels.ERROR)
    query_float(db, url, path_queries, bufnr)
    return
  end

  vim.ui.select(queries, {
    prompt = "dbquery - select file",
    format_item = function(item)
      return short_path(item)
    end,
  }, function(filepath, _)
    if filepath == nil then
      query_float(db, url, path_queries, bufnr)
      return
    end

    local query = path:new(filepath):readlines()
    if query == nil then
      vim.notify("invalid query", vim.log.levels.ERROR)
      query_float(db, url, path_queries, bufnr)
      return
    end

    update_buffer(table.concat(query, LB_UI), bufnr)
    query_float(db, url, path_queries, bufnr)
  end)
end

update_line_count = function(bufnr)
  local win_buf = vim.api.nvim_win_get_buf(0)
  if win_buf == bufnr then
    local height = vim.api.nvim_win_text_height(0, {})["all"]
    vim.api.nvim_win_set_height(0, height)
  end
end

query_float = function(db, url, path_queries, float_bufnr)
  helpers.create_float({
    exit_key = "q",
    bufnr = float_bufnr,
    float_opts = {
      title = "dbquery - " .. db .. " query",
      height = 1,
      relative = "editor",
    },
    on_buf_create = function(bufnr)
      if float_bufnr ~= nil then
        return
      end

      if string.find(url, "sql://") ~= nil then
        local ok, err = pcall(function()
          vim.g.db = url
          vim.api.nvim_set_option_value("filetype", "mysql", {buf = bufnr})
        end)
        if not ok then
          vim.schedule(function()
            vim.api.nvim_buf_delete(bufnr, {})
            vim.notify(err or "failed to connect to database",
                       vim.log.levels.ERROR)
          end)
          return
        end
      end

      vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
        buffer = bufnr,
        callback = function(_)
          update_line_count(bufnr)
        end,
      })

      vim.keymap.set("n", "<cr>", function()
        local query = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.api.nvim_buf_delete(bufnr, {})
        perform_query(url, table.concat(query, LB_UI))
        write_file(path:new(path_queries, db), "_last", query)
      end, {buffer = bufnr})

      vim.keymap.set("n", "<leader>oo", function()
        vim.api.nvim_win_hide(0)
        load_query_from_file(db, url, path_queries, bufnr)
      end, {buffer = bufnr})

      vim.keymap.set("n", "<leader>rr", function()
        local filepath = path:new(path_queries, db, "_last")
        if not filepath:exists() then
          vim.notify("no previous query for database " .. db,
                     vim.log.levels.ERROR)
          return
        end

        local query = filepath:readlines(filepath)
        if query == nil then
          vim.notify("invalid query", vim.log.levels.ERROR)
          return
        end

        update_buffer(table.concat(query, LB_FILE), bufnr)
      end, {buffer = bufnr})

      vim.keymap.set("n", "<C-s>", function()
        local query = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.api.nvim_win_hide(0)
        vim.ui.input({prompt = "dbquery - save filename"}, function(query_name)
          if query_name then
            local save_path = write_file(path:new(path_queries, db), query_name,
                                         query)
            vim.notify("saved query to '" .. save_path .. "'")
          end
          query_float(db, url, path_queries, bufnr)
        end)
      end, {buffer = bufnr})
    end,
  })
end

M.fn = function()
  path = require("plenary.path")
  sd = require("plenary.scandir")

  local databases_path = os.getenv("DBQ_DATABASES_PATH")
  if databases_path == nil then
    vim.notify("no database credentials file found", vim.log.levels.ERROR)
    return
  end

  local databases = path:new(databases_path):readlines()
  if databases == nil then
    vim.notify("no databases found", vim.log.levels.ERROR)
    return
  end

  local path_queries = os.getenv("DBQ_QUERIES_PATH")
  if path_queries == nil then
    vim.notify("path to queries folder not found", vim.log.levels.ERROR)
    return
  end

  -- a database must follow the pattern: "<db_name>=<db_url>"
  local db_names = {}
  local db_urls = {}
  for _, db in ipairs(databases) do
    if db == "" then
      break -- skip last newline
    end
    local delimiter_index = string.find(db, "=")
    if delimiter_index == nil then
      vim.notify("invalid database definition: got nil", vim.log.levels.ERROR)
      return
    end
    local db_name = string.sub(db, 1, delimiter_index - 1)
    table.insert(db_names, 1, db_name)
    db_urls[db_name] = string.sub(db, delimiter_index + 1)
  end

  vim.ui.select(db_names, {prompt = "dbquery - select database"}, function(db)
    if db == nil then
      return
    end

    local url = db_urls[db]
    if url == nil then
      vim.notify("database '" .. db .. "' not found", vim.log.levels.ERROR)
      return
    end

    query_float(db, url, path_queries)
  end)
end

return M
