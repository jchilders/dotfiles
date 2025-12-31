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

function M.git_branches(opts)
  opts = opts or {}

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  vim.fn.system("git rev-parse --is-inside-work-tree >/dev/null 2>&1")
  if vim.v.shell_error ~= 0 then
    print("Not in a git repository.")
    return
  end

  local current = vim.fn.systemlist("git branch --show-current 2>/dev/null")[1] or ""
  local refs = vim.fn.systemlist(
    "git for-each-ref --sort=-committerdate --format='%(refname:lstrip=2)' refs/heads refs/remotes 2>/dev/null"
  )
  if vim.v.shell_error ~= 0 then
    print("Failed to list git branches.")
    return
  end

  local branches = {}
  local seen = {}
  local function add_branch(branch)
    if branch == nil or branch == "" then
      return
    end
    branch = branch:gsub("^remotes/", "")
    if branch == "HEAD" or branch:match("/HEAD$") then
      return
    end
    if branch == current then
      return
    end
    if seen[branch] then
      return
    end
    seen[branch] = true
    table.insert(branches, branch)
  end

  for _, branch in ipairs(refs) do
    add_branch(branch)
  end
  if current ~= "" then
    table.insert(branches, 1, current)
  end

  pickers.new(opts, {
    prompt_title = "Git Branches",
    finder = finders.new_table({ results = branches }),
    sorter = conf.generic_sorter(opts),
    previewer = false,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection == nil then
          return
        end

        local branch = selection.value or selection[1]
        if branch == nil or branch == "" then
          return
        end

        if branch:match("^origin/") then
          vim.fn.system({ "git", "switch", "--track", branch })
          return
        end

        local exists_cmd = "git show-ref --verify --quiet "
          .. vim.fn.shellescape("refs/heads/" .. branch)
          .. " >/dev/null 2>&1; echo $?"
        local exists = tonumber(vim.fn.system(exists_cmd))
        if exists ~= 0 then
          vim.fn.system({ "git", "switch", "--track", "origin/" .. branch })
        else
          vim.fn.system({ "git", "switch", branch })
        end
      end)

      return true
    end,
  }):find()
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
