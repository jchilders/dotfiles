local git_utils = require("jc.git_utils")

-- When opening a file, restore cursor position (`g'"`) to where it was when
-- that file was last edited
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
   pattern = { "*" },
   command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "Brewfile", "*.thor", "*.jbuilder", "*.arb", "*.rbi" },
  command = "set filetype=ruby",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "*.zsh" },
  command = "set filetype=bash",
})

-- local rails_server_started = function()
--   local project_root = git_utils.git_root()
--   local pid_file = project_root .. "/tmp/pids/server.pid"
--   local f=io.open(pid_file,"r")
--   if f~=nil then io.close(f) return true else return false end
-- end
--
-- local restart_rails = function()
--   if rails_server_started() ~= true then
--     return
--   end
--
--   vim.notify("Restarting Rails server")
--   local project_root = git_utils.git_root()
--   local restart_file = project_root .. "/tmp/restart.txt"
--   io.popen("touch " .. restart_file)
-- end
--
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   pattern = {
--     "app/*.rb",
--     "config/*.rb"
--   },
--   callback = restart_rails,
-- })
