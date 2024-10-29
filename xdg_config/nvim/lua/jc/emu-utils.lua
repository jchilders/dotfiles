local uv = vim.loop

local emu = require("jc.wezterm")
local utils = require("jc.utils")

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
  tabnr = vim.F.if_nil(tabnr, vim.api.nvim_get_current_tabpage())
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

-- Get the buffer number for the most recently modified test file
-- If the file is not open, open it
local bufnr_for_test_file = function()
  local test_file = utils.mru_test_file()
  if test_file == nil then
    vim.notify("No test file found", vim.log.levels.WARN)
    return -1
  end

  local bufnr = vim.fn.bufnr(test_file)
  if bufnr == -1 then
    vim.cmd('edit ' .. test_file)
    bufnr = vim.fn.bufnr(test_file)
  end

  vim.notify(string.format("test_file: %s, bufnr: %s", test_file, bufnr))

  return vim.fn.bufnr(test_file)
end

-- Find and run the most recently modified test
-- :au BufWritePost <buffer>  lua require("jc.tmux-utils").run_mru_test()
function M.run_mru_test(linenr)
  local test_file = utils.mru_test_file()
  if test_file == nil then
    return
  end

  local ext = vim.fn.expand("%:e") -- get the current file extension
  local test_cmd;

  -- TODO abstract this out. big if/else == bad
  if ext == "rb" then -- Ruby!
    local is_spec = string.find(test_file, "_spec")
    if is_spec then
      -- check if the rspec command exists in the bin directory
      local has_rspec = vim.fn.filereadable("bin/rspec")
      if has_rspec == 1 then
        test_cmd = "bin/rspec"
      else
        test_cmd = "rspec"
      end
    else
      test_cmd = "bin/rails test"
    end

    test_cmd = test_cmd .. " " .. test_file

    if linenr ~= nil then
      test_cmd = test_cmd .. ":" .. linenr
    end
  elseif ext == "jsx" then -- JS/React
    test_cmd = "yarn test " .. test_file
  end

  local has_docker = vim.fn.filereadable("docker-compose.yml")
  if has_docker ~= 0 then
    test_cmd = "docker compose run --rm app " .. test_cmd
  end

  emu.send_left(test_cmd)
end

function M.run_mru_test_current_line()
  local bufnr = bufnr_for_test_file()
  vim.notify(string.format("bufnr: %s", bufnr))

  if bufnr == -1 then
    -- M.run_mru_test(0)
    print "No buffer for test file"
    return "no"
  end

  -- local winnr = vim.fn.bufwinnr(bufnr)
  -- get window ID
  -- local win_id = vim.fn.win_getid(winnr)
  -- local linenr = vim.api.nvim_win_get_cursor(win_id)[1]
  local linenr = vim.api.nvim_buf_get_mark(bufnr, '.')[1]
  return M.run_mru_test(linenr)
end

function M.edit_mru_test()
  local ok, test_file = pcall(utils.mru_test_file)
  if not ok then
    vim.notify("No test file found to run", vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. test_file)
end

-- Send array `keys` as keys to the tmux pane to the left
-- See: http://man.openbsd.org/OpenBSD-current/man1/tmux.1#KEY_BINDINGS
function M.send_keys_left(keys)
  for _, key in ipairs(keys) do
    local esc_text = vim.fn.escape(key, '"$`')
    local text_to_send = string.format('tmux send-keys -t left "%s"', esc_text)
    vim.fn.system(text_to_send)
  end
end

-- Get the current line number of the most recently modified file
function M.get_mru_file_line_number()
  local mru_file = utils.mru_test_file()
  if mru_file == nil then
    vim.notify("No recently modified test file found", vim.log.levels.WARN)
    return nil
  end

  local bufnr = vim.fn.bufnr(mru_file)
  if bufnr == -1 then
    -- File is not open, so let's open it
    vim.cmd('edit ' .. vim.fn.fnameescape(mru_file))
    bufnr = vim.fn.bufnr(mru_file)
  end

  local winnr = vim.fn.bufwinnr(bufnr)
  if winnr == -1 then
    -- Buffer exists but is not visible, so let's make it visible
    vim.cmd('sbuffer ' .. bufnr)
    winnr = vim.fn.bufwinnr(bufnr)
  end

  local linenr = vim.api.nvim_win_get_cursor(winnr)[1]
  return linenr
end

return M
