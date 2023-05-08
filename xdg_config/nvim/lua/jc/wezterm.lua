local M = {}

local utils = require "jc.utils"

M.get_left_pane = function()
  return vim.fn.system("wezterm cli get-pane-direction left | head -1 | tr -d '\n'")
end

M.send_left = function(text)
  local esc_text = vim.fn.escape(text, '\\"$`')
  local pane_id = M.get_left_pane()
  local cmd = "wezterm cli send-text --pane-id " .. pane_id .. " --no-paste \"" .. esc_text .. "\n\""
  vim.fn.system(cmd)
end

return M
