require 'core.globals'

local builtin = require("telescope.builtin")
local Path = require("plenary.path")
local git_utils = require("jc.git_utils")

local M = {}

local function get_visual_selection_text()
  local mode = vim.fn.mode()
  local is_visual_mode = mode == "v" or mode == "V" or mode == string.char(22)
  if not is_visual_mode then
    return nil
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local srow, scol = start_pos[2] - 1, start_pos[3] - 1
  local erow, ecol = end_pos[2] - 1, end_pos[3] - 1

  if srow > erow or (srow == erow and scol > ecol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end

  local lines
  if mode == "V" then
    lines = vim.api.nvim_buf_get_lines(0, srow, erow + 1, false)
  else
    lines = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol + 1, {})
  end

  if lines == nil or #lines == 0 then
    return nil
  end

  local text = vim.trim(table.concat(lines, "\n"))
  if text == "" then
    return nil
  end

  return text
end

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

-- grep selected text or, if none selected, word under cursor
function M.grep_string()
  local query = get_visual_selection_text()
  local is_visual_query = query ~= nil

  if not is_visual_query then
    query = vim.fn.expand("<cword>")
  end

  if query == nil or query == "" then
    vim.notify("Nothing selected and no word under cursor.", vim.log.levels.WARN, { title = "Search" })
    return
  end

  query = vim.trim(query:gsub("\r", ""):gsub("\n", " "))
  if query == "" then
    vim.notify("Nothing selected and no word under cursor.", vim.log.levels.WARN, { title = "Search" })
    return
  end

  local search_root = vim.fn.getcwd()
  if git_utils.is_git_repo() then
    search_root = git_utils.git_root()
  end

  local rg_args = {
    "rg",
    "--vimgrep",
    "--smart-case",
    "--hidden",
    "--glob",
    "!.git/*",
    "--fixed-strings",
  }

  -- Keep <cword> behavior exact at word boundaries; selected text is literal.
  if not is_visual_query then
    table.insert(rg_args, "--word-regexp")
  end

  table.insert(rg_args, query)
  table.insert(rg_args, search_root)

  local output = vim.fn.system(rg_args)
  local exit_code = vim.v.shell_error

  if exit_code > 1 then
    vim.notify("rg failed while searching for '" .. query .. "'", vim.log.levels.ERROR, { title = "Search" })
    return
  end

  local lines = vim.split(output, "\n", { trimempty = true })
  vim.fn.setqflist({}, "r", {
    title = string.format("search: %s", query),
    lines = lines,
    efm = "%f:%l:%c:%m",
  })

  if #lines == 0 then
    vim.notify("No matches for '" .. query .. "'", vim.log.levels.INFO, { title = "Search" })
    vim.cmd("cclose")
    return
  end

  vim.cmd("copen")
  vim.cmd("cc 1")
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
