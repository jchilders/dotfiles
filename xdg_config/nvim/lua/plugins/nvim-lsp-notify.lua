-- LSP server notifications using nvim-notify
return {
	"mrded/nvim-lsp-notify",
	enabled = true,
	dependencies = {
		"rcarriga/nvim-notify",
	},
	config = function()
		require('lsp-notify').setup({
			notify = require('notify')
		})
	end
}
