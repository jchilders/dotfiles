local ts_utils = require("nvim-treesitter.ts_utils")
local query = require("vim.treesitter.query")

local M = {}

function string_node_for_node(node)
  if (node:type() == 'string') then
    return node
  elseif (node:parent() ~= nil) then
    return string_node_for_node(node:parent())
  end
end

M.toggle_quotes = function()
  local parent_string_node = string_node_for_node(ts_utils.get_node_at_cursor())
  if (parent_string_node == nil) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  text = query.get_node_text(parent_string_node, bufnr)
  quote = string.sub(text, 1, 1)

  local new_quote
  if quote == "\"" then
    new_quote = "'"
  else
    new_quote = "\""
  end

  start_row, start_col = parent_string_node:start()
  end_row, end_col = parent_string_node:end_()

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, start_row, start_col + 1, { new_quote })
  vim.api.nvim_buf_set_text(bufnr, end_row, end_col - 1, end_row, end_col, { new_quote })
end

return M
