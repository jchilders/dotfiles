SHOULD_RELOAD_TELESCOPE = false

local reloader = function()
  if SHOULD_RELOAD_TELESCOPE then
    RELOAD "plenary"
    RELOAD "popup"
    RELOAD "telescope"
    RELOAD "tj.telescope.setup"
    RELOAD "tj.telescope.custom"
  end
end

local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local Path = require "plenary.path"

local M = {}

function M.buffers()
  require("telescope.builtin").buffers {
    shorten_path = false,
  }
end

function M.find_files(opts)
  opts = opts or {}

  -- ivy theme = TS win is at bottom of screen, vertcally split
  theme_opts = themes.get_ivy { hidden = false }

  if opts.search_dir ~= nil then
    path = Path:new(opts.search_dir)
    if not path:exists() then
      print("Directory " .. opts.search_dir .. " does not exist.")
      return
    else
      theme_opts.search_dirs = { opts.search_dir }
    end
  end

  require("telescope.builtin").find_files(theme_opts)
end

function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }

  require("telescope.builtin").git_status(opts)
end

function M.search_only_files_of_type()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  require("telescope.builtin").find_files {
    find_command = {
      "rg",
      "--files",
      "--sortr=modified",
      "--type",
      vim.fn.input({prompt = "search files of type: ", default = ft }),
    },
  }
end

function M.lsp_references()
  require("telescope.builtin").lsp_references {
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
end

function M.live_grep()
  require("telescope.builtin").live_grep {
    shorten_path = true,
    previewer = false,
    fzf_separator = "|>",
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
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
    local has_custom, custom = pcall(require, string.format("tj.telescope.custom.%s", k))

    if M[k] then
      return M[k]
    elseif has_custom then
      return custom
    else
      return require("telescope.builtin")[k]
    end
  end,
})

