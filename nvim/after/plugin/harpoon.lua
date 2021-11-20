-- Harpoon lets you mark/tag a small set of files as "harpooned" and quickly nav to them, via either a popup window or
-- with a hotkey.

local map_options = {}
-- add key file for this project (harpoon)
vim.api.nvim_set_keymap("n", "<Leader>ka", "<cmd>lua R('harpoon.mark').add_file()<CR>", map_options)
-- open list of files marked as harpooned
vim.api.nvim_set_keymap("n", "<Leader>kl", "<cmd>lua R('harpoon.ui').toggle_quick_menu()<CR>", map_options)

-- Cmd-j opens the first file added to the harpoon
-- Cmd-k opens the second file added to the harpoon...
-- etc
-- jkl; = 1234
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>lua R('harpoon.ui').nav_file(1)<CR>", map_options)
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua R('harpoon.ui').nav_file(2)<CR>", map_options)
vim.api.nvim_set_keymap("n", "<C-l>", "<cmd>lua R('harpoon.ui').nav_file(3)<CR>", map_options)
vim.api.nvim_set_keymap("n", "<C-;>", "<cmd>lua R('harpoon.ui').nav_file(4)<CR>", map_options)

-- hui.toggle_quick_menu()
-- hmark.add_file()
-- hui.nav_file(1)
--[[ hterm = require("harpoon.term")

lua require("harpoon.term").gotoTerminal(1)
lua require("harpoon.term").sendCommand(1, 1)

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

-- PR adding tmux suupport:
--   https://github.com/ThePrimeagen/harpoon/pull/103

-- Project specific commands:

require("harpoon").setup({
  global_settings = {
    enter_on_sendcmd = true,
  },
  projects = {
    -- Yes $HOME works
    ["$HOME/workspace/dva/vets-api"] = {
      term = {
        cmds = {
          "bin/rails server",
          "foreman start",
        }
      }
    }
  }
})
