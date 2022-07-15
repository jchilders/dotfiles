local M = {}
M.__index = M

function M.init()
  local status_ok, ts_config = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  ts_config.setup({
    -- one of "all" or a list of languages
    ensure_installed = { "ruby" },
    highlight = {
      enable = true,
      -- the following is needed to fix matchit/% code block matching from breaking
      -- see: https://github.com/andymass/vim-matchup/issues/145#issuecomment-820007797
      -- additional_vim_regex_highlighting = true,
      -- or -- additional_vim_regex_highlighting = { ruby=true },
    },

    -- indents via treesitter currently borked. disabling for now. see:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
    indent = {
      enable = true,
    },

    -- windwp/nvim-ts-autotag auto close/rename html tags
    autotag = {
      enable = true,
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gni",
        node_incremental = "gna",
        node_decremental = "gns",
        scope_incremental = "gnA",
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",

          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",

          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
  })
end

return M
