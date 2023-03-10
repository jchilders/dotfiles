-- :Notifications - show log of notification history
-- require('telescope').extensions.notify.notify() - same as above, w/ Telescope
-- require("notify")("My super important message")
return {
	"rcarriga/nvim-notify",
	enabled = true,
	config = function()
		require("notify").setup {
			background_colour = "#000000",
		}
		vim.notify = require("notify")
	end
}
