local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local modules = {
  require("config.plugins.plugins"),
  require("config.telescope"),
  require("config.treesitter"),
  require("config.completions"),
  require("config.lsp"),
  require("config.debuggers"),
  require("config.commands"),
  require("config.snippets"),
  require("config.terminal"),
  require("config.themes"),
}

local plugins = {}
for _, module in ipairs(modules) do
  for _, plugin in ipairs(module.plugins) do
    if not plugin.event then
      plugin.event = "VeryLazy"
    end
    table.insert(plugins, plugin)
  end
end

local opts = {colorscheme = "oxocabron"}
require("lazy").setup(plugins, opts)
