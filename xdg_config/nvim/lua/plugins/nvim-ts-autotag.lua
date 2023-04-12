-- Use treesitter to autoclose and autorename HTML tags
return {
	"windwp/nvim-ts-autotag",
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-ts-autotag").setup()
	end
}
