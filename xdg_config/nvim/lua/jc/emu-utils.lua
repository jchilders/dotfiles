local uv = vim.loop

local emu = require("jc.wezterm")

local M = {}

-- Send line under the cursor to the pane in the given direction, then move the
-- cursor to the next line
function M.send_line(direction)
  local curr_line = vim.fn.getline(".")
  if direction == "left" then
    emu.send_left(curr_line)
  elseif direction == "right" then
    emu.send_right(curr_line)
  elseif direction == "up" then
    emu.send_up(curr_line)
  elseif direction == "down" then
    emu.send_down(curr_line)
  else
    error("Invalid direction. Allowed values are 'left', 'right', 'up', or 'down'")
  end

  -- move cursor to next line, if there is one
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if row < vim.api.nvim_buf_line_count(0) then
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

function M.send_line_left()
  M.send_line("left")
end

function M.send_line_right()
  M.send_line("right")
end

function M.send_line_up()
  M.send_line("up")
end

function M.send_line_down()
  M.send_line("down")
end

-- Send the currently visually selected lines to the pane in the given
-- direction
function M.send_selection(direction)
  local vis_start, vis_end = M.visual_selection_range()

  if vis_start == nil or vis_end == nil then
    return
  end

  local content = vim.api.nvim_buf_get_lines(vis_start[1], vis_start[2] - 1, vis_end[2], false)

  if direction == "left" then
    emu.send_left(table.concat(content, "\r"))
  elseif direction == "right" then
    emu.send_right(table.concat(content, "\r"))
  else
    error("Invalid direction. Allowed values are 'left' or 'right'")
  end
end

-- Send currently selected text to the pane to the left
function M.send_selection_left()
  M.send_selection("left")
end

-- Send currently selected text to the pane to the right
function M.send_selection_right()
  M.send_selection("right")
end

-- Send currently selected text to the pane above the current pane
function M.send_selection_up()
  M.send_selection("up")
end

-- Send currently selected text to the pane below the current pane
function M.send_selection_down()
  M.send_selection("down")
end

-- Get the range for the current visual selection, or the previous if nothing is currently selected.
--
---@param tabnr integer|nil Tab page with visual selection, or nil to use the
--current tab page
---@return {vis_start, vis_end}|{nil,nil} A tuple containing two |List|s with four numbers in each:
--     [bufnum, lnum, col, off]
function M.visual_selection_range(tabnr)
  tabnr = tabnr or vim.api.nvim_get_current_tabpage()
  local winnr = vim.api.nvim_tabpage_get_win(tabnr)

  local in_visual_mode = vim.fn.mode():match("[vV]")

  if in_visual_mode then
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getcurpos(winnr)
    local curr_bufnum = vim.api.nvim_win_get_buf(winnr)
    start_pos[1] = curr_bufnum
    end_pos[1] = curr_bufnum
    vim.fn.settabvar(tabnr, "vis_start", start_pos)
    vim.fn.settabvar(tabnr, "vis_end", end_pos)
  end

  local vis_start = vim.fn.gettabvar(tabnr, "vis_start")
  local vis_end = vim.fn.gettabvar(tabnr, "vis_end")

  if vis_start == "" or vis_end == "" then
    vim.notify("Nothing currently or previously selected to send", vim.log.levels.WARN)
    return nil, nil
  end

  return vis_start, vis_end
end

return M
