local remap = require("utils").map_global
local scratcher = require("jc.scratcher")
local tireswing = require("jc.tireswing")
local tmux_utils = require("jc.tmux-utils")

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

local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Stage change" })
vim.keymap.set("n", "<leader>gA", gitsigns.stage_buffer, { desc = "Stage all changes made to current buffer" })
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Go to previous unstaged hunk" })
vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Go to next unstaged hunk" })
vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Undo changes to current hunk" })
vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Undo all changes made to current buffer" })
vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gq", function()
                                    gitsigns.setqflist("all")
                                  end, { desc = "Set quickfix list to unstaged changes" })

-- Lua Inspect
remap("n", "<leader>li", "<cmd>lua print(require('utils.inspect').inspect(loadstring(\"return \" .. vim.fn.getline('.'))()))<CR>")

-- Open Scratch file for this project
vim.keymap.set("n", "<leader>rs", scratcher.split_open_scratch_file)

-- Send the current line to the left tmux pane
vim.keymap.set("n", "<leader>sl", tmux_utils.send_line_left)

-- Send the selected text to the left tmux pane
vim.keymap.set("v", "<leader>sl", tmux_utils.send_selection_left)

-- Send current function to the left tmux pane
vim.keymap.set("n", "<leader>sfl", function()
  local function_text = tireswing.get_current_function()
  tmux_utils.send_left(function_text)
end)

-- Send the keys `^D`, `UpArrow`, and `Enter` to the left tmux pane
-- Lets us quickly Restart Rails console/server/psql/lua/whatever, so long as it quits

-- when it receives a ^D
vim.keymap.set(
  "n",
  "<leader>rr",
  function()
    tmux_utils.send_keys_left({"C-d","Up","Enter"})
  end
)

-- Save & run the most recently modified test, test case for current line only
-- remap("n", "<leader>rt", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').run_mru_test_current()<CR>")

-- Save & run the most recently modified test in the tmux pane to the left
vim.keymap.set("n", "<leader>rt", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').run_mru_test()<CR>")
vim.keymap.set("n", "<leader>rT", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').run_mru_test_current_line()<CR>")

-- Edit the most recently modified test
-- remap("n", "<leader>et", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').edit_mru_test()<CR>")

-- Toggle treesitter highlighting
-- remap("n", "<leader>tstog", "<cmd>TSBufToggle highlight<CR>")

-- Show tree-sitter highlight group(s) for current cursor position
-- remap("n", "<leader>tshi", "<cmd>TSHighlightCapturesUnderCursor<CR>")

-- move current treesitter object up
-- remap("n", "J", "<cmd>lua require('jc.tireswing').swap_nodes(false)<CR>")
-- move current treesitter object down
-- remap("n", "K", "<cmd>lua require('jc.tireswing').swap_nodes(true)<CR>")

-- Copy to system clipboard with ctrl-c
remap("v", "<C-c>", '"+y')

-- Quote Toggler: toggle between single/double quotes for string under cursor.
vim.keymap.set("n", "<leader>tq", tireswing.toggle_quotes)

-- quickfix
vim.keymap.set("n", "<leader>qf", require('utils').toggle_qf)
remap("n", "<leader>qn", "<cmd>cnext<CR>")
remap("n", "<leader>qp", "<cmd>cprev<CR>")

-- locationlist
remap("n", "<leader>ll", "<cmd>lopen<CR>")
remap("n", "<leader>lc", "<cmd>lclose<CR>")
remap("n", "<leader>ln", "<cmd>lnext<CR>")
remap("n", "<leader>lp", "<cmd>lprev<CR>")

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- LSP Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- ctrl-o

-- ctrl-o telescope mappings
vim.keymap.set("n", "<C-o>b", require("telescope.builtin").buffers, { desc = "Open from [b]uffer list" })

map_ctrlo_tele("f", "grep_string")
map_ctrlo_tele("F", "live_grep")

-- git
-- switch branches
map_ctrlo_tele("gb", "git_branches")
-- git history of file in current buffer
map_ctrlo_tele("gh", "git_bcommits")
-- select file from files with uncommitted changes (i.e. from `git status`)
map_ctrlo_tele("gs", "git_status")

vim.keymap.set("n", "<C-o>h", require("telescope.builtin").command_history, { desc = "Command [h]istory" })

-- files
map_ctrlo_tele("o", "find_files")
map_ctrlo_tele("O", "find_all_files") -- include hidden/.gitignored files/etc.

-- my current favorite
local smart_search = function()
  require("telescope").extensions.smart_open.smart_open({cwd_only = true})
end
vim.keymap.set("n", "<leader>ss", smart_search)

-- LSP
-- little r -> Search for LSP references to word under cursor
map_ctrlo_tele("r", "lsp_references")
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
vim.keymap.set("n", "<leader>ha", require('harpoon.mark').add_file)
-- open list of files marked as harpooned
vim.keymap.set("n", "<leader>hl", require('harpoon.ui').toggle_quick_menu)
-- ctrl-j opens the first harpooned file, ctrl-k opens the second harpooned file...
remap("n", "<C-h>", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>")
remap("n", "<C-j>", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>")
remap("n", "<C-k>", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>")
remap("n", "<C-l>", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>")
remap("n", "<C-;>", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>")

-- terminal
remap("t", "<esc>", [[<C-\><C-n>]])
remap("t", "jk", [[<C-\><C-n>]])
remap("t", "<C-h>", [[<C-\><C-n><C-W>h]])
remap("t", "<C-j>", [[<C-\><C-n><C-W>j]])
remap("t", "<C-k>", [[<C-\><C-n><C-W>k]])
remap("t", "<C-l>", [[<C-\><C-n><C-W>l]])
