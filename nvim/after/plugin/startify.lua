-- startify is invoked when vim is started with no arguments

-- print current directory as a banner in the startify header
local cwd = vim.fn.split(vim.fn.getcwd(), '/')
local width = vim.fn['winwidth']('%')
local banner = vim.fn.system("toilet --font cosmic -W --width "..width.." "..cwd[#cwd])
local header = vim.fn['startify#pad'](vim.fn.split(banner, '\n'))
vim.g.startify_custom_header = header

-- we only care about the MRU list for the current directory
vim.g.startify_lists = {
  { type = 'dir', header = { "Recently edited files in "..vim.fn.getcwd()..":" } }
}
