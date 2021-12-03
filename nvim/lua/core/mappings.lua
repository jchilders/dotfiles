local remap = require("utils").map_global

local M = {}

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
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

-- @param {string} f - telescope function to call
local map_ctrlo_tele = function(key, f, tele_options, bufnr)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  TelescopeMapArgs[map_key] = tele_options or {}
  local rhs = string.format(
    "<cmd>lua R('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>",
    f,
    map_key
  )

  map_ctrlo(key, rhs, bufnr)
end

function M.mappings()
  -- Quickly toggle between next/previous buffers
  remap("n", "<leader><leader>", "<cmd>b#<CR>")

  -- Prevent `Q` from taking us into Ex mode, because it isn't 1977 any longer
  remap("n", "Q", "<NOP>")

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

  -- Hit <CR> to clear hlsearch after doing a search
  remap("n", "<CR>", '{-> v:hlsearch ? "<cmd>nohl\\<CR>" : "\\<CR>"}()', true)

  -- `n`/`N` will go to next/previous search match and center it on screen
  remap("n", "n", "nzz")
  remap("n", "N", "Nzz")

  -- scroll down/up and center
  remap("n", "<C-d>", "<C-d>zz")
  remap("n", "<C-u>", "<C-u>zz")
  remap("n", "<C-f>", "<C-f>zz")
  remap("n", "<C-b>", "<C-b>zz")

  remap("n", "<leader>w", "<cmd>wa<CR>")
  remap("n", "<leader>W", "<cmd>wqa<CR>")

  remap("n", "<leader>g", "<cmd>lua require('jc.utils').toggle_gutter()<CR>")

  -- Open Scratch file for this project
  remap("n", "<leader>rs", "<cmd>lua require('jc.scratch').split_open_scratch_file()<CR>")

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

  -- Run the most recently modified test
  remap("n", "<leader>rt", "<cmd>lua require('jc.tmux-utils').run_mru_rails_test()<CR>")

  -- Toggle treesitter highlighting
  remap("n", "<leader>tog", "<cmd>TSBufToggle highlight<CR>")

  -- Show tree-sitter highlight group(s) for current cursor position
  remap("n", "<leader>hi", "<cmd>TSHighlightCapturesUnderCursor<CR>")

  -- general
  remap("v", "J", "<cmd>m '>+1<CR>gv=gv") -- move lines
  remap("v", "K", "<cmd>m '<-2<CR>gv=gv") -- move lines
  remap("v", "<leader>p", '"_dP') -- delete into blackhole and paste last yank

  -- quickfix
  remap("n", "<leader>qo", "<cmd>lua require('utils').toggle_qf()<CR>")
  remap("n", "<leader>qn", "<cmd>cnext<CR>")
  remap("n", "<leader>qo", "<cmd>copen<CR>")
  remap("n", "<leader>qp", "<cmd>cprev<CR>")

  -- locationlist
  remap("n", "<leader>lc", "<cmd>lclose<CR>")
  remap("n", "<leader>lo", "<cmd>lopen<CR>")
  remap("n", "<leader>ln", "<cmd>lnext<CR>")
  remap("n", "<leader>lp", "<cmd>lprev<CR>")

  -- ctrl-o

  -- ctrl-o telescope mappings
  map_ctrlo_tele("b", "buffers")

  map_ctrlo_tele("f", "grep_string")
  map_ctrlo_tele("F", "live_grep")

  -- git
  -- switch branches
  map_ctrlo_tele("gb", "git_branches")
  -- git diff of current buffer. WIP
  map_ctrlo("gd", "<cmd>lua require('plugins.toggleterm').toggle_curr_diff()<CR>")
  -- git history of file in current buffer
  map_ctrlo_tele("gh", "git_bcommits")
  -- open lazygit
  map_ctrlo("gl", "<cmd>lua require('plugins.toggleterm').toggle_lazygit()<CR>")
  -- edit changed file
  map_ctrlo_tele("gs", "git_status")

  -- files
  map_ctrlo_tele("o", "find_files")
  map_ctrlo_tele("O", "search_all_files")

  -- rails
  map_ctrlo_tele("rc", "find_files", { search_dir = "app/controllers" })
  map_ctrlo_tele("rm", "find_files", { search_dir = "app/models" })
  map_ctrlo_tele("rv", "find_files", { search_dir = "app/views" })

  map_ctrlo_tele("q", "quickfix")

  -- LSP
  -- little r -> Search for LSP references to word under cursor
  map_ctrlo_tele("r", "lsp_references")
  remap("n", "[[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  remap("n", "]]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
  remap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  remap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  remap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  remap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

  -- little t -> Search list of symbols (tags) for current document
  map_ctrlo_tele("t", "lsp_document_symbols")
  -- Big T -> Search list of symbols (tags) from entire workspace
  map_ctrlo_tele("T", "lsp_workspace_symbols")

  -- not using this much; may delete
  remap("n", "<leader>tt", "<cmd>LspTroubleToggle<CR>")

  -- format.nvim
  remap("n", "<leader>fb", "<cmd>Format<CR>")
  remap("v", "<leader>fb", "<cmd>Format<CR>")

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

  -- terminal
  remap('t', '<esc>', [[<C-\><C-n>]])
  remap('t', 'jk', [[<C-\><C-n>]])
  remap('t', '<C-h>', [[<C-\><C-n><C-W>h]])
  remap('t', '<C-j>', [[<C-\><C-n><C-W>j]])
  remap('t', '<C-k>', [[<C-\><C-n><C-W>k]])
  remap('t', '<C-l>', [[<C-\><C-n><C-W>l]])

  -- toggleterm

  -- dap NOTE: Lazyloaded
  -- also NOTE: not working atm
  --[[ remap(
    "n",
    "<leader>dc",
    <cmd>lua require("plugins.dap.attach"):addPlug(); require'dap'.continue()<CR>
  )
  remap(
    "n",
    "<leader>db",
    <cmd>lua require("plugins.dap.attach"):addPlug(); require'dap'.toggle_breakpoint()<CR>
  ) ]]

  -- compe: NOTE: Lazyloaded
  --[[ remap("i", "<C-space>", "compe#complete()", true)
  remap("i", "<C-e>", "compe#close('<C-e>')", true)
  remap("i", "<C-f>", "compe#scroll({ delta: +4 })", true)
  remap("i", "<C-d>", "compe#scroll({ delta: -4 })", true) ]]

  -- marker: NOTE: Lazyloaded
  --[[ remap("v", "<leader>1", "<cmd><c-u>HSHighlight 1<CR>")
  remap("v", "<leader>2", "<cmd><c-u>HSHighlight 2<CR>")
  remap("v", "<leader>3", "<cmd><c-u>HSHighlight 3<CR>")
  remap("v", "<leader>4", "<cmd><c-u>HSHighlight 4<CR>")
  remap("v", "<leader>5", "<cmd><c-u>HSHighlight 5<CR>")
  remap("v", "<leader>6", "<cmd><c-u>HSHighlight 6<CR>")
  remap("v", "<leader>7", "<cmd><c-u>HSHighlight 7<CR>")
  remap("v", "<leader>8", "<cmd><c-u>HSHighlight 8<CR>")
  remap("v", "<leader>9", "<cmd><c-u>HSHighlight 9<CR>")
  remap("v", "<leader>0", "<cmd><c-u>HSRmHighlight<CR>") ]]

  -- make
  -- remap("n", "<leader>ms", "<cmd>Neomake<CR>")
  -- remap("n", "<leader>mt", "<cmd>TestFile<CR>")
  -- remap("n", "<leader>mu", "<cmd>Ultest<CR>")

  -- neogen
  --[[ remap("n", "<leader>nf", "<cmd>DocGen<CR>") ]]
end

return M
