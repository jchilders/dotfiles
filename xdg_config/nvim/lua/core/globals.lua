local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
  reloader = require
else
  reloader = plenary_reload.reload_module
end

RELOAD = function(...)
  return reloader(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

local globals = {}

local home = os.getenv("HOME")
-- local path_sep = globals.is_windows and "\\" or "/"
local path_sep = package.config:sub(1, 1)
local os_name = vim.loop.os_uname().sysname

function globals:load_variables()
  self.is_darwin = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.os_name = os_name
  self.vim_path = vim.fn.stdpath("config")
  self.path_sep = path_sep
  self.home = home
  self.git_root = io.popen("git rev-parse --show-toplevel"):read()
  self.lsp_path = vim.fn.stdpath("data") .. path_sep .. "lsp"
  self.data_path = string.format("%s" .. path_sep .. "site" .. path_sep, vim.fn.stdpath("data"))
end

globals:load_variables()

return globals
