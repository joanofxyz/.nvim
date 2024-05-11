vim.api.nvim_buf_set_option(0, "commentstring", "-- %s")
vim.keymap.set({"n", "v"}, "<C-Y>", "<Plug>(DBUI_ExecuteQuery)",
               {remap = false, buffer = true})
