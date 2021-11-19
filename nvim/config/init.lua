-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- Supposedly improves startup time. Since we don't need the provider anyway,
-- can't hurt.
vim.g.loaded_ruby_provider = 0

require "jc.globals"

local opt = vim.opt

opt.expandtab = true
opt.softtabstop = 2
opt.shiftwidth = 2
opt.tabstop = 4
opt.smarttab = true

opt.backup = false
opt.swapfile = false
-- commenting this out until I can fix this: ~ is creating a directory literally named "~"
--[[ opt.undodir = '~/.local/share/nvim/backups'
opt.undofile = false ]]

opt.autoindent = true
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
