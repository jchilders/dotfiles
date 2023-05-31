return {
  "folke/tokyonight.nvim",
  enabled = true,
  config = function()
    vim.o.background = "dark"
    require("tokyonight").setup({
      style = "night",
      styles = {
        sidebars = "transparent", -- style for sidebars, see below
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    })
  end
}
