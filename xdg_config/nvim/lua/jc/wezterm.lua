local M = {}

-- Get the ID of the pane to the left
function M.get_pane_id(direction)
  local valid_directions = { "left", "right", "up", "down", "next", "prev" }
  direction = direction or "left"

  -- Validate the direction parameter
  if not vim.tbl_contains(valid_directions, direction) then
    error("Invalid direction. Allowed values are 'left', 'right', 'up', 'down', 'next', or 'prev'")
  end

  local result = vim.fn.system("wezterm cli get-pane-direction " .. direction)

  if vim.v.shell_error ~= 0 then
    error(result)
  elseif string.len(result) == 0 then
    error("No pane ID for direction '" .. direction .. "'")
  else
    return tonumber(result)
  end
end

function M.send_text(text, direction)
  direction = direction or "left"
  local success, result = pcall(M.get_pane_id, direction)

  if not success then
    vim.notify(result, vim.log.levels.ERROR, { title = "Send Text (" .. direction .. ")" })
    return
  end

  local esc_text = vim.fn.escape(text, '\\"$`	')
  local cmd = "wezterm cli send-text --pane-id " .. result .. " --no-paste -- \"" .. esc_text .. "\n\""
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify(result, vim.log.levels.ERROR, { title = "Send Text (" .. direction .. ")" })
  end
end

function M.send_left(text)
  M.send_text(text, "left")
end

function M.send_right(text)
  M.send_text(text, "right")
end

return M
