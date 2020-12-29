local completion = require('completion')

local on_attach = function(client, bufnr)
	completion.on_attach(client, bufnr)
end

require'lspconfig'.solargraph.setup{
	on_attach = on_attach,
}
