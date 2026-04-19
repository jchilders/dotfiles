local M = {}

local api = vim.api

-- This toggles the displaying of the non-text text that can appear in the window: git status indicators in the gutter, relnums, LSP warnings, and so forth. It is intended to quickly allow for a clean view of the file being edited, without all the helpers.
function M.toggle_zenish()
  if vim.wo.relativenumber == true then
    vim.wo.signcolumn = "no"
    vim.wo.relativenumber = false
    vim.wo.number = false
    -- Disable indent-blankline: virutal text showing indent guides
    require("ibl").update { enabled = false }
    -- Disable LSP diagnostics
    vim.diagnostic.enable(false)
  else
    vim.wo.signcolumn = "yes"
    vim.wo.relativenumber = true
    vim.wo.number = true
    -- Enable indent-blankline: virutal text showing indent guides
    require("ibl").update { enabled = true }
    -- Enable LSP diagnostics
    vim.diagnostic.enable(true)
  end
end

-- returns a string containing a comma-separated list of LSPs the current
-- buffer is attached to
function M.lsp_name()
  local clients = vim.lsp.get_clients({ bufnr = api.nvim_get_current_buf() })
  if #clients == 0 then
    return "(no client)"
  end
  return table.concat(vim.tbl_map(function(c) return c.name end, clients), ", ")
end

-- Language-specific debug print templates
local debug_print_templates = {
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

-- Insert a debug print for the nearest variable or parameter(s)
-- @param insert_above boolean: if true, insert above current line, otherwise below
function M.insert_print_statement(insert_above)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current_node = ts_utils.get_node_at_cursor()
  local original_node = current_node
  local param_list = nil
  local var_node = nil

  -- Get current filetype and templates
  local filetype = vim.bo.filetype
  local templates = debug_print_templates[filetype]
  if not templates then
    print("Unsupported filetype: " .. filetype)
    return
  end

  -- First try to find the nearest variable identifier
  while current_node do
    if current_node:type() == "identifier" then
      var_node = current_node
      break
    end
    current_node = current_node:prev_sibling() or current_node:parent()
    if not current_node then break end
  end

  -- Reset and look for parameters
  current_node = original_node
  while current_node do
    if current_node:type() == "formal_parameters" then
      param_list = current_node
      break
    end
    current_node = current_node:parent()
    if not current_node then break end
  end

  -- No identifiers found
  if not var_node and not param_list then
    print("No variable or parameter found")
    return
  end

  local log_stmt = ""
  if param_list and (not var_node or ts_utils.get_node_range(param_list) > ts_utils.get_node_range(var_node)) then
    -- Handle all parameters in the function
    local params = {}
    for child in param_list:iter_children() do
      if child:type() == "identifier" then
        local param_name = vim.treesitter.get_node_text(child, 0)
        table.insert(params, param_name)
      end
    end

    if #params > 0 then
      local formatted_params = table.concat(
        vim.tbl_map(
          function(p)
            return string.format(templates.param_format, p, p)
          end,
          params
        ),
        ", "
      )
      log_stmt = string.format(templates.multi, formatted_params)
    end
  else
    -- Handle single variable
    local name = vim.treesitter.get_node_text(var_node, 0)
    log_stmt = string.format(templates.single, name, name)
  end

  -- Get current line number
  local line = api.nvim_win_get_cursor(0)[1]

  -- Get the indentation of the current line
  local current_line = api.nvim_buf_get_lines(0, line - 1, line, false)[1]
  local indent = current_line:match("^%s+") or ""

  -- Insert the debug print with proper indentation
  if insert_above then
    api.nvim_buf_set_lines(0, line - 1, line - 1, false, {indent .. log_stmt})
  else
    api.nvim_buf_set_lines(0, line, line, false, {indent .. log_stmt})
  end
end

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
    return
  end

  vim.cmd("copen")
end

return M
