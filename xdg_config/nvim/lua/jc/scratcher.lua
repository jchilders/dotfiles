local scratcher = {}

local api = vim.api
local git_utils = require("jc.git_utils")
local plenary_path_ok, plenary_path = pcall(require, "plenary.path")

-- @return Path path A Plenary Path object for the scratch directory
local function scratch_path()
  if not plenary_path_ok then
    return ""
  end
  local sep = plenary_path.path.sep
  local path = vim.fn.stdpath("data") .. sep .. "scratch_files"
  return plenary_path:new(path)
end

local function extension(bufnr)
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

-- Get the topmost window. Used to get topmost window when there is one or more
-- vertical splits.
local function recurse_layouts(layouts)
  for idx, val in pairs(layouts) do
    if val == "col" then
      local leaves = layouts[idx + 1]
      -- first one is topmost(?)
      local winnr = leaves[1][2]
      return winnr
    elseif type(val) == "table" then
      recurse_layouts(val)
    end
  end
end

-- there are still a lot of cases where this doesn't work, but it's good enough
-- for my normal use case
local function go_to_top_win()
  local layouts = vim.fn.winlayout()
  local winid = recurse_layouts(layouts)
  vim.fn.win_gotoid(winid)
end

-- @treturn String path The full path and filename to the scratch file for current project
local function project_scratch_file(bufnr)
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

-- Open a project-specific scratch buffer in a split window at the top of the current window.
scratcher.split_open_scratch_file = function()
  local wins = api.nvim_list_wins()
  local scratchf = project_scratch_file()
  if #wins == 1 then
    -- `:abo split <file>` will split the window horizonally without taking up
    -- the entire width of the screen
    vim.cmd("abo split " .. scratchf)
    return
  end

  go_to_top_win()

  local bufnr = vim.fn.bufnr(scratchf, true)
  vim.api.nvim_set_current_buf(bufnr)
end

return scratcher
