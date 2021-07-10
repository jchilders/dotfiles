local enabled = true

require'nvim-treesitter.configs'.setup {
  -- Modules and its options for treesitter

  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "ruby", "javascript", "html", "css", "lua", "rust", "bash" },
  highlight = {
    enable = true,
    -- the following is needed to fix matchit/% code block matching from breaking
    -- see: https://github.com/andymass/vim-matchup/issues/145#issuecomment-820007797
    additional_vim_regex_highlighting = true,
    -- or -- additional_vim_regex_highlighting = { ruby=true },
  },
  indent = {
    enable = false
  },
  incremental_selection = {
    enable = enabled,
    keymaps = {
      init_selection = "gni",
      node_incremental = "gna",
      node_decremental = "gns",
      scope_incremental = "gnA",
    },
  },
  query_linter = {
    enable = enabled,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
  textobjects = {
    select = {
      enable = enabled,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',

        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',

        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      },
    },

    -- TODO: Could be interesting to do things w/ lists?
    -- TODO: Need to think of the right prefix for this.
    --          Almost wonder if I should go in an operator pending style
    --          thing here?... until I stop holding things.
    --
    --          Could do special stuff w/ my keyboard too :)
    swap = {
      enable = true,
      swap_next = {
        ["<M-s><M-p>"] = "@parameter.inner",
        ["<M-s>f"] = "@function.outer",
      },
      swap_previous = {
        ["<M-s><M-P>"] = "@parameter.inner",
        ["<M-s>F"] = "@function.outer",
      },
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

vim.cmd [[ set foldmethod=expr ]]
vim.cmd [[ set foldexpr=nvim_treesitter#foldexpr() ]]
vim.cmd [[ set foldlevelstart=99 ]]
