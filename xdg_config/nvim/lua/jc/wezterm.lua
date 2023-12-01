local M = {}

function M.get_left_pane()
  return vim.fn.system("wezterm cli get-pane-direction left | head -1 | tr -d '\n'")
end

function M.send_left(text)
  local esc_text = vim.fn.escape(text, '\\"$`	')
  local pane_id = M.get_left_pane()
  local cmd = "wezterm cli send-text --pane-id " .. pane_id .. " --no-paste \"" .. esc_text .. "\n\""
  vim.fn.system(cmd)
end

return M
