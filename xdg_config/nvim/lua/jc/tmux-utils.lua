local uv = vim.loop

local emu = require("jc.wezterm")
local utils = require("jc.utils")

local M = {}

-- in process
function M.cat()
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  vim.notify("stdin" .. ": " .. vim.inspect(stdin))
  vim.notify("stdout" .. ": " .. vim.inspect(stdout))
  vim.notify("stderr" .. ": " .. vim.inspect(stderr))

  -- local cmd = "wezterm cli get-pane-direction left"
  local cmd = "cat"
  local handle, pid = uv.spawn(cmd, {
    stdio = {stdin, stdout, stderr}
  }, function(code, signal) -- on exit
    vim.notify("exit code" .. ": " .. vim.inspect(code))
    vim.notify("exit signal" .. ": " .. vim.inspect(signal))
  end)

  vim.notify("process opened" .. ": " .. vim.inspect(pid))

  uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      vim.notify("stdout chunk" .. ": " .. vim.inspect(data))
    else
      vim.notify("stdout end" .. ": " .. vim.inspect(stdout))
    end
  end)

  uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      vim.notify("stderr chunk" .. ": " .. vim.inspect(data))
    else
      vim.notify("stderr end" .. ": " .. vim.inspect(stderr))
    end
  end)

  uv.write(stdin, "Hello World")

  uv.shutdown(stdin, function()
    vim.notify("stdin shutdown" .. ": " .. vim.inspect(stdin))
    if handle then
      uv.close(handle, function()
        vim.notify("process closed" .. ": " .. vim.inspect(pid))
      end)
    end
  end)
end

-- Send line under the cursor to the pane to the left, then move cursor to
-- next line
--
-- TODO: Investigate maybe using nvim_replace_termcodes or something similar
function M.send_line_left()
  local curr_line = vim.fn.trim(vim.fn.getline("."))
  emu.send_left(curr_line)

  -- move cursor to next line, if there is one
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if row < vim.api.nvim_buf_line_count(0) then
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  end
end

-- Send currently selected text to the pane to the left
function M.send_selection_left()
  local vis_start, vis_end = M.visual_selection_range()

  if vis_start == nil or vis_end == nil then
    return
  end

  -- TODO make this work with blocks instead of just lines
  local content = vim.api.nvim_buf_get_lines(vis_start[1], vis_start[2] - 1, vis_end[2], false)
  emu.send_left(table.concat(content, "\r"))
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

local bufnr_for_test_file = function()
  return vim.fn.bufnr(utils.mru_test_file())
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

function M.run_mru_test_current_line()
  local bufnr = bufnr_for_test_file()

  if bufnr == -1 then
    M.run_mru_test(0)
    return "no"
  end

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

return M
