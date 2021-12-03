local ts_utils = require("nvim-treesitter.ts_utils")
local query = require("vim.treesitter.query")

local M = {}

local function string_node_for_node(node)
  if node:type() == "string" then
    return node
  elseif node:parent() ~= nil then
    return string_node_for_node(node:parent())
  end
end

-- Toggle between single and double quotes for the string under the cursor
M.toggle_quotes = function()
  local parent_string_node = string_node_for_node(ts_utils.get_node_at_cursor())
  if parent_string_node == nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local text = query.get_node_text(parent_string_node, bufnr)
  local quote = string.sub(text, 1, 1)

  local new_quote
  if quote == '"' then
    new_quote = "'"
  else
    new_quote = '"'
  end

  local start_row, start_col = parent_string_node:start()
  local end_row, end_col = parent_string_node:end_()

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, start_row, start_col + 1, { new_quote })
  vim.api.nvim_buf_set_text(bufnr, end_row, end_col - 1, end_row, end_col, { new_quote })
end

return M
