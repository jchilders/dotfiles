-- Things to do when troublshooting treesitter issues:
--   `:TSUpdate`
return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  dependencies = {
    "p00f/nvim-ts-rainbow",
    "nvim-treesitter/playground",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "bash", "git_rebase", "json", "lua", "luadoc", "markdown", "ruby", "rust", "sql", "typescript", "vim", "vimdoc" },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "<C-M>",
          node_decremental = "<S-C-M>",
          scope_incremental = "grm",
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "bufwrite", "cursorhold" },
      },
      playground = {
        enable = true,
      },
    })
  end
}

-- vim: ts=2 sts=2 sw=2 et
