SHOULD_RELOAD_TELESCOPE = true

local reloader = function()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD "plenary"
    RELOAD "popup"
    RELOAD "telescope"
    RELOAD "jc.telescope.setup"
    RELOAD "jc.telescope.custom"
    RELOAD "core.mappings"
  end
end

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local Path = require("plenary.path")

local M = {}

local dropdown_theme = function()
  local default_opts = {
    border = true,
    previewer = false,
  }

  return themes.get_dropdown(default_opts)
end

-- ivy theme = TS win is at bottom of screen, vertcally split
local ivy_theme = function()
  return themes.get_ivy {
    hidden = false
  }
end

function M.buffers()
  local theme = dropdown_theme()
  local opts = {
    shorten_path = false,
    sort_mru = true,
    only_cwd = true,
  }
  opts = vim.tbl_extend('error', opts, theme)

  builtin.buffers(opts)
end

function M.find_files(opts)
  opts = opts or {}

  local theme_opts = ivy_theme()

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
  builtin.git_status(opts)
end

function M.git_branches()
  local opts = dropdown_theme()
  builtin.git_branches(opts)
end

function M.quickfix()
  local opts = {}

  local theme = ivy_theme()
  opts = vim.tbl_deep_extend("force", opts, theme)
  builtin.quickfix(opts)
end

function M.search_only_files_of_type()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local ft = vim.fn.input({prompt = "search files of type: ", default = bufft })
  local opts = {
    find_command = {
      "rg",
      "--files",
      "--sortr=modified",
      "--type",
      ft
    },
  }
  opts = vim.tbl_extend('error', opts, ivy_theme())

  builtin.grep_string(opts)
end

function M.lsp_references()
  builtin.lsp_references(ivy_theme())
end

-- grep string under the cursor
function M.grep_string()
  local opts = {
    shorten_path = true,
    previewer = false,
    disable_coordinates = true,
  }
  opts = vim.tbl_extend('error', opts, ivy_theme())
  builtin.grep_string(opts)
end

-- grep user-entered string
function M.live_grep()
  local opts = {
    shorten_path = true,
    previewer = false,
    disable_coordinates = true,
  }
  opts = vim.tbl_extend('error', opts, ivy_theme())
  builtin.live_grep(opts)
end

function M.search_all_files()
  builtin.find_files {
    find_command = { "rg", "--no-ignore", "--files" },
  }
end

return setmetatable({}, {
  -- Define a function that gets called when you try to get an array index for this class... er, table. example:
  --
  --     require("jc.telescope")['some_method']() -- this would call telescope.some_method()
  __index = function(_, k)
    reloader()

    -- pcall(func, arg1, ...) is equivalent to func(arg1, ...) except that it will catch any errors that occur in func
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

