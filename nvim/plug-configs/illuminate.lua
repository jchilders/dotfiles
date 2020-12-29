-- Highlights all occurences of word under cursor
-- https://github.com/RRethy/vim-illuminate

require'lspconfig'.solargraph.setup {
	on_attach = function(client)
		require 'illuminate'.on_attach(client)
	end,
}

-- highlight word instead of underlining it
-- vim.cmd('hi link illuminatedWord Visual')

-- `:set ft?` to get current filetype to add to this
vim.cmd('let g:Illuminate_ftblacklist = ["help"]')
