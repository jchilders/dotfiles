return {
	"numToStr/Comment.nvim",
	enabled = true,
	config = function()
		require("Comment").setup()

    local ft = require("Comment.ft")

    -- https://github.com/numToStr/Comment.nvim#%EF%B8%8F-filetypes--languages
    ft.scss = "// %s"
	end
}
-- vim: ts=2 sts=2 sw=2 et
