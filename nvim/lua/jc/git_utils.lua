local M = {}

-- @return {boolean}
M.is_git_repo = function()
  local f = io.popen("git rev-parse --is-inside-work-tree")
  local is_inside_work_tree = f:read("*a")
  f:close()
  return is_inside_work_tree == "true\n"
end

-- @return {string}
M.current_repo_name = function()
  local project_dir = vim.fn.system("git rev-parse --show-toplevel")
  project_dir = string.gsub(project_dir, "\n", "")
  local dirs = vim.split(project_dir, "/")

  return dirs[#dirs]
end

return M
