local M = {}
M.__index = M

local jc_utils = require("jc.utils")

-- Things that should happen after packer is initialized, but for whatever
-- reason can't be put into packer's `config` attribute, should go here.
M.init = function()
  -- require("plugins.autopairs").init()
  jc_utils.prequire("plugins.lspconfig").init()
  jc_utils.prequire("nvim-gps").setup()

  -- the init is loaded over a autocmd for lazyload
  --[[ require("plugins.wildmenu") ]]

  -- load last to overwrite every highlight that has been added by a plugin
  require("core.highlights")
end

return M
