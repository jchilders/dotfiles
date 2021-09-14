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
opt.number = false
opt.relativenumber = true
opt.scrolloff = 5
opt.signcolumn = 'yes'
opt.smartcase = true
opt.wrap = true

opt.scrolloff = 8
opt.sidescrolloff = 15
opt.sidescroll = 5
