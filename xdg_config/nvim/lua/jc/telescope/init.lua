require 'core.globals'

-- SHOULD_RELOAD_TELESCOPE = true

-- local reloader = function()
--   if SHOULD_RELOAD_TELESCOPE then
--     RELOAD("plenary")
--     RELOAD("popup")
--     RELOAD("telescope")
--     RELOAD("jc.telescope.setup")
--     RELOAD("jc.telescope.custom")
--     RELOAD("core.mappings")
--   end
-- end

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local Path = require("plenary.path")

local M = {}

-- Simple dropdown with a border and no preview. Good for simple lists.
local dropdown_theme = function()
  local default_opts = {
    border = true,
    previewer = false,
  }

  return themes.get_dropdown(default_opts)
end

-- ivy theme = TS win is at bottom of screen, vertcally split
local ivy_theme = function()
  return themes.get_ivy({
    hidden = false,
  })
end

function M.find_files(opts)
  opts = opts or {}

  local theme_opts = {}

  if opts.search_dir ~= nil then
    local path = Path:new(opts.search_dir)
    if not path:exists() then
      print("Directory " .. opts.search_dir .. " does not exist.")
      return
    else
      theme_opts.search_dirs = { opts.search_dir }
    end
  end

  builtin.find_files(theme_opts)
end

function M.git_status()
  local opts = dropdown_theme()
  opts.winblend = 10
  builtin.git_status(opts)
end

function M.git_branches()
  local opts = dropdown_theme()
  opts.winblend = 10
  builtin.git_branches(opts)
end

function M.quickfix()
  local opts = {
    previewer = false,
  }

  local theme = ivy_theme()
  opts = vim.tbl_deep_extend("force", opts, theme)
  builtin.quickfix(opts)
end

-- grep string under the cursor
function M.grep_string()
  builtin.grep_string()
end

-- grep user-entered string
function M.live_grep()
  builtin.live_grep()
end

function M.find_all_files()
  builtin.find_files({
    find_command = { "fd", "--no-ignore", "--hidden" },
  })
end

return setmetatable({}, {
  -- Define a function that gets called when you try to get an array index for this class... er, table.
  __index = function(_, k)
    -- reloader()

    -- pcall(func, arg1, ...) is equivalent to func(arg1, ...) except that it
    -- will catch any errors that occur in func. If it succeeds, then the first
    -- return value will be true.
    local has_custom, custom = pcall(require, string.format("jc.telescope.custom.%s", k))

    if M[k] then
      return M[k]
    elseif has_custom then
      return custom
    else
      return builtin[k]
    end
  end,
})
