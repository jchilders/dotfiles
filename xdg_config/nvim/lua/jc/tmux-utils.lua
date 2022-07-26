local M = {}

local api = vim.api
local bo = vim.bo


-- Send line under the cursor to the tmux pane to the left, then move cursor to
-- next line
--
-- TODO: Investigate maybe using nvim_replace_termcodes or something similar
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  M.send_left(curr_line)

  -- move cursor to next line, if there is one
  local row, col = unpack(api.nvim_win_get_cursor(0))
  if row < api.nvim_buf_line_count(0) then
    api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

-- Send currently selected text to the tmux pane to the left
M.send_selection_left = function()
  local bufnr = api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  content = table.concat(content, "\r")

  M.send_left(content)
end

M.send_enter = function()
  vim.fn.system("tmux send-keys -t left Enter")
end

-- Send `text` as UTF-8 characters to the tmux pane to the left. Appends a
-- carriage return to `text` if one is not already the last character
M.send_left = function(text)
  local esc_text = vim.fn.escape(text, '\\"$`')
  -- the `-l` flag is needed to avoid send-keys from
  -- intepreting strings such 'end' as the end key.
  local send_text = string.format('tmux send-keys -l -t left "%s"', esc_text)

  -- Append a CR if the last char isn't already one
  if send_text:sub(#send_text, #send_text) ~= "\r" then
    send_text = send_text .. "\r"
  end

  vim.fn.system(send_text)
end

-- Send array `keys` as keys to the tmux pane to the left
-- See: http://man.openbsd.org/OpenBSD-current/man1/tmux.1#KEY_BINDINGS
M.send_keys_left = function(keys)
  for _, key in ipairs(keys) do
    local esc_text = vim.fn.escape(key, '"$`')
    local text_to_send = string.format('tmux send-keys -t left "%s"', esc_text)
    vim.fn.system(text_to_send)
  end
end

local function bufnr_for_test_file()
  local test_file = M.mru_test_file()
  return vim.fn.bufnr(test_file)
end

M.mru_test_file = function()
  -- Using zsh globbing is actually faster than anything else I tried: `find`,
  -- `exa`, `fd`, `stat`. Tried 'em all. Globbing was the fastest.
  local test_file = vim.fn.system("print -l (test|spec)/**/*_(test|spec).rb(om) | head -1 | tr -d '\n'")
  if vim.fn.stridx(test_file, "no matches found") >= 0 then
    error('No test file found', 2)
    return
  end

  return test_file
end

-- Find and run the most recently modified test
M.run_mru_test = function(...)
  local ok, test_file = pcall(M.mru_test_file)
  if not ok then
    print("Error: No test file found")
    return
  end

  local test_cmd = "rails test " .. test_file
  local arg = {...}
  for _, row in ipairs(arg) do
    test_cmd = test_cmd .. ":" .. row
  end

  M.send_left(test_cmd)
end

M.run_mru_test_current = function()
  local buf = bufnr_for_test_file()

  if buf == -1 then
    print("No buffer for " .. M.mru_test_file())
    return
  end

  local lnum = vim.api.nvim_buf_get_mark(buf, '"')[1]
  M.run_mru_test(lnum)
end

function M.visual_selection_range()
  local vis_start = vim.fn.getpos("v")[2]
  local vis_end = vim.fn.getcurpos()[2]

  -- If selection was done from the bottom up then switch start & end
  if vis_end < vis_start then
    vis_start, vis_end = vis_end, vis_start
  end

  return vis_start, vis_end
end

M.edit_mru_test = function()
  local ok, test_file = pcall(M.mru_test_file)
  if not ok then
    print("Error: No test file found")
    return
  end

  vim.cmd('edit ' .. test_file)
end

return M
