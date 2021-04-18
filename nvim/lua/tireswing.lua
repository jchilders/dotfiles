local nvim_ts = require"nvim-treesitter"
local ts_utils = require 'nvim-treesitter.ts_utils'
local parsers = require'nvim-treesitter.parsers'

-- To call from vim command prompt:
--   :lua print(vim.inspect(require('tireswing').ts_root_class()))

local M = {}

-- Get root class from tree-sitter
-- WIP
M.ts_root_class = function()
  if not parsers.has_parser() then return end

  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return "" end

  local lines = {}
  local node = current_node

  while node do
    -- local line = nvim_ts.get_line_for_node(expr, type_patterns, transform_fn)
    -- if line ~= '' and not vim.tbl_contains(lines, line) then
      -- table.insert(lines, 1, line)
    -- end
    print(node:type())
    if node:type() == 'class' then
      -- print("it's a class! and is: ")
      return ts_utils.get_node_text(node)
    -- else
      -- print("it's not a class")
    end
    node = node:parent()
  end

  return node
end

-- local ts = require('tireswing')
-- print(vim.inspect(M.ts_root_class()))

return M
