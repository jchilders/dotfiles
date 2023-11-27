local M = {}

local git_utils = require("jc.git_utils")
local plenary_path_ok, plenary_path = pcall(require, "plenary.path")

-- @return Path path A Plenary Path object for the scratch directory
local scratch_path = function()
  if not plenary_path_ok then
    return ""
  end
  local sep = plenary_path.path.sep
  local path = vim.fn.stdpath("data") .. sep .. "scratch_files"
  return plenary_path:new(path)
end

local extension = function(bufnr)
  bufnr = 0 or bufnr
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local ext = ""
  if ft ~= nil then
    if ft == "ruby" then
      ext = "rb"
    else
      ext = ft
    end
  end
  return ext
end

-- Get the winnr of the topmost window. Used to get topmost window when there is one or more
-- vertical splits.
function M.win_top_winnr(layouts)
  layouts = layouts or vim.fn.winlayout()
  for idx, val in pairs(layouts) do
    if val == "col" then
      local leaves = layouts[idx + 1]
      -- first one is topmost(?)
      local winnr = leaves[1][2]
      return winnr
    elseif type(val) == "table" then
      M.win_top_winnr(val)
    end
  end
end

-- There are still some cases where this doesn't work, but it's good enough
-- for normal usage
function M.win_gotop()
  vim.fn.win_gotoid(M.win_top_winnr())
end

-- @return The full path and filename to the scratch file for the current project
local project_scratch_file = function(bufnr)
  local scr_path = scratch_path()

  if not scr_path:exists() then
    scr_path:mkdir()
  end

  local fname_prefix = ""
  if git_utils.is_git_repo() == true then
    fname_prefix = git_utils.current_repo_name() .. "_"
  end
  local scratch_file = fname_prefix .. "scratch." .. extension(bufnr)
  return scr_path:joinpath(scratch_file).filename
end

local scratch_bufnr = function()
  return vim.fn.bufnr(project_scratch_file(), true)
end

-- Open a project-specific scratch buffer in a split window at the top of the current window.
function M.split_open_scratch_file()
  local wins = vim.api.nvim_list_wins()
  if #wins == 1 then
    -- `:abo split <file>` will split the window horizonally without taking up
    -- the entire width of the screen
    vim.cmd("abo split " .. project_scratch_file())
    return
  end

  M.win_gotop()
  vim.api.nvim_set_current_buf(scratch_bufnr())
end

return M
