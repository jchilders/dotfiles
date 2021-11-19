local scratch = {}

local api = vim.api
local git_utils = require('jc.git_utils')

scratch.open_project_scratch_file = function(bufnr)
  bufnr = 0 or bufnr
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
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
end

scratch.split_open_scratch_file = function()
  local wins = api.nvim_list_wins()
  if #wins == 1 then
    vim.cmd("split")
    scratch.open_project_scratch_file()
    return
  end

  for _, handle in pairs(vim.api.nvim_list_wins()) do
    -- set first win to active
    api.nvim_set_current_win(handle)
    scratch.open_project_scratch_file()
    return
  end
end

return scratch
