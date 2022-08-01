local M = {}
M.__index = M

function M.init()
  local status_ok, config = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    return
  end

  config.setup({
    -- one of "all" or a list of languages
    ensure_installed = { "json", "lua", "ruby", "sql", "typescript" },
    highlight = {
      enable = true,
      -- the following is needed to fix matchit/% code block matching from breaking
      -- see: https://github.com/andymass/vim-matchup/issues/145#issuecomment-820007797
      -- additional_vim_regex_highlighting = true,
      -- or -- additional_vim_regex_highlighting = { ruby=true },
    },

    -- indents via treesitter currently borked. disabling for now. see:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
    indent = { enable = false },

    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "gnn",
    --     node_incremental = "grn",
    --     node_decremental = "grc",
    --     scope_incremental = "grm",
    --   },
    -- },
    -- query_linter = {
    --   enable = true,
    --   use_virtual_text = true,
    --   lint_events = { "bufwrite", "cursorhold" },
    -- },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",

          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",

          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>fd"] = { "@function.outer" },
        },
        swap_previous = {
          ["<leader>fu"] = { "@function.outer" },
        },

      },
    },
    -- playground = { -- requires nightly build
    --   enable = true,
    --   disable = {},
    --   updatetime = 25, -- debounced time for highlighting nodes in the playground from source code
    --   persist_queries = false, -- whether the query persists across vim sessions
    --   keybindings = {
    --     toggle_query_editor = "o",
    --     toggle_hl_groups = "i",
    --     toggle_injected_languages = "t",
    --     toggle_anonymous_nodes = "a",
    --     toggle_language_display = "i",
    --     focus_language = "f",
    --     unfocus_language = "f",
    --     update = "r",
    --     goto_node = "<cr>",
    --     show_help = "?",
    --   },
    -- },
  })
end

return M
