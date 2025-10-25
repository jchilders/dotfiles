local g, opt, go, wo, o = vim.g, vim.opt, vim.go, vim.wo, vim.o
local api = vim.api

opt.backup = false
opt.swapfile = false
opt.undofile = true -- save undo history

opt.autoindent = true
opt.breakindent = true -- break long lines
opt.smartindent = true

opt.autoread = true -- reload files on external change
opt.clipboard = "unnamedplus" -- clipboard yank
opt.cursorline = true -- highlight current line
opt.expandtab = true -- use spaces instead of tabs when indenting
opt.fileformat = "unix"
api.nvim_command('filetype plugin indent on')

-- Do not fix files (i.e. "add a newline") that do not have a newline as the final character
opt.fixendofline = false

opt.grepprg = "rg"

-- blinking block cursor
opt.guicursor="n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.laststatus = 2 -- 3: always and ONLY the last window
opt.number = true
opt.relativenumber = true
opt.scrolloff = 3
opt.showmode = false -- let status bar handle it
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.showtabline = 1 -- 0: Never, 1: Only if there are 2 or more, 2: Always
opt.shiftwidth = 2
opt.sidescroll = 5
opt.sidescrolloff = 15
opt.signcolumn = "yes"
opt.smartcase = true
opt.tabstop = 2
opt.termguicolors = true -- recommended by bufferlines plugin
opt.tildeop = false -- lets ~ command work with motions: `~w` will toggle case of curr word, e.g.
opt.timeoutlen = 500
opt.wildmenu = true
opt.wildmode = "longest,full"
opt.wildoptions = 'fuzzy,tagfile'
opt.wrap = true

-- completion menu settings
-- opt.completeopt = "menu,menuone,noselect" -- completion behaviour per cmp docs

-- Set so that folders are indexed for find command
opt.path = "**/*"
opt.wildignore:append({
  ".git/",
  "build",
  "coverage",
  "node_modules",
  "tmp",
  "vendor",
})

-- fold settings
-- wo.foldmethod = "expr"
-- o.foldtext =
-- [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
-- wo.foldexpr = "nvim_treesitter#foldexpr()"
wo.foldlevel= 99 -- open all folds
wo.foldnestmax = 3
wo.foldminlines = 1

-- opt.wrap = false                 -- Soft wrap long lines visually
opt.sidescroll = 5
opt.list = true                  -- Show markers for truncated lines
opt.listchars = "precedes:\\u226a,extends:\\u226b"

-- Configure Vim's automatic text formatting behavior
opt.formatoptions = {
  j = true,  -- Remove comment leader when joining lines
  c = true,  -- Auto-wrap comments using 'textwidth'
  r = true,  -- Continue comments when pressing <Enter>
  o = true,  -- Continue comments when using 'o' or 'O'
  q = true,  -- Allow formatting with 'gq'
  n = true,  -- Recognize numbered lists when formatting (useful for Markdown)
  t = true,  -- Auto-wrap text as you type
}

-- shada file is used to save vim state
-- :h shada for general info
-- :h E526 for shada options
opt.shada = {
  "!",     -- save global vars whose name is all uppercase
  "'1000", -- max num files for which marks are remembered
  "<50",   -- max num lines saved for each register
  "s10",   -- max size of item contents in KiB
  "h",     -- disable effect of hlsearch when loading shada file
}
