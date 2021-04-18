-- https://github.com/Famiu/feline.nvim

-- local lsp = require('feline.providers.lsp')
-- local vi_mode_utils = require('feline.providers.vi_mode')

local components = require('feline.presets').default.components
local properties = require('feline.presets').default.properties

components.left.active[2] = {
    provider = 'vi_mode',
    hl = function()
        local val = {}

        val.name = require('feline.providers.vi_mode').get_mode_highlight_name()
        val.fg = require('feline.providers.vi_mode').get_mode_color()
        val.style = 'bold'

        return val
    end,
    right_sep = ' ',
    -- Uncomment the next line to disable icons for this component and use the mode name instead
    icon = ''
}

require('feline').setup({
  components = components,
  properties = properties,
})
