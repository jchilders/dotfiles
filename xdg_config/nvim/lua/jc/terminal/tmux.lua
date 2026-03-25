local M = {}

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

M.send_enter = function()
  vim.fn.system("tmux send-keys -t left Enter")
end

return M
