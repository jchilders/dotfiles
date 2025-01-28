-- Standard locations:
--
-- Log files: XDG_CACHE_HOME ~/.cache
-- Plugins: XDG_DATA_HOME ~/.local/share/nvim
require "core/highlights" -- load before colorscheme cfg
require "plugins/colorscheme"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.runtimepath:prepend(lazypath)

require "core/options"

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

-- vim: ts=2 sts=2 sw=2 et
