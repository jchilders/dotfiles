-- in utils.lua
local M = {}
local api = vim.api

-- Create silnt normal mode mappings
function M.key_mapper(lhs, rhs)
  if (type(rhs) == "table") then
    M.key_mapper(rhs[1], rhs[2])
  else
    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap('n', lhs, rhs..'<CR>', opts)
  end
end

-- Takes array of following form, e.g.:
-- { { '<leader>u', 'gg' } }
function M.set_mappings(keymaps)
  for lhs, rhs in pairs(keymaps) do
    M.key_mapper(lhs, rhs)
  end
end

function M.dump(table)
   if type(table) == 'table' then
      local s = '{ '
      for k,v in pairs(table) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(table)
   end
end

-- " Statusline
-- function! LspStatus() abort
  -- if luaeval('#vim.lsp.buf_get_clients() > 0')
    -- return luaeval("require('lsp-status').status()")
  -- endif

  -- return ''
-- endfunction

function M.LengthOfTable(table)
  setmetatable(table,{__index={len=function(len) local incr=0 for _ in pairs(len) do incr=incr+1 end return incr end}})
  return table:len()
end

function M.LspStatus()
  if not vim.tbl_isempty(vim.lsp.buf_get_clients()) then
    return require('lsp-status').status()
  end

  return 'X'
end

-- WIP
function M.blameVirtText()
  local ft = vim.fn.expand('%:h:t') -- get the current file extension
  if ft == '' then -- if we are in a scratch buffer or unknown filetype
    return
  end
  if ft == 'bin' then -- if we are in nvim's terminal window
    return
  end
  api.nvim_buf_clear_namespace(0, 2, 0, -1) -- clear out virtual text from namespace 2 (the namespace we will set later)
  local currFile = vim.fn.expand('%')
  local line = api.nvim_win_get_cursor(0)
  local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currFile))
  local hash = vim.split(blame, '%s')[1]
  local cmd = string.format("git show %s ", hash).."--format='%an | %ar | %s'"
  if hash == '00000000' then
    text = 'Not Committed Yet'
  else
    text = vim.fn.system(cmd)
    text = vim.split(text, '\n')[1]
    if text:find("fatal") then -- if the call to git show fails
      text = 'Not Committed Yet'
    end
  end
  api.nvim_buf_set_virtual_text(0, 2, line[1] - 1, {{ text,'GitLens' }}, {}) -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
end

function M.clearBlameVirtText() -- important for clearing out the text when our cursor moves
  api.nvim_buf_clear_namespace(0, 2, 0, -1)
end

function M.runCurrentSpec()
  api.nvim_buf_clear_namespace(0, 2, 0, -1) -- clear out virtual text from namespace 2 (the namespace we will set later)
  local currFile = vim.fn.expand('%')
  local currLine = api.nvim_win_get_cursor(0)
  print(M.dumpTable(currLine))
  fileLoc = string.format('Curr: %s:%d', currFile, currLine[1])
  api.nvim_buf_set_virtual_text(0, 2, currLine[1] - 1, {{ text,'GitLens' }}, {}) -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
end

return M
