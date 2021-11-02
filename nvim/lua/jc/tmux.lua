local M = {}

local api = vim.api

-- Send line under the cursor to the tmux pane to the left, then move cursor to
-- next line
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  M.send_left(curr_line)
  M.send_enter()

  local row, col = unpack(api.nvim_win_get_cursor(0))
  if row < api.nvim_buf_line_count(0) then
    api.nvim_win_set_cursor(0, {row + 1, col})
  end
end

-- Send currently selected text to the tmux pane to the left
M.send_selection_left = function()
  local bufnr = api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  content = table.concat(content, "\r")
  -- Append a CR if the last char isn't already one
  if content:sub(#content, #content) ~= "\r" then
    content = content .. "\r"
  end

  M.send_left(content)
end

M.send_enter = function()
  vim.fn.system('tmux send-keys -t left Enter')
end

M.send_left = function(text)
  local esc_text = vim.fn.escape(text, '\"$`')
  local send_text = string.format('tmux send-keys -l -t left "%s"', esc_text)
  vim.fn.system(send_text)
end

function M.visual_selection_range()
  local vis_start = vim.fn.getpos('v')[2]
  local vis_end = vim.fn.getcurpos()[2]

  -- If selection was done from the bottom up then switch start & end
  if vis_end < vis_start then
    vis_start, vis_end = vis_end, vis_start
  end

  return vis_start, vis_end
end

-- Find the most recently modified file with 'test' in its name and run it with 'rails test'
M.run_mru_rails_test = function()
  local find_str = "find test -type f -exec stat -f '%a %N' {} \\; | sort -r | head -1 | awk '{print $NF}'"
  local cmd_str = "rails test $(" .. find_str .. ")"
  M.send_left(cmd_str)
end

return M
