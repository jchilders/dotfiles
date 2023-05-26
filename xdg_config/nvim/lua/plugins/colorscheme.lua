return {
  "folke/tokyonight.nvim",
  enabled = true,
  config = function()
    vim.o.background = "dark" -- or light if you so prefer
    vim.g.tokyonight_style = "night"
  end
}
