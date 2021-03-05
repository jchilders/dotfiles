local M = {}
local api = vim.api

function M.runCurrentSpec()
  local currFile = vim.fn.expand('%')
  local currLine = api.nvim_win_get_cursor(0)
  fileLoc = string.format('Curr: %s:%d', currFile, currLine[1])
  print("File loc: %s", fileLoc)
end
