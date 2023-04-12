local M = {}

local api = vim.api
local utils = require "jc.utils"

-- local emu = require "jc.tmux"
local emu = require "jc.wezterm"

-- Send line under the cursor to the pane to the left, then move cursor to
-- next line
--
-- TODO: Investigate maybe using nvim_replace_termcodes or something similar
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  emu.send_left(curr_line)

  -- move cursor to next line, if there is one
  local row, col = unpack(api.nvim_win_get_cursor(0))
  if row < api.nvim_buf_line_count(0) then
    api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

-- Send currently selected text to the pane to the left
M.send_selection_left = function()
  local bufnr = api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  content = table.concat(content, "\r")

  emu.send_left(content)
end

local function bufnr_for_test_file()
  local test_file = utils.mru_test_file()
  return vim.fn.bufnr(test_file)
end

-- Find and run the most recently modified test
M.run_mru_test = function(...)
  local test_file = utils.mru_test_file()
  if test_file == nil then
    vim.notify("No test file found to run", vim.log.levels.WARN, { title = "Muxor" })
    return
  end

  local is_spec = string.find(test_file, "_spec")
  local test_cmd = (is_spec and "rspec " or "rails test ") .. test_file
  local arg = {...}
  for _, row in ipairs(arg) do
    if row > 0 then
      test_cmd = test_cmd .. ":" .. row
    end
  end

  emu.send_left(test_cmd)
end

M.run_mru_test_current = function()
  local buf = bufnr_for_test_file()

  if buf == -1 then
    M.run_mru_test(0)
    return
  end

  local lnum = vim.api.nvim_buf_get_mark(buf, '"')[1]
  M.run_mru_test(lnum)
end

function M.visual_selection_range()
  local vis_start = vim.fn.getpos("v")[2]
  local vis_end = vim.fn.getcurpos()[2]

  -- If selection was done from the bottom up then switch start & end
  if vis_end < vis_start then
    vis_start, vis_end = vis_end, vis_start
  end

  return vis_start, vis_end
end

M.edit_mru_test = function()
  local ok, test_file = pcall(M.mru_test_file)
  if not ok then
    vim.notify("No test file found to run", vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. test_file)
end

-- Send array `keys` as keys to the tmux pane to the left
-- See: http://man.openbsd.org/OpenBSD-current/man1/tmux.1#KEY_BINDINGS
M.send_keys_left = function(keys)
  for _, key in ipairs(keys) do
    local esc_text = vim.fn.escape(key, '"$`')
    local text_to_send = string.format('tmux send-keys -t left "%s"', esc_text)
    vim.fn.system(text_to_send)
  end
end

return M
