local M = {}

-- @return {string}
M.current_repo_name = function()
  local project_dir = vim.fn.system("git rev-parse --show-toplevel")
  project_dir = string.gsub(project_dir, "\n", '')
  local dirs = vim.split(project_dir, "/")

  return dirs[#dirs]
end

return M
