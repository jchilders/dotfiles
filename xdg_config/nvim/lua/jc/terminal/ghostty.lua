local M = {}

local ghostty_directions = {
  left = "left",
  right = "right",
  up = "up",
  down = "down",
  next = "next",
  prev = "previous",
}

local function run_osascript(lines, argv)
  local cmd = { "osascript" }

  for _, line in ipairs(lines) do
    table.insert(cmd, "-e")
    table.insert(cmd, line)
  end

  if argv then
    vim.list_extend(cmd, argv)
  end

  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return false, result
  end

  return true, vim.trim(result)
end

local function normalize_text(text)
  if text == "^C" then
    return "ctrl_c", ""
  end

  if text == "Up" then
    return "up", ""
  end

  if text == "\n" or text == "\r" or text == "\r\n" then
    return "enter", ""
  end

  local normalized = text:gsub("\r\n", "\n"):gsub("\r", "\n")
  normalized = normalized:gsub("\n+$", "")

  return "text", normalized
end

function M.get_pane_id(direction)
  direction = direction or "left"

  if not require("jc.terminal.shared").valid_directions[direction] then
    error("Invalid direction. Allowed values are 'left', 'right', 'up', 'down', 'next', or 'prev'")
  end

  local ok, result = run_osascript({
    "on run argv",
    '  set direction to item 1 of argv',
    '  tell application "Ghostty"',
    "    if (count windows) is 0 then error \"Ghostty has no open windows\"",
    "    set current_window to front window",
    "    set current_tab to selected tab of current_window",
    "    set origin_terminal to focused terminal of current_tab",
    "    set origin_id to id of origin_terminal",
    "    focus origin_terminal",
    "    delay 0.1",
    '    perform action ("goto_split:" & direction) on focused terminal of current_tab',
    "    delay 0.1",
    "    set target_terminal to focused terminal of current_tab",
    "    set target_id to id of target_terminal",
    "    focus origin_terminal",
    "    if target_id is origin_id then error \"No pane in direction \" & direction",
    "    return target_id",
    "  end tell",
    "end run",
  }, { ghostty_directions[direction] })

  if not ok then
    error(result)
  end

  if result == nil or result == "" then
    error("No pane ID for direction '" .. direction .. "'")
  end

  return result
end

function M.send_text(text, direction)
  direction = direction or "left"

  local success, pane_id = pcall(M.get_pane_id, direction)

  if not success then
    vim.notify("No " .. direction .. " pane", vim.log.levels.ERROR, { title = "Send Text" })
    return
  end

  local mode, payload = normalize_text(text)
  local ok, result = run_osascript({
    "on run argv",
    '  set target_id to item 1 of argv',
    '  set mode to item 2 of argv',
    '  set payload to item 3 of argv',
    '  tell application "Ghostty"',
    "    set target_terminal to first terminal whose id is target_id",
    '    if mode is "text" then',
    '      if payload is not "" then input text payload to target_terminal',
    '      send key "enter" to target_terminal',
    '    else if mode is "enter" then',
    '      send key "enter" to target_terminal',
    '    else if mode is "up" then',
    '      send key "up" to target_terminal',
    '    else if mode is "ctrl_c" then',
    '      send key "c" modifiers "control" to target_terminal',
    '    else',
    '      error "Unsupported Ghostty send mode: " & mode',
    "    end if",
    "  end tell",
    "end run",
  }, { pane_id, mode, payload })

  if not ok then
    vim.notify(result, vim.log.levels.ERROR, { title = "Send Text (" .. direction .. ")" })
  end
end

return M
