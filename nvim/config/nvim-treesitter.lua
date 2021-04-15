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
    enable = true,
    keymaps = {
      init_selection = "gni",
      node_incremental = "gna",
      node_decremental = "gns",
      scope_incremental = "gnA",
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
