local ts_utils = require("nvim-treesitter.ts_utils")
local query = require("vim.treesitter.query")

local M = {}

local function sibling_or_parent_sibling(node, up)
  local sibling = up and node:prev_named_sibling() or node:next_named_sibling()

  if sibling ~= nil and node:type() == sibling:type() then
    return { node, sibling }
  end

  -- walk the ts tree up until we either get a matching pair, or hit the root
  local parent = node:parent()
  if parent ~= nil then
    return sibling_or_parent_sibling(parent, up)
  end
end

local function parent_node_of_type(node, type)
  if node:type() == type then
    return node
  elseif node:parent() ~= nil then
    return parent_node_of_type(node:parent(), type)
  end
end

M.swap_nodes = function(up)
  local node = ts_utils.get_node_at_cursor()
  local result = sibling_or_parent_sibling(node, up)
  if result == nil then
    return
  end
  ts_utils.swap_nodes(result[1], result[2], 0, false)
  ts_utils.goto_node(result[2])
end

-- Toggle between single and double quotes for the string under the cursor
M.toggle_quotes = function()
  local parent_string_node = parent_node_of_type(ts_utils.get_node_at_cursor(), "string")
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

-- return string
M.get_current_function = function()
  local current_function = parent_node_of_type(ts_utils.get_node_at_cursor(), "method")
  if current_function == nil then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  return query.get_node_text(current_function, bufnr)
end

return M
