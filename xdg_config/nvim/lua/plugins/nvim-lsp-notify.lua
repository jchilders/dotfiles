-- LSP server notifications using nvim-notify
return {
	"mrded/nvim-lsp-notify",
	config = function()
		require('lsp-notify').setup({
			notify = require('notify')
		})
	end
}
