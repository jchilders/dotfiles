local M = {}


-- Send line under the cursor to the tmux pane to the left
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  M.send_to_tmux(curr_line)
end

-- Send currently selected text to the tmux pane to the left
M.send_selection_left = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = vim.api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  M.send_to_tmux(table.concat(content, "\r"))
end

M.send_to_tmux = function(text)
  local esc_text = vim.fn.escape(text, '\"$')
  local tmux_cmd = string.format('tmux send-keys -t left -l "%s"', esc_text)

  vim.fn.system(tmux_cmd)
  vim.fn.system("tmux send-keys -t left 'C-m'")
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
