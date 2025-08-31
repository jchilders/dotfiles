-- nvim-ts-autotag Use Treesitter to autoclose/rename HTML/JSX/Vue/TypeScript/etc. tags

return {
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
}
