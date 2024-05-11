-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/snips/ft/go.lua
local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta

local d = ls.dynamic_node
local i = ls.insert_node
local sn = ls.snippet_node
local t = ls.text_node

local get_node_text = vim.treesitter.get_node_text

local transforms = {
  int = "0",
  bool = "false",
  string = "",
  error = "err",
  [function(text)
    return string.find(text, "*", 1, true) ~= nil
  end] = function(_, _)
    return t("nil")
  end,
}

local transform = function(text)
  local type_matches = function(condition, ...)
    if type(condition) == "string" then
      return condition == text
    else
      return condition(...)
    end
  end

  for k, v in pairs(transforms) do
    if type_matches(k, text) then
      if type(v) == "string" then
        return t(v)
      else
        return v(text)
      end
    end
  end

  return t(text)
end

local handlers = {
  parameter_list = function(node)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      local matching_node = node:named_child(idx)
      local type_node = matching_node:field("type")[1]
      table.insert(result, transform(get_node_text(type_node, 0)))
      if idx ~= count - 1 then
        table.insert(result, t {", "})
      end
    end

    return result
  end,

  type_identifier = function(node)
    local text = get_node_text(node, 0)
    return {transform(text)}
  end,
}

local function_node_types = {
  function_declaration = true,
  method_declaration = true,
  func_literal = true,
}

local function go_result_type()
  local node = vim.treesitter.get_node()
  while node ~= nil do
    if function_node_types[node:type()] then
      break
    end

    node = node:parent()
  end

  if not node then
    print "Not inside of a function"
    return t ""
  end

  local query = vim.treesitter.query.parse("go", [[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]])
  for _, capture in query:iter_captures(node, 0) do
    if handlers[capture:type()] then
      return handlers[capture:type()](capture)
    end
  end
end

local go_ret_vals = function()
  return sn(nil, go_result_type())
end

return ls.snippet("iferr", fmta([[
if err != nil {
	return <result>
}<finish>
]], {result = d(1, go_ret_vals), finish = i(0)}))
