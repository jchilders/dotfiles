local M = {}

local utils = require("jc.utils")
local emu = require("jc.wezterm")

-- Send line under the cursor to the pane to the left, then move cursor to
-- next line
--
-- TODO: Investigate maybe using nvim_replace_termcodes or something similar
M.send_line_left = function()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  emu.send_left(curr_line)

  -- move cursor to next line, if there is one
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if row < vim.api.nvim_buf_line_count(0) then
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

-- Send currently selected text to the pane to the left
M.send_selection_left = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local vis_start, vis_end = M.visual_selection_range()
  local content = vim.api.nvim_buf_get_lines(bufnr, vis_start - 1, vis_end, false)

  emu.send_left(table.concat(content, "\r"))
end

local function bufnr_for_test_file()
  local test_file = utils.mru_test_file()
  return vim.fn.bufnr(test_file)
end

-- Find and run the most recently modified test
-- :au BufWritePost <buffer>  lua require("jc.tmux-utils").run_mru_test()
M.run_mru_test = function(linenr)
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
      test_cmd = "bin/rspec"
    else
      test_cmd = "bin/rails test"
    end

    test_cmd = test_cmd .. " " .. test_file

    if linenr ~= nil then
      test_cmd = test_cmd .. ":" .. linenr
    end
  elseif ext == "jsx" then -- Javascript/React!
    test_cmd = "yarn test " .. test_file
  end

  local has_docker = vim.fn.filereadable("docker-compose.yml")
  if has_docker ~= 0 then
    test_cmd = "docker compose run --rm app " .. test_cmd
  end

  emu.send_left(test_cmd)
end

M.run_mru_test_current_line = function()
  local bufnr = bufnr_for_test_file()

  if bufnr == -1 then
    M.run_mru_test(0)
    return "no"
  end

  local linenr = vim.api.nvim_buf_get_mark(bufnr, '.')[1]
  return M.run_mru_test(linenr)
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
  local ok, test_file = pcall(utils.mru_test_file)
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
