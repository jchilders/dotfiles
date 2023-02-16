return {
  "SmiteshP/nvim-navic",
  enabled = true,
  config = function()
    require("nvim-navic").setup({
			depth_limit = 0,
		})
	end
}

