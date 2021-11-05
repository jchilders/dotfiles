local M = {}

local api = vim.api
local utils = require "jc.utils"

M.open_project_scratch_file = function()
  local project_dir = vim.fn.system("git rev-parse --show-toplevel")
  dir2 = string.gsub(project_dir, "\n", '')
  local dirs = utils.split(dir2, "/")
  local scratch_file = dirs[#dirs] .. "_scratch.rb"

  cmd = "edit ~/temp/" .. scratch_file
  vim.cmd(cmd)
end

return M
