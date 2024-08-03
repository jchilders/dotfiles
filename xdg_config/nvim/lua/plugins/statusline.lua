return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  dependencies = { "SmiteshP/nvim-navic" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
      },
      sections = {
        lualine_a = { 'location' },
        lualine_b = { { 'filename', path = 1, shorting_target = 120 } },
        -- lualine_c = { },
        -- TODO get navic to only show class & method
        -- https://github.com/SmiteshP/nvim-navic
        lualine_c = { 'navic' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'diagnostics' },
        lualine_z = { { 'mode', fmt = function(str) return str:sub(1,1) end }, },
      },
      inactive_sections = {
        lualine_a = { 'location' },
        lualine_b = { { 'filename', path = 1, shorting_target = 120 } },
        lualine_c = { },
        lualine_x = { },
        lualine_y = { 'diagnostics' },
        lualine_z = { }
      },
    })
  end
}
