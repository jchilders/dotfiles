local M = {}

local utils = require("utils")

local function augroups()
  local definitions = {
    ft = {
      { "FileType", "NvimTree,lspsagafinder,dashboard", "let b:cusorword=0" },
      {
        "WinEnter,BufRead,BufEnter",
        "dashboard",
        "Dashboard",
      }, -- disable tabline in dashboard
      { "BufNewFile,BufRead", "*.toml", "setf toml" }, -- set toml filetype
      {
        "FileType",
        "*.toml",
        "lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }",
      },
      {
        "FileType",
        "*.org",
        "lua require('cmp').setup.buffer { sources = { { name = 'orgmode' } } }",
      },
    },
    Terminal = {
      { "TermOpen", "*", "set nonumber" },
      { "TermOpen", "*", "set norelativenumber" },
      { "TermOpen", "*", "set showtabline=0" }, -- renable it
      { "WinEnter,BufEnter", "terminal", "set nonumber" },
      { "WinEnter,BufEnter", "terminal", "set norelativenumber" },
      { "WinEnter,BufEnter", "terminal", "set showtabline=0" }, -- renable it
    },
    lsp = {
      {
        "DirChanged",
        "*",
        'silent! lua require("plugins.lspconfig.lua").reinit()',
      },
    },
  }

  utils.nvim_create_augroups(definitions)
end

local function autocmds()
  -- Restore cursor position (`g'"`) to where it was when a file was last edited
  utils.autocmd(
    "BufReadPost",
    "*",
    [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
  )
end

function M.init()
  augroups()
  autocmds()
end

return M
