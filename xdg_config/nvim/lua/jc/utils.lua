local M = {}

local api = vim.api

-- Grab bag of stuff that may or may not work

-- Like require, but gracefully handles errors
function M.prequire(m)
  local ok, err = pcall(require, m)
  if not ok then
    print("There was an error when requiring '" .. m .. "'")
    return nil, err
  end
  return err
end

-- Create silent normal mode mappings
function M.key_mapper(lhs, rhs)
  if type(rhs) == "table" then
    M.key_mapper(rhs[1], rhs[2])
  else
    local opts = { noremap = true, silent = true }
    api.nvim_set_keymap("n", lhs, rhs .. "<CR>", opts)
  end
end

-- Takes array of following form, e.g.:
-- { { '<leader>u', 'gg' } }
function M.set_mappings(keymaps)
  for lhs, rhs in pairs(keymaps) do
    M.key_mapper(lhs, rhs)
  end
end

-- This toggles the displaying of the non-text text that can appear in the window: git status indicators in the gutter, relnums, LSP warnings, and so forth. It is intended to quickly allow for a clean view of the file being edited, without all the helpers.
function M.toggle_gutter()
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

-- Does this work?
function M.add_gem_to_lsp_workspace(gem_name)
  local cmd = "gem open " .. gem_name .. " -e echo"
  local gem_path = vim.fn.system(cmd)
  gem_path = string.gsub(gem_path, "\n", "")
  print("Adding " .. gem_name .. " to LSP, path: " .. gem_path)

  vim.lsp.buf.add_workspace_folder(gem_path)
end

-- returns a string containing a comma-separated list of LSPs the current
-- buffer is attached to
function M.lsp_name()
  local bufnr = api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return "(no client)"
  else
    local client_names = ""
    local n = 0
    for _,v in pairs(clients) do
      if n > 1 then
        client_names = client_names .. ", "
      end
      n = n + 1
      client_names = client_names .. v.name
    end
    return client_names
  end
end

-- local ts_utils = M.prequire("vim.treesitter.query")

function M.T()
  local ts_utils = require("nvim-treesitter.ts_utils")
  print(ts_utils.get_node_at_cursor():type())
end

function M.root_node_text()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local curr_node = ts_utils.get_node_at_cursor()
  local root_node = ts_utils.get_root_for_node(curr_node)
  local lines = ts_utils.get_node_text(root_node)

  return lines
end

function M.N()
  local ts_utils = require("nvim-treesitter.ts_utils")
  print(ts_utils.get_node_at_cursor())
end

-- See also: vim.islist(table)
function M.is_array(table)
  if type(table) ~= "table" then
    return false
  end

  -- objects always return empty size
  if #table > 0 then
    return true
  end

  -- only object can have empty length with elements inside
  for _, _ in pairs(table) do
    return false
  end

  -- if no elements it can be array and not at same time
  return true
end

-- See also: vim.tbl_isempty(table)
-- See also: vim.tbl_count(table)
function M.table_length(table)
  setmetatable(table, {
    __index = {
      len = function(len)
        local incr = 0
        for _ in pairs(len) do
          incr = incr + 1
        end
        return incr
      end,
    },
  })
  return table:len()
end

-- See also:vim.inspect(table)
function M.dump(table)
  if type(table) == "table" then
    local s = "{ "
    for k, v in pairs(table) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(table)
  end
end

function M.dump_to_buffer(table)
  if vim.g.dump_buf_handle == nil then
    vim.g.dump_buf_handle = api.nvim_create_buf(true, true)
  end
  local lines = {}
  for k, v in pairs(table) do
    table.insert(lines, k .. ": " .. v)
  end
  for _, v in pairs(lines) do
    print(v)
  end
  -- api.nvim_buf_set_lines(vim.g.dump_buf_handle, 0, -1, false, lines)
end

-- WIP
function M.blameVirtText()
  local ft = vim.fn.expand("%:h:t") -- get the current file extension
  if ft == "" then -- if we are in a scratch buffer or unknown filetype
    return
  end
  if ft == "bin" then -- if we are in nvim's terminal window
    return
  end
  api.nvim_buf_clear_namespace(0, 2, 0, -1) -- clear out virtual text from namespace 2 (the namespace we will set later)
  local currFile = vim.fn.expand("%")
  local line = api.nvim_win_get_cursor(0)
  local blame = vim.fn.system(string.format("git blame -c -L %d,%d %s", line[1], line[1], currFile))
  local hash = vim.split(blame, "%s")[1]
  local cmd = string.format("git show %s ", hash) .. "--format='%an | %ar | %s'"
  local text = ""
  if hash == "00000000" then
    text = "Not Committed Yet"
  else
    text = vim.fn.system(cmd)
    text = vim.split(text, "\n")[1]
    if text:find("fatal") then -- if the call to git show fails
      text = "Not Committed Yet"
    end
  end

  -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
  api.buf_set_virtual_text(0, 2, line[1] - 1, { { text, "GitLens" } }, {})
end

function M.clearBlameVirtText() -- important for clearing out the text when our cursor moves
  api.nvim_buf_clear_namespace(0, 2, 0, -1)
end

return M
