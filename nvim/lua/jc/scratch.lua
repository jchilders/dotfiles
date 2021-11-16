local M = {}

local api = vim.api
local git_utils = require('jc.git_utils')

M.open_project_scratch_file = function()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  local ext = ""
  if ft ~= nil then
    if ft == "ruby" then
      ext = "rb"
    else
      ext = ft
    end
  end

  fname_prefix = ""
  if git_utils.is_git_repo() == true then
    fname_prefix = git_utils.current_repo_name() .. "_"
  end

  local scratch_file = fname_prefix .. "scratch." .. ext
  vim.cmd("edit ~/temp/" .. scratch_file)

  -- TODO: test if buffer exists for `scratch_file`
  -- nvim_list_bufs()
  -- nvim_list_wins()

  --[[ local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd('vsplit') ]]
end

M.print_list = function()
  for key, val in pairs(vim.api.nvim_list_wins()) do  -- Table iteration.
    print(key, val)
  end
end

return M
