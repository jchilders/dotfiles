local M = {}

--[[
git rev-parse --show-toplevel # dir path "of working tree" (i.e. the project dir. has nothing to do with worktrees.)
git rev-parse --is-inside-work-tree # true/false
git rev-parse --show-prefix # get current dir only
git rev-parse --git-dir # <full path>/.git
git rev-parse --show-superproject-working-tree
 ]]

-- @return {boolean}
M.is_git_repo = function()
  local f = io.popen("git rev-parse --is-inside-work-tree")
  local is_inside_work_tree = f:read("*a")
  f:close()
  return is_inside_work_tree == "true\n"
end

M.git_root = function()
  local project_dir = vim.fn.system("git rev-parse --show-toplevel")
  return string.gsub(project_dir, "\n", "")
end

-- @return {string}
M.current_repo_name = function()
  -- local project_dir = vim.fn.system("git rev-parse --show-toplevel")
  local project_dir = M.git_root()
  local dirs = vim.split(project_dir, "/")

  return dirs[#dirs]
end

return M
