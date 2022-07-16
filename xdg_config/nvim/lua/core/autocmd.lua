local M = {}

local utils = require("utils")

local function autocmds()
  -- When opening a file, restore cursor position (`g'"`) to where it was when
  -- that file was last edited
  utils.autocmd(
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
  )
end

function M.load()
  autocmds()
end

return M
