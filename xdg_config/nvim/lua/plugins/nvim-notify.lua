-- :Notifications - show log of notification history
-- require('telescope').extensions.notify.notify() - same as above, w/ Telescope
return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup {
			background_colour = "#000000",
		}
	end
}
