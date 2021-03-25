require'nvim-treesitter.configs'.setup {
  -- Modules and its options for treesitter

  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = { "ruby", "javascript", "html", "css", "lua", "rust", "bash" },
  highlight = {
    enable = true              -- false will disable the whole extension
  },
  indent = {
    enable = true
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
}

vim.cmd [[ set foldmethod=expr ]]
vim.cmd [[ set foldexpr=nvim_treesitter#foldexpr() ]]
vim.cmd [[ set foldlevelstart=99 ]]
