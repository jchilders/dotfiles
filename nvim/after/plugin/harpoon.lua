-- Harpoon lets you mark/tag a small set of files as "harpooned" and quickly nav to them, via either a popup window or
-- with a hotkey.

local map_options = {}
-- add key file for this project (harpoon)
vim.api.nvim_set_keymap("n", "<Leader>af", "<cmd>lua R('harpoon.mark').add_file()<CR>", map_options)
-- open key files menu for this project (harpoon)
vim.api.nvim_set_keymap("n", "<Leader>kf", "<cmd>lua R('harpoon.ui').toggle_quick_menu()<CR>", map_options)

-- Cmd-1 opens the first file in the list
vim.api.nvim_set_keymap("n", "<WhatGoesHere>1", "<cmd>lua R('harpoon.ui').nav_file(1)<CR>", map_options)

-- hui.toggle_quick_menu()
-- hmark.add_file()
-- hui.nav_file(1)
--[[ hterm = require("harpoon.term")
hterm.gotoTerminal(1)
 -- This will send to terminal 1 either the predefined command 1 in the terminal
 -- config or "ls -la"
hterm.sendCommand(1, 1)
hterm.sendCommand(1, "ls -la") ]]

--[[ require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        excluded_filetypes = { "harpoon" }
    },
}) ]]

-- Project specific commands:
--
-- require("harpoon").setup({
--   projects = {
--   -- Yes $HOME works
--   ["$HOME/personal/vim-with-me/server"] = {
--     term = {
--       cmds = {
--         "./env && npx ts-node src/index.ts"
--       }
--     }
--   },
--  ]]

