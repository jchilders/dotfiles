local remap = require("utils").map_global
local scratcher = require("jc.scratcher")
local emu_utils = require("jc.emu-utils")
local chuck_tester = require("jc.chuck_tester")

TelescopeMapArgs = TelescopeMapArgs or {}

local map_ctrlo = function(key, rhs, map_options, bufnr)
  key = "<C-o>" .. key
  local mode = "n"

  if map_options == nil then
    map_options = {
      noremap = true,
      silent = true,
    }
  end

  if not bufnr then
    -- vim.api.nvim_set_keymap(mode, key, rhs, map_options)
    vim.keymap.set(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

-- @param {string} f - telescope function to call
local map_ctrlo_tele = function(key, f, tele_options, bufnr)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  TelescopeMapArgs[map_key] = tele_options or {}
  local rhs = string.format(
    "<cmd>lua require('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>",
    f,
    map_key
  )

  map_ctrlo(key, rhs, bufnr)
end

-- Quickly toggle between next/previous buffers
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<CR>")

-- Prevent `Q` from taking us into Ex mode because this isn't 1980
vim.keymap.set("n", "Q", "<NOP>")

-- center screen after search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- this is from nvim-lua/kickstart.nvim... Something broke when I took it out ut I can't remember what
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- change current word
vim.keymap.set("n", "ccw", vim.lsp.buf.rename, {})

-- `*` still searches what is under the cursor, but doesn't immediately jump
-- to the next match. Found this on StackOverflow a long time ago. Diving
-- into how it works is interesting.
--
-- Details:
-- - the search register (i.e. where your search term from the `/` command is stored) is `@/`
-- - we want to manually set that value to what is under the cursor
--
-- You can set the search register manually by doing this:
--
--   :let @/='foo'
--
-- This is the same as the normal way to search:
--
--   /foo
--
-- We want to set the value of the `@/` register to what is under the cursor.
-- To do this we are going to use a lesser-known vim feature for manipulating
-- the command line: `CTRL-R` (`:h <C-R>`). To see how it works, do the
-- following:
--
--   - Place your cursor over some text
--   - Now type `:echo ` but don't hit enter yet. Instead, hit `CTRL-R`. This
-- will take you into a special "register" mode that allows dynamic values
-- to be inserted into the vim command line. There are various registers
-- available (see `:h <C-R>` for the list) but the one we are interested in
-- is the expression register, `=`.
--
-- This register lets you enter an expression (basically another command),
-- and have the result of that expression added to your command line.
--
-- Let's see how it works. With your cursor over some text in your document:
--
--   1. `:let @/='`. Note the single quote at the end.
--   2. Hit CTRL-R. Your cursor should have `"` under it indicating you
--   are now in register mode
--   3. Hit `=` to interact with the expression register
--   4. `expand("<cword>")`
--   5. Hit enter. If the word under your cursor is "foo" then your command line should look like the following: `let @/='foo`
--   6. Add your closing `'` and hit enter.
-- tl;dr: * searches term under cursor but doesn't jump forward
local search_cmd = [[:let @/='<C-R>=expand("<cword>")<CR>'<CR>:set hls<CR>]]
vim.keymap.set("n", "*", search_cmd)

-- Hit <CR> to clear highlighted search matches
remap("n", "<CR>", '{-> v:hlsearch ? "<cmd>nohl\\<CR>" : "\\<CR>"}()', true)

vim.keymap.set("n", "<leader>w", "<cmd>wa<CR>")
vim.keymap.set("n", "<leader>W", "<cmd>wqa<CR>")

vim.keymap.set("n", "<leader>g", require("jc.utils").toggle_gutter)

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
  vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Stage change" })
  vim.keymap.set("n", "<leader>gA", gitsigns.stage_buffer, { desc = "Stage all changes made to current buffer" })
  vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
  vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Go to previous unstaged hunk" })
  vim.keymap.set("n", "<leader>gP", gitsigns.preview_hunk, { desc = "Preview hunk" })
  vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Go to next unstaged hunk" })
  vim.keymap.set("n", "<leader>gu", gitsigns.reset_hunk, { desc = "Undo changes to current hunk" })
  vim.keymap.set("n", "<leader>gU", gitsigns.reset_buffer, { desc = "Undo all changes made to current buffer" })
  vim.keymap.set("n", "<leader>gq", function()
                                      gitsigns.setqflist("all")
                                    end, { desc = "Set quickfix list to unstaged changes" })
end

-- Open Scratch file for this project
vim.keymap.set("n", "<leader>rs", scratcher.split_open_scratch_file)

-- Lua Inspect current line
remap("n", "<leader>li", "<cmd>lua print(require('utils.inspect').inspect(loadstring(\"return \" .. vim.fn.getline('.'))()))<CR>")

-- Send the current line to the pane to the left
vim.keymap.set("n", "<leader>sh", emu_utils.send_line_left)
-- Send the current line to the pane to the right
vim.keymap.set("n", "<leader>sl", emu_utils.send_line_right)
-- Send the current line to the pane above the current pane
vim.keymap.set("n", "<leader>sk", emu_utils.send_line_up)
-- Send the current line to the pane below the current pane
vim.keymap.set("n", "<leader>sj", emu_utils.send_line_down)

-- Send the visually selected text to the left terminal pane
vim.keymap.set("v", "<leader>sh", emu_utils.send_selection_left)
-- Send the visually selected text to the right terminal pane
vim.keymap.set("v", "<leader>sl", emu_utils.send_selection_right)
-- Send the visually selected text to the pane above the current pane
vim.keymap.set("v", "<leader>sk", emu_utils.send_selection_up)
-- Send the visually selected text to the pane below the current pane
vim.keymap.set("v", "<leader>sj", emu_utils.send_selection_down)
-- Send ('a'gain) the last visually selected area to the left terminal pane
-- TODO: get this working for all directions
-- vim.keymap.set("n", "<leader>sa", emu_utils.send_selection_left)

local tireswing_ok, tireswing = pcall(require, "jc.tireswing")
if tireswing_ok then
  -- Send current function to the left terminal pane
  vim.keymap.set("n", "<leader>sfl", function()
    local function_text = tireswing.get_current_function()
    emu_utils.send_left(function_text)
  end)
  -- Quote Toggler: toggle between single/double quotes for string under cursor.
  vim.keymap.set("n", "<leader>tq", tireswing.toggle_quotes)

  -- move current treesitter object up
  -- remap("n", "J", "<cmd>lua require('jc.tireswing').swap_nodes(false)<CR>")
  -- move current treesitter object down
  -- remap("n", "K", "<cmd>lua require('jc.tireswing').swap_nodes(true)<CR>")
end

-- Save & run the most recently modified test in the terminal pane to the left
vim.keymap.set("n", "<leader>rt", "<cmd>wa<CR><cmd>lua require('jc.chuck_tester').run_mru_test()<CR>")
vim.keymap.set("n", "<leader>rT", "<cmd>wa<CR><cmd>lua require('jc.chuck_tester').run_mru_test_current_line()<CR>")

-- Edit the most recently modified test
remap("n", "<leader>et", "<cmd>wa<CR><cmd>lua require('jc.chuck_tester').edit_mru_test()<CR>")

-- Toggle treesitter highlighting
-- remap("n", "<leader>tstog", "<cmd>TSBufToggle highlight<CR>")

-- Show tree-sitter highlight group(s) for current cursor position
-- remap("n", "<leader>tshi", "<cmd>TSHighlightCapturesUnderCursor<CR>")

-- Copy to system clipboard with ctrl-c
remap("v", "<C-c>", '"+y')

-- quickfix
vim.keymap.set("n", "<leader>qf", require('utils').toggle_qf)
remap("n", "<leader>qn", "<cmd>cnext<CR>")
remap("n", "<leader>qp", "<cmd>cprev<CR>")

-- locationlist
remap("n", "<leader>ll", "<cmd>lopen<CR>")
remap("n", "<leader>lc", "<cmd>lclose<CR>")
remap("n", "<leader>ln", "<cmd>lnext<CR>")
remap("n", "<leader>lp", "<cmd>lprev<CR>")

local telescope_builtin_ok, telescope_builtin = pcall(require, "telescope.builtin")
if telescope_builtin_ok then
  vim.keymap.set("n", "<C-o>b", telescope_builtin.buffers, { desc = "Open from [b]uffer list" })
  vim.keymap.set('n', '<leader>/', function()
    telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set("n", "<C-o>h", telescope_builtin.command_history, { desc = "Command [h]istory" })
  vim.keymap.set('n', '<leader>tsh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
end

-- LSP Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- ctrl-o

-- ctrl-o telescope mappings

map_ctrlo_tele("f", "grep_string")
map_ctrlo_tele("F", "live_grep")

-- git
-- switch [b]ranches
map_ctrlo_tele("gb", "git_branches")
-- list of files that are [c]hanged on our branch (compared to `main`)
map_ctrlo_tele("gc", "git_changed_files_curr_branch")
-- git [h]istory of current buffer
map_ctrlo_tele("gh", "git_bcommits")
-- select file from files with uncommitted changes (i.e. from `git [s]tatus`)
map_ctrlo_tele("gs", "git_status")

-- files
map_ctrlo_tele("o", "find_files") -- do not include hidden files, files in .gitignore, etc.
map_ctrlo_tele("O", "find_all_files") -- include hidden files, files in .gitignore, etc.

-- LSP
-- little r -> Search for LSP references to word under cursor
map_ctrlo_tele("r", "lsp_references")

map_ctrlo_tele("rc", "find_files", { search_dir = "app/controllers" })
map_ctrlo_tele("rm", "find_files", { search_dir = "app/models" })
map_ctrlo_tele("rv", "find_files", { search_dir = "app/views" })

remap("n", "[[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
remap("n", "]]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
remap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
remap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
remap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

-- little t -> Search list of symbols (tags) for current document
map_ctrlo_tele("t", "lsp_document_symbols")
-- Big T -> Search list of symbols (tags) from entire workspace
map_ctrlo_tele("T", "lsp_workspace_symbols")

-- harpoon
local harpoon_ok, harpoon = pcall(require, "harpoon")
if harpoon_ok then
  vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
  -- open list of files marked as harpooned
  vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  -- ctrl-j opens the first harpooned file, ctrl-k opens the second harpooned file...
  vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
  vim.keymap.set("n", "<C-;>", function() harpoon:list():select(5) end)
else
  vim.notify("Problem when loading Harpoon:\n" .. result, vim.log.levels.WARN, { title = "mappings.lua" })
end

-- Open the browser, switch to the localhost tab, and reload
vim.keymap.set("n", "<leader>ol", function()
  local output = vim.fn.system("zsh -ic open_localhost_and_switch_tabs")
  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR)
  end
end)

-- terminal
-- remap("t", "<esc>", [[<C-\><C-n>]])
-- remap("t", "jk", [[<C-\><C-n>]])
-- remap("t", "<C-h>", [[<C-\><C-n><C-W>h]])
-- remap("t", "<C-j>", [[<C-\><C-n><C-W>j]])
-- remap("t", "<C-k>", [[<C-\><C-n><C-W>k]])
-- remap("t", "<C-l>", [[<C-\><C-n><C-W>l]])

-- for debugging window/buffer issues
vim.keymap.set("n", "<leader>cbi", function()
  print("buf id: " .. vim.api.nvim_get_current_buf() .. ", win id: " .. vim.api.nvim_get_current_win())
end)

vim.keymap.set("n", "<leader>cbn", function()
  print(string.format("Current buffer number: %d, Current window number: %d", vim.fn.bufnr('%'), vim.api.nvim_win_get_number(0)))
end)
