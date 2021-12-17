local M = {}
M.__index = M

-- Things that should happen after packer is initialized, but for whatever
-- reason can't be put into packer's `config` attribute, should go here.
M.init = function()
  require("plugins.autopairs").init()
  require("plugins.lspconfig").init()
  require("nvim-gps").setup()
  -- require("plugins.build"):init()

  --  require("plugins.web-devicons").init()
  --  require("plugins.treesitter").init()
  --  require("plugins.bufferline").init()

  -- the init is loaded over a autocmd for lazyload
  --[[ require("plugins.wildmenu") ]]

  -- load last to overwrite every highlight that has been added by a plugin
  require("core.highlights")
end

return M
