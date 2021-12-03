local g, b, opt, go, wo, o = vim.g, vim.b, vim.opt, vim.go, vim.wo, vim.o
local M = {}

function M.load_options()
  g.mapleader = ","

  opt.backup = false
  opt.swapfile = false

  opt.autoindent = true
  opt.cursorline = true -- highlight current line
  opt.fileformat = 'unix'
  opt.grepprg = 'rg'
  opt.hidden = true
  opt.hlsearch = true
  opt.mouse = 'a' -- mouse enabled for all modes. needed for barbar
  opt.number = true
  opt.relativenumber = true
  opt.scrolloff = 5
  opt.sidescrolloff = 15
  opt.sidescroll = 5
  opt.signcolumn = 'yes'
  opt.smartcase = true
  g.tildeopt = true -- let ~ command work with motions: `~w` will change case of curr word, e.g.
  opt.wrap = true
  g.showtabline = 0

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

  opt.ignorecase = true

  opt.showmode = false -- modes
  opt.autoread = true -- reload files changed other edit

  opt.updatetime = 300 -- update interval for gitsigns
  opt.timeoutlen = 500
  opt.clipboard = "unnamedplus" -- clipboard yank
  opt.wildmenu = true
  opt.wildmode = "longest,full"

  -- fold settings
  wo.foldmethod = "expr"
  o.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  wo.foldexpr = "nvim_treesitter#foldexpr()"
  go.foldlevelstart = 99
  wo.foldnestmax = 3
  wo.foldminlines = 1

  vim.api.nvim_exec(
    [[
  command! GithubCI lua require('utils').ci()
  ]],
    false
  )
end

return M
