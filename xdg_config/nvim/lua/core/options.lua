local g, opt, go, wo, o = vim.g, vim.opt, vim.go, vim.wo, vim.o

-- pcall(vim.cmd, "colorscheme tokyonight")

g.mapleader = " "
g.maplocalleader = " "

opt.backup = false
opt.swapfile = false
opt.undofile = true -- save undo history

opt.autoindent = true
opt.breakindent = true -- break long lines
opt.smartindent = true

opt.autoread = true -- reload files on external change
opt.clipboard = "unnamedplus" -- clipboard yank
opt.cmdheight = 1
opt.cursorline = true -- highlight current line
opt.expandtab = true -- use spaces instead of tabs when indenting
opt.fileformat = "unix"

-- Do not fix files (i.e. "add a newline") that do not have a newline as the
-- final character
opt.fixendofline = false

opt.grepprg = "rg"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.laststatus = 2 -- 3: always and ONLY the last window
opt.number = true
opt.relativenumber = true
opt.scrolloff = 3
opt.showmode = false -- let status bar handle it
-- sessionoptions for mksession command
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
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
opt.wrap = true

-- completion menu settings
opt.completeopt = "menu,menuone,noselect" -- completion behaviour per cmp docs

-- whitespace settings
opt.list = false
opt.listchars:append("eol:↴")

-- Set so that folders are indexed for find command
opt.path = "**/*"
opt.wildignore:append({
  "node_modules",
  ".git/",
  "vendor",
  "coverage",
  "build",
  "tmp",
  "vendor",
})

-- fold settings
wo.foldmethod = "expr"
o.foldtext =
[[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
wo.foldexpr = "nvim_treesitter#foldexpr()"
wo.foldlevel= 99 -- open all folds
wo.foldnestmax = 3
wo.foldminlines = 1

-- teej
opt.formatoptions = opt.formatoptions
- "a" -- Auto formatting is BAD.
- "t" -- Don't auto format my code. I got linters for that.
+ "c" -- In general, I like it when comments respect textwidth
+ "q" -- Allow formatting comments w/ gq
- "o" -- O and o, don't continue comments (doesn't work?)
+ "r" -- But do continue when pressing enter.
+ "n" -- Indent past the formatlistpat, not underneath it.
+ "j" -- Auto-remove comments if possible.
- "2" -- I'm not in gradeschool anymore

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

