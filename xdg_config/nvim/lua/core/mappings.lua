local scratcher = require("jc.scratcher")
local emu_utils = require("jc.terminal.shared")
local emu = require("jc.terminal")

local map_ctrlo = function(key, rhs)
  vim.keymap.set("n", "<C-o>" .. key, rhs, { noremap = true, silent = true })
end

-- @param {string} f - telescope function to call
local map_ctrlo_tele = function(key, f, tele_options)
  map_ctrlo(key, function()
    require("jc.telescope")[f](tele_options or {})
  end)
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
vim.keymap.set("n", "*", search_cmd, { silent = true })

-- Hit <CR> to clear highlighted search matches
vim.keymap.set("n", "<CR>", function()
  if vim.v.hlsearch == 1 then
    return "<cmd>nohlsearch<CR>"
  end
  return "<CR>"
end, { expr = true, silent = true, replace_keycodes = true })

vim.keymap.set("n", "<leader>w", "<cmd>wa<CR>")
vim.keymap.set("n", "<leader>W", "<cmd>wqa<CR>")

-- Zenish-mode. Hides gutter, indentation indicators, and LSP messages. Keeps statusline.
vim.keymap.set("n", "<leader>z", require("jc.utils").toggle_zenish)

-- Open Scratch file for this project
vim.keymap.set("n", "<leader>rs", scratcher.split_open_scratch_file)

-- Lua Inspect current line
vim.keymap.set("n", "<leader>li", function()
  print(vim.inspect(loadstring("return " .. vim.fn.getline("."))()))
end, { silent = true })

-- Send the current line to the pane to the left
vim.keymap.set("n", "<leader>sh", emu_utils.send_line_left)
-- Send the current line to the pane to the right
vim.keymap.set("n", "<leader>sl", emu_utils.send_line_right)
-- Send the current line to the pane above the current one
vim.keymap.set("n", "<leader>sk", emu_utils.send_line_up)
-- Send the current line to the pane below the current one
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

-- Send Up then Enter to the pane to the left
vim.keymap.set("n", "<Leader>rr", function()
  vim.defer_fn(function()
    emu.send_text("Up") -- Send Up Arrow
  end, 50) -- Slight delay to ensure proper order

  vim.defer_fn(function()
    emu.send_text("\n") -- Send Enter
  end, 100) -- Another small delay
end, { desc = "Resend last command" })

vim.api.nvim_create_user_command("ResendOnSave", function()
  local buf = vim.api.nvim_get_current_buf()
  local ns = "resend_on_save_" .. buf -- Unique namespace per buffer

  -- Check if autocmd exists by storing a buffer variable
  if vim.b[ns] then
    -- Autocmd exists, remove it
    vim.api.nvim_clear_autocmds({ buffer = buf, event = "BufWritePost" })
    vim.b[ns] = nil
    vim.notify("Resend on save disabled", vim.log.levels.INFO)
  else
    -- Autocmd does not exist, create it
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,
      callback = function()
        vim.defer_fn(function()
          emu.send_text("Up") -- Send Up Arrow
        end, 50) -- Slight delay to ensure proper order

        vim.defer_fn(function()
          emu.send_text("\n") -- Send Enter
        end, 100) -- Another small delay
      end,
      desc = "Send UpArrow then Enter to left split after saving this buffer",
    })
    vim.b[ns] = true
    vim.notify("Resend on save enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle resend on save for this buffer" })

-- Insert debug print statement below current line
vim.keymap.set("n", "<leader>pp", function()
  require("jc.utils").insert_print_statement(false)
end)

-- Insert debug print statement above current line
vim.keymap.set("n", "<leader>pP", function()
  require("jc.utils").insert_print_statement(true)
end)

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

-- Save & run the current, or most recently modified, test in the terminal pane to the left
vim.keymap.set("n", "<leader>rt", "<cmd>wa<CR><cmd>lua require('jc.chuck_tester').run_mru_test()<CR>")
vim.keymap.set("n", "<leader>rT", "<cmd>wa<CR><cmd>lua require('jc.chuck_tester').run_mru_test_current_line()<CR>")

-- Edit the most recently modified test
vim.keymap.set("n", "<leader>et", function()
  vim.cmd("wa")
  require("jc.chuck_tester").edit_mru_test()
end, { silent = true })

-- Toggle treesitter highlighting
-- remap("n", "<leader>tstog", "<cmd>TSBufToggle highlight<CR>")

-- Show tree-sitter highlight group(s) for current cursor position
-- remap("n", "<leader>tshi", "<cmd>TSHighlightCapturesUnderCursor<CR>")

-- Copy to system clipboard with ctrl-c
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })

-- quickfix
vim.keymap.set("n", "<leader>qf", require("jc.utils").toggle_qf)
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>", { silent = true })

-- locationlist
vim.keymap.set("n", "<leader>ll", "<cmd>lopen<CR>", { silent = true })
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>", { silent = true })

local telescope_builtin_ok, telescope_builtin = pcall(require, "telescope.builtin")
if telescope_builtin_ok then
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
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- ctrl-o

-- opening files
map_ctrlo_tele("o", "find_files")     -- do not include hidden files, files in .gitignore, etc.
map_ctrlo_tele("O", "find_all_files") -- include hidden files, files in .gitignore, etc.
map_ctrlo_tele("b", "buffers")        -- open from [b]uffer list
map_ctrlo_tele("f", "grep_string")
vim.keymap.set("x", "<C-o>f", function()
  require("jc.telescope").grep_string()
end, { silent = true })
map_ctrlo_tele("F", "live_grep")

-- [g]it
map_ctrlo_tele("gb", "git_branches")  -- switch [b]ranches
map_ctrlo_tele("gs", "git_status")    -- uncommitted changes ([s]tatus)

-- LSP
-- little r -> Search for LSP references to word under cursor
map_ctrlo_tele("r", "lsp_references")

local diagnostic_jump_and_open = function(count)
  vim.diagnostic.jump({ count = count })
  vim.schedule(function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end)
end

vim.keymap.set("n", "[d", function() diagnostic_jump_and_open(-1) end)
vim.keymap.set("n", "]d", function() diagnostic_jump_and_open(1) end)
vim.keymap.set("n", "[[", function() diagnostic_jump_and_open(-1) end)
vim.keymap.set("n", "]]", function() diagnostic_jump_and_open(1) end)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true })
vim.keymap.set("n", "<space>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { silent = true })

-- little t -> Search list of symbols (tags) for current document
map_ctrlo_tele("t", "lsp_document_symbols")
-- Big T -> Search list of symbols (tags) from entire workspace
map_ctrlo_tele("T", "lsp_workspace_symbols")

map_ctrlo_tele("rc", "find_files", { search_dir = "app/controllers" })
map_ctrlo_tele("rm", "find_files", { search_dir = "app/models" })
map_ctrlo_tele("rv", "find_files", { search_dir = "app/views" })

-- Open the browser, switch to the localhost tab, and reload
vim.keymap.set("n", "<leader>ol", function()
  local output = vim.fn.system("zsh -ic open_localhost_and_switch_tabs")
  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR)
  end
end)

-- for debugging window/buffer issues
vim.keymap.set("n", "<leader>cbi", function()
  print("buf id: " .. vim.api.nvim_get_current_buf() .. ", win id: " .. vim.api.nvim_get_current_win())
end)

vim.keymap.set("n", "<leader>cbn", function()
  print(string.format("Current buffer number: %d, Current window number: %d", vim.fn.bufnr('%'), vim.api.nvim_win_get_number(0)))
end)

local function tell_music(script)
  local handle = io.popen("osascript -e '" .. script .. "'")
  if handle then handle:close() end
end

vim.keymap.set("n", "<leader>mp", function()
  tell_music('tell application "Music" to playpause')
end, { silent = true })
vim.keymap.set("n", "<leader>mn", function()
  tell_music('tell application "Music" to next track')
end, { silent = true })
