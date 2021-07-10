-- statusline
-- https://github.com/Famiu/feline.nvim

-- local lsp = require('feline.providers.lsp')
-- local vi_mode_utils = require('feline.providers.vi_mode')

local components = require('feline.presets').default.components
local properties = require('feline.presets').default.properties

-- rounded separators (extra-powerline-symbols)
components.left.active[3].left_sep = { ' ', "\u{E0B6}" }
components.left.active[3].right_sep = { "\u{E0B4}", ' ' }

require('feline').setup({
  components = components,
  properties = properties,
})
