local themes = {"oxocabron", "oxocabron_light"}

for _, version in ipairs(themes) do
  local theme = require("config.themes." .. version)

  local lushwright = require("shipwright.transform.lush")
  ---@diagnostic disable: undefined-global
  run(theme, lushwright.to_vimscript,
      {append, {"let g:colors_name=\"" .. version .. "\""}},
      {overwrite, vim.fn.stdpath("config") .. "/colors/" .. version .. ".vim"})
end
