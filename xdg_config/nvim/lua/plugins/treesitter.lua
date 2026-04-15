-- Things to do when troublshooting treesitter issues:
--   `:TSUpdate`
return {
  "nvim-treesitter/nvim-treesitter",
  enabled = false,
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "cpp",
        "css",
        "git_rebase",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "ruby",
        "rust",
        "sql",
        "typescript",
        "vim",
        "vimdoc"
      },
      highlight = {
        enable = true,
      },
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
    })
  end
}

-- vim: ts=2 sts=2 sw=2 et
