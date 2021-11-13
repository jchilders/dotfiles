SHOULD_RELOAD_TELESCOPE = true

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

local M = {}

function M.buffers()
  require("telescope.builtin").buffers {
    shorten_path = false,
  }
end

function M.fd()
  local opts = themes.get_ivy { hidden = false }
  require("telescope.builtin").fd(opts)
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
  require("telescope.builtin").find_files {
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input "type: ",
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

