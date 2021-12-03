local M = {}

local api = vim.api

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

function M.visual_selection_range()
  local vis_start = vim.fn.getpos("v")[2]
  local vis_end = vim.fn.getcurpos()[2]

  -- If selection was done from the bottom up then switch start & end
  if vis_end < vis_start then
    vis_start, vis_end = vis_end, vis_start
  end

  return vis_start, vis_end
end

-- Find and run the most recently updated test
M.run_mru_rails_test = function()
  local find_cmd = "stat -f '%a %N' spec/**/*_spec.rb | sort -r | head -1 | awk '{print $NF}'"
  local test_file = vim.fn.system(find_cmd)
  local test_cmd = "rspec " .. test_file

  M.send_left(test_cmd)
end

return M
