vim.api.nvim_set_option_value("commentstring", "-- %s", {buf = 0})
vim.keymap.set({"n", "v"}, "<C-Y>", "<Plug>(DBUI_ExecuteQuery)",
               {remap = false, buffer = true})
