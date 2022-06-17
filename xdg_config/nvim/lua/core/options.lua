local g, b, opt, go, wo, o = vim.g, vim.b, vim.opt, vim.go, vim.wo, vim.o
local M = {}

-- vim.g.tildeop
function M.load_options()
  g.mapleader = ","

  opt.backup = false
  opt.swapfile = false

  -- Do not fix files (i.e. "add a newline") that do not have a newline as the final character
  opt.fixendofline = false

  --[[ set path=.,src,node_nodules
  set suffixesadd=.js,.jsx ]]

  opt.autoindent = true
  opt.autoread = true -- reload files on external change
  opt.clipboard = "unnamedplus" -- clipboard yank
  opt.cursorline = true -- highlight current line
  opt.expandtab = true -- insert spaces instead of tabs when indenting
  opt.fileformat = "unix"
  opt.grepprg = "rg"
  opt.hidden = true
  opt.hlsearch = true
  opt.ignorecase = true
  opt.number = true
  opt.relativenumber = true
  opt.scrolloff = 3
  opt.showmode = false -- let status bar handle it
  opt.showtabline = 0 -- I don't use tablines, so...
  opt.sidescroll = 5
  opt.sidescrolloff = 15
  opt.signcolumn = "yes"
  opt.smartcase = true
  opt.tildeop = true -- let ~ command work with motions: `~w` will toggle case of curr word, e.g.
  opt.timeoutlen = 500
  opt.wildmenu = true
  opt.wildmode = "longest,full"
  opt.wrap = true

  -- completion menu settings
  opt.completeopt = "menu,menuone,noselect,noinsert" -- completion behaviour
  opt.omnifunc = "v:lua.vim.lsp.omnifunc" -- completion omnifunc

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
  })

  -- Tag Jump
  b.match_words = table.concat({
    "(:),\\[:\\],{:},<:>,",
    "<\\@<=\\([^/][^ \t>]*\\)[^>]*\\%(>\\|$\\):<\\@<=/\1>",
  })
  opt.matchpairs:append("<:>")

  -- fold settings
  wo.foldmethod = "expr"
  o.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  wo.foldexpr = "nvim_treesitter#foldexpr()"
  go.foldlevelstart = 99
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
end

return M
