return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  dependencies = { "SmiteshP/nvim-navic" },
  config = function()
    local navic = require("nvim-navic")
    local name_or_navic = function()
      if navic.is_available() then
      	return navic.get_location()
      else
	return 'filename'
      end
    end
    require("lualine").setup({
      sections = {
	lualine_a = { 'mode' },
	lualine_b = { name_or_navic },
	lualine_c = { { navic.get_location, cond = navic.is_available } },
	lualine_x = { },
	lualine_y = { 'diagnostics' },
	lualine_z = { 'location' }
      },
    })
  end
}
