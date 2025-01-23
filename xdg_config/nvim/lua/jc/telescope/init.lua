require 'core.globals'

local builtin = require("telescope.builtin")
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

function M.find_all_files()
  builtin.find_files({
    find_command = { "fd", "--no-ignore", "--hidden" },
  })
end

-- This allows us to override Telescope methods with our own custom behavior,
-- falling back to Telescope's built-in functions if there isn't one.
-- In other words: method overriding. 
return setmetatable({}, {
  -- `__index` is a metamethod that gets called when you try to access any
  -- method on the returned table. Here we check if the function exists in 
  -- our custom implementation, otherwise return Telescope's.
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return builtin[k]
    end
  end,
})
