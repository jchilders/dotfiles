-- make this available for later configs to use
require "jc.globals"

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

local opt = vim.opt

opt.expandtab = true
opt.softtabstop = 2
opt.shiftwidth = 2
opt.tabstop = 4
opt.smarttab = true

opt.backup = false
opt.swapfile = false

opt.autoindent = true
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.fileformat = 'unix'
opt.grepprg = 'rg --vimgrep --no-heading --hidden'
opt.hidden = true
opt.hlsearch = true
opt.inccommand = 'split'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 5
opt.sidescrolloff = 15
opt.sidescroll = 5
opt.signcolumn = 'yes'
opt.smartcase = true
opt.wrap = true
