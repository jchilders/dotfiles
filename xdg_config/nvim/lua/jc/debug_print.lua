local M = {}

local templates = {
  javascript = {
    single = 'console.log("%s:", %s);',
    multi = 'console.log({%s});',
    param_format = '%s: %s',
  },
  typescript = {
    single = 'console.log("%s:", %s);',
    multi = 'console.log({%s});',
    param_format = '%s: %s',
  },
  python = {
    single = 'print(f"{%s=}")',
    multi = 'print({%s})',
    param_format = '"%s": %s',
  },
  ruby = {
    single = 'puts "%s: #{%s}"',
    multi = 'puts({ %s })',
    param_format = '%s: %s',
  },
  php = {
    single = 'echo "%s: " . %s;',
    multi = 'echo json_encode([%s]);',
    param_format = '"%s" => %s',
  },
  lua = {
    single = 'print("%s:", %s)',
    multi = 'print(vim.inspect({%s}))',
    param_format = '%s = %s',
  },
}

-- Insert a debug print for the nearest variable or parameter(s).
-- @param insert_above boolean: if true, insert above current line, otherwise below
function M.insert_print_statement(insert_above)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current_node = ts_utils.get_node_at_cursor()
  local original_node = current_node
  local param_list = nil
  local var_node = nil

  local filetype = vim.bo.filetype
  local tmpl = templates[filetype]
  if not tmpl then
    print("Unsupported filetype: " .. filetype)
    return
  end

  while current_node do
    if current_node:type() == "identifier" then
      var_node = current_node
      break
    end
    current_node = current_node:prev_sibling() or current_node:parent()
    if not current_node then break end
  end

  current_node = original_node
  while current_node do
    if current_node:type() == "formal_parameters" then
      param_list = current_node
      break
    end
    current_node = current_node:parent()
    if not current_node then break end
  end

  if not var_node and not param_list then
    print("No variable or parameter found")
    return
  end

  local log_stmt = ""
  if param_list and (not var_node or ts_utils.get_node_range(param_list) > ts_utils.get_node_range(var_node)) then
    local params = {}
    for child in param_list:iter_children() do
      if child:type() == "identifier" then
        table.insert(params, vim.treesitter.get_node_text(child, 0))
      end
    end

    if #params > 0 then
      local formatted_params = table.concat(
        vim.tbl_map(function(p) return string.format(tmpl.param_format, p, p) end, params),
        ", "
      )
      log_stmt = string.format(tmpl.multi, formatted_params)
    end
  else
    local name = vim.treesitter.get_node_text(var_node, 0)
    log_stmt = string.format(tmpl.single, name, name)
  end

  local api = vim.api
  local line = api.nvim_win_get_cursor(0)[1]
  local current_line = api.nvim_buf_get_lines(0, line - 1, line, false)[1]
  local indent = current_line:match("^%s+") or ""

  if insert_above then
    api.nvim_buf_set_lines(0, line - 1, line - 1, false, { indent .. log_stmt })
  else
    api.nvim_buf_set_lines(0, line, line, false, { indent .. log_stmt })
  end
end

return M
