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

require("lazy").setup({
  spec = {
    {
      -- lazyflex lets you enable/disable plugins based on patterns
      "abeldekat/lazyflex.nvim",
      version = "*",
      cond = true, -- false to disable lazyflex
      import = "lazyflex.hook",
      opts = {
        -- Disable plugins matching "tele" and "harp" patterns
        -- enable_match = false,
        -- kw = { "tele", "harp" }
      },
    },
    { import = "plugins" }, -- dir to load plugin definitions from
  }
})

-- use pcall in case colorscheme hasn't been installed yet
pcall(vim.cmd, "colorscheme tokyonight")

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

-- vim: ts=2 sts=2 sw=2 et
