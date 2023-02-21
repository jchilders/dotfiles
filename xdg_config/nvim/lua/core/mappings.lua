local remap = require("utils").map_global

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
local search_cmd = [[:let @/='<C-R>=expand("<cword>")<CR>'<CR>:set hls<CR>]]
remap("n", "*", search_cmd)

-- Hit <CR> to clear highlighted search matches
remap("n", "<CR>", '{-> v:hlsearch ? "<cmd>nohl\\<CR>" : "\\<CR>"}()', true)

remap("n", "<leader>w", "<cmd>wa<CR>")
remap("n", "<leader>W", "<cmd>wqa<CR>")

remap("n", "<leader>g", "<cmd>lua require('jc.utils').toggle_gutter()<CR>")

-- Lua Inspect
remap("n", "<leader>li", "<cmd>lua print(require('utils.inspect').inspect(loadstring(\"return \" .. vim.fn.getline('.'))()))<CR>")

-- Open Scratch file for this project
remap("n", "<leader>rs", "<cmd>lua require('jc.scratcher').split_open_scratch_file()<CR>")

-- Send the current line to the left tmux pane
remap("n", "<leader>sl", "<cmd>lua require('jc.tmux-utils').send_line_left()<CR>")
-- Send the selected text to the left tmux pane
remap("v", "<leader>sl", "<cmd>lua require('jc.tmux-utils').send_selection_left()<CR>")

-- Send the keys `^D`, `UpArrow`, and `Enter` to the left tmux pane
-- Lets us quickly Restart Rails console/server/psql/lua/whatever, so long as it quits
-- when it receives a ^D
remap(
  "n",
  "<leader>rr",
  "<cmd>lua require('jc.tmux-utils').send_keys_left({'C-d','Up','Enter'})<CR>"
)

-- Save & run the most recently modified test, test case for current line only
-- remap("n", "<leader>rt", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').run_mru_test_current()<CR>")
-- Save & run the most recently modified test, entire test file
-- remap("n", "<leader>rT", "<cmd>wa<CR><cmd>lua require('jc.tmux-utils').run_mru_test()<CR>")
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
remap("n", "<leader>tq", "<cmd>lua require('jc.tireswing').toggle_quotes()<CR>")

-- quickfix
remap("n", "<leader>qf", "<cmd>lua require('utils').toggle_qf()<CR>")
remap("n", "<leader>qn", "<cmd>cnext<CR>")
remap("n", "<leader>qp", "<cmd>cprev<CR>")

-- locationlist
remap("n", "<leader>ll", "<cmd>lopen<CR>")
remap("n", "<leader>lc", "<cmd>lclose<CR>")
remap("n", "<leader>ln", "<cmd>lnext<CR>")
remap("n", "<leader>lp", "<cmd>lprev<CR>")

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- ctrl-o

-- ctrl-o telescope mappings
vim.keymap.set("n", "<C-o>b", require("telescope.builtin").buffers, { desc = "[ ] Open from buffer list" })

map_ctrlo_tele("f", "grep_string")
map_ctrlo_tele("F", "live_grep")

-- git
-- switch branches
map_ctrlo_tele("gb", "git_branches")
-- git history of file in current buffer
map_ctrlo_tele("gh", "git_bcommits")
-- select file from files with uncommitted changes (i.e. from `git status`)
map_ctrlo_tele("gs", "git_status")

-- files
map_ctrlo_tele("o", "find_files")
map_ctrlo_tele("O", "find_all_files") -- include hidden/.gitignore/etc.

-- my current favorite
local smart_search = function()
  require("telescope").extensions.smart_open.smart_open({cwd_only = true})
end
vim.keymap.set("n", "<leader>ss", smart_search)

map_ctrlo_tele("q", "quickfix")

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
remap("n", "<leader>ha", "<cmd>lua R('harpoon.mark').add_file()<CR>")
-- open list of files marked as harpooned
remap("n", "<leader>hl", "<cmd>lua R('harpoon.ui').toggle_quick_menu()<CR>")

-- Cmd-j opens the first harpooned file,
-- Cmd-k opens the second harpooned file...
-- hjkl = 1234
remap("n", "<C-h>", "<cmd>lua R('harpoon.ui').nav_file(1)<CR>")
remap("n", "<C-j>", "<cmd>lua R('harpoon.ui').nav_file(2)<CR>")
remap("n", "<C-k>", "<cmd>lua R('harpoon.ui').nav_file(3)<CR>")
remap("n", "<C-l>", "<cmd>lua R('harpoon.ui').nav_file(4)<CR>")
remap("n", "<C-;>", "<cmd>lua R('harpoon.ui').nav_file(5)<CR>")

-- terminal
remap("t", "<esc>", [[<C-\><C-n>]])
remap("t", "jk", [[<C-\><C-n>]])
remap("t", "<C-h>", [[<C-\><C-n><C-W>h]])
remap("t", "<C-j>", [[<C-\><C-n><C-W>j]])
remap("t", "<C-k>", [[<C-\><C-n><C-W>k]])
remap("t", "<C-l>", [[<C-\><C-n><C-W>l]])
