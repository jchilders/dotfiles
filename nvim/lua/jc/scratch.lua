local M = {}

local api = vim.api
local git_utils = require('jc.git_utils')

M.open_project_scratch_file = function()
  local scratch_file = git_utils.current_repo_name() .. "_scratch.rb"
  vim.cmd("edit ~/temp/" .. scratch_file)
end

return M
