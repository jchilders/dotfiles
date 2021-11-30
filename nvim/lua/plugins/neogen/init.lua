local remap = require("utils").map_global

local M = {}

M.init = function()
  require("neogen").setup({
    enabled = true,
  })

  vim.cmd([[silent! command DocGen lua require('neogen').generate()]])
  remap(
    "n",
    "<Leader>fc",
    ":lua require('neogen').generate({ type = 'func' })<CR>"
  )
  remap(
    "n",
    "<Leader>cc",
    ":lua require('neogen').generate({ type = 'class' })<CR>"
  )
  remap(
    "n",
    "<Leader>tc",
    ":lua require('neogen').generate({ type = 'type' })<CR>"
  )
end

return M
