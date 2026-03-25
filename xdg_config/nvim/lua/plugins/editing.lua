return {
  {
    -- Automatic indentation detection
    "tpope/vim-sleuth",
    enabled = true,
  },
  {
    -- auto-close parens/quotes/etc.
    "cohama/lexima.vim",
    enabled = true,
  },
  {
    -- ysw( - surround word with parens (`w` here is a text object)
    -- ds" - delete surrounding quotes
    -- cs"' - change surrounding double quotes with single quotes
    -- dsq - delete closest surrounding quote
    -- dss - delete closest surrounding whatever
    -- :h nvim-surround
    "kylechui/nvim-surround",
    enabled = true,
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    -- A super powerful autopair plugin for Neovim that supports multiple characters
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    enabled = true,
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        enable_check_bracket_line = false,
      })
    end,
  },
  {
    -- nvim-ts-autotag: Use Treesitter to autoclose/rename HTML/JSX/Vue/TypeScript/etc. tags
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename paired tags
          enable_close_on_slash = false -- Auto close on </
        },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    enabled = true,
    config = function()
      require("Comment").setup()

      local ft = require("Comment.ft")

      -- https://github.com/numToStr/Comment.nvim#%EF%B8%8F-filetypes--languages
      ft.scss = "// %s"
    end,
  },
}
