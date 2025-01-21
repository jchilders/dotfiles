require "core/highlights" -- load before colorscheme cfg
require "plugins/colorscheme"
require "core/options"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup(
  { import = "plugins" },
  {
    install = {
      colorscheme = { "tokyonight" },
    },
    change_detection = {
      notify = false
    },
    checker = {
      enabled = true,
      notify = false,
    },
  })

pcall(vim.cmd.colorscheme, "tokyonight")

require "core/mappings"
require "core/autocmd"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- see lsp/ directory
vim.lsp.enable('lua-language-server')
-- vim.lsp.enable('solargraph')

-- vim: ts=2 sts=2 sw=2 et
