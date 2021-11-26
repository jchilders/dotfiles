local cmd = vim.cmd
local g, b, opt, go, wo, o = vim.g, vim.b, vim.opt, vim.go, vim.wo, vim.o
local M = {}

function M.load_options()
  opt.expandtab = true
  opt.softtabstop = 2
  opt.shiftwidth = 2
  opt.tabstop = 4
  opt.smarttab = true

  opt.backup = false
  opt.swapfile = false

  opt.autoindent = true
  opt.fileformat = 'unix'
  opt.grepprg = 'rg'
  opt.hidden = true
  opt.hlsearch = true
  opt.number = true
  opt.relativenumber = true
  opt.scrolloff = 5
  opt.sidescrolloff = 15
  opt.sidescroll = 5
  opt.signcolumn = 'yes'
  opt.smartcase = true
  opt.wrap = true

  -- completion menu settings
  opt.completeopt = "menu,menuone,noselect,noinsert" -- completion behaviour
  opt.omnifunc = "v:lua.vim.lsp.omnifunc" -- completion omnifunc

  -- whitespace settings
  opt.list = false
  opt.listchars:append("eol:↴")

  -- Set so that folders are index for find command
  opt.path = "**/*"
  opt.wildignore:append({
    "node_modules",
    ".git/",
    "vendor",
    "coverage",
    "build",
  })

  g.mapleader = "," -- comma leader

  -- Tag Jump
  b.match_words = table.concat({
    "(:),\\[:\\],{:},<:>,",
    "<\\@<=\\([^/][^ \t>]*\\)[^>]*\\%(>\\|$\\):<\\@<=/\1>",
  })
  opt.matchpairs:append("<:>")

  opt.ignorecase = true -- case sens ignore search
  opt.termguicolors = true -- colors tmux settings
  go.t_Co = "256" -- colors tmux setting
  go.t_ut = "" -- colors tmux setting

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
  wo.fillchars = "fold:\\"
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
