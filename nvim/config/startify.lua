-- startify is invoked when vim is started with no arguments

vim.g.startify_fortune_use_unicode = 1

-- print current directory as a banner in the startify header
local cwd = vim.fn.split(vim.fn.getcwd(), '/')
local banner = vim.fn.system("toilet --font cosmic "..cwd[#cwd])
local header = vim.fn['startify#pad'](vim.fn.split(banner, '\n'))
vim.g.startify_custom_header = header

-- we only care about the MRU list for the current directory
vim.g.startify_lists = {
  { type = 'dir', header = { "Recently edited files in "..vim.fn.getcwd()..":" } }
}
