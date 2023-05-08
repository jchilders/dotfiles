return {
  "SmiteshP/nvim-navic",
  enabled = true,
  config = function()
    require("nvim-navic").setup({
      depth_limit = 2,
      highlight = true,
    })
  end
}

