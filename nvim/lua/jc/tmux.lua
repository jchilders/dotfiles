local M = {}


-- Send line under the cursor to the tmux pane to the left
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  M.send_left(curr_line)
end

-- Send currently selected text to the tmux pane to the left
M.send_selection_left = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = vim.api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  M.send_left(table.concat(content, "\r"))
end

M.run_mru_rails_test = function()
  local find_str = "find test -type f -exec stat -f '%a %N' {} \\; | sort -r | head -1 | awk '{print $NF}'"
  local cmd_str = "rails test $(" .. find_str .. ")"
  M.send_left(cmd_str)
end

M.send_left = function(text)
  local esc_text = vim.fn.escape(text, '\"$')
  local tmux_cmd = string.format('tmux send-keys -t left "%s" Enter', esc_text)

  vim.fn.system(tmux_cmd)
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

return M
