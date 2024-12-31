require 'core.globals'

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local Path = require("plenary.path")

local M = {}

function M.find_files(opts)
  opts = opts or {}

  if opts.search_dir ~= nil then
    local path = Path:new(opts.search_dir)
    if not path:exists() then
      print("Directory " .. opts.search_dir .. " does not exist.")
      return
    else
      opts.search_dirs = { opts.search_dir }
    end
  end

  builtin.find_files(opts)
end

function M.git_status()
  builtin.git_status()
end

function M.git_branches()
  builtin.git_branches()
end

function M.git_changed_files_curr_branch()
  builtin.git_files({
    git_command = { "git", "diff", "--name-only", "main"}
  })
end

-- grep string under the cursor
function M.grep_string()
  builtin.grep_string({
    word_match = "-w", -- exact word matches
  })
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
