local themes = {"oxocabron", "oxocabron_light"}

-- https://github.com/rktjmp/shipwright.nvim/blob/e596ab48328c31873f4f4d2e070243bf9de16ff3/lua/shipwright/transform/contrib/alacritty.lua
local helpers = require("shipwright.transform.helpers")
local check_keys = {
  "fg",
  "bg",
  "cursor_fg",
  "cursor_bg",
  "black",
  "red",
  "green",
  "yellow",
  "blue",
  "magenta",
  "cyan",
  "white",
  "bright_black",
  "bright_red",
  "bright_green",
  "bright_yellow",
  "bright_blue",
  "bright_magenta",
  "bright_cyan",
  "bright_white",
  "dim_black",
  "dim_red",
  "dim_green",
  "dim_yellow",
  "dim_blue",
  "dim_magenta",
  "dim_cyan",
  "dim_white",
}

local base_template = [[
[colors.primary]
foreground = "$fg"
background = "$bg"
[colors.normal]
black = "$black"
red = "$red"
green = "$green"
yellow = "$yellow"
blue = "$blue"
magenta = "$magenta"
cyan = "$cyan"
white = "$white"
[colors.bright]
black = "$bright_black"
red = "$bright_red"
green = "$bright_green"
yellow = "$bright_yellow"
blue = "$bright_blue"
magenta = "$bright_magenta"
cyan = "$bright_cyan"
white = "$bright_white"
[colors.dim]
black = "$dim_black"
red = "$dim_red"
green = "$dim_green"
yellow = "$dim_yellow"
blue = "$dim_blue"
magenta = "$dim_magenta"
cyan = "$dim_cyan"
white = "$dim_white"
]]

local function alacritty(colors)
  for _, key in ipairs(check_keys) do
    assert(colors[key], "alacritty colors table missing key: " .. key)
  end
  local text = helpers.apply_template(base_template, colors)
  return helpers.split_newlines(text)
end

for _, version in ipairs(themes) do
  local theme = require("config.themes." .. version)

  local lushwright = require("shipwright.transform.lush")
  ---@diagnostic disable: undefined-global
  run(theme.lush, lushwright.to_vimscript,
      {append, {"let g:colors_name=\"" .. version .. "\""}},
      {overwrite, vim.fn.stdpath("config") .. "/colors/" .. version .. ".vim"})
  run(theme.colors, alacritty, {
    overwrite,
    vim.fn.getenv("XDG_CONFIG_HOME") .. "/alacritty/" .. version .. ".toml",
  })
end
