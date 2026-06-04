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
  local fzf_opts = {}
  if opts.search_dir then
    if not vim.uv.fs_stat(opts.search_dir) then
      vim.notify("Directory " .. opts.search_dir .. " does not exist.", vim.log.levels.WARN, { title = "Search" })
      return
    end
    fzf_opts.cwd = opts.search_dir
  end
  require("fzf-lua").files(fzf_opts)
end

function M.find_all_files()
  require("fzf-lua").files({ cmd = "fd --type f --hidden --no-ignore --follow --exclude .git" })
end

function M.git_changed_files_curr_branch()
  require("fzf-lua").fzf_exec("git diff --name-only main", {
    prompt = "Changed Files> ",
    previewer = "builtin",
    actions = { ["default"] = require("fzf-lua").actions.file_edit },
  })
end

-- Grep selected text or word under cursor. Results go to the quickfix list.
-- For <cword>, uses --word-regexp for exact word boundaries.
-- For visual selection, uses --fixed-strings literal match.
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

function M.git_branches()
  vim.fn.system("git rev-parse --is-inside-work-tree >/dev/null 2>&1")
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository.", vim.log.levels.WARN, { title = "Git" })
    return
  end

  local current = vim.fn.systemlist("git branch --show-current 2>/dev/null")[1] or ""
  local refs = vim.fn.systemlist(
    "git for-each-ref --sort=-committerdate --format='%(refname:lstrip=2)' refs/heads refs/remotes 2>/dev/null"
  )

  local branches = {}
  local seen = {}
  local function add(branch)
    if not branch or branch == "" then return end
    branch = branch:gsub("^remotes/", "")
    if branch == "HEAD" or branch:match("/HEAD$") then return end
    if branch == current then return end
    if seen[branch] then return end
    seen[branch] = true
    table.insert(branches, branch)
  end

  for _, b in ipairs(refs) do add(b) end
  if current ~= "" then table.insert(branches, 1, current) end

  require("fzf-lua").fzf_exec(branches, {
    prompt = "Git Branches> ",
    winopts = { preview = { hidden = "hidden" } },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local branch = selected[1]
        if branch == current then return end
        if branch:match("^origin/") then
          vim.fn.system({ "git", "switch", "--track", branch })
          return
        end
        local cmd = "git show-ref --verify --quiet "
          .. vim.fn.shellescape("refs/heads/" .. branch)
          .. " >/dev/null 2>&1; echo $?"
        local exists = tonumber(vim.fn.system(cmd))
        if exists ~= 0 then
          vim.fn.system({ "git", "switch", "--track", "origin/" .. branch })
        else
          vim.fn.system({ "git", "switch", branch })
        end
      end,
    },
  })
end

return setmetatable(M, {
  __index = function(_, k)
    return require("fzf-lua")[k]
  end,
})
