
local actions = require("telescope.actions")

require('telescope').setup{
  defaults = {
	color_devicons = true,
	vimgrep_arguments = {
	  'rg',
	  '--color=always',
	  '--no-heading',
	  '--with-filename',
	  '--line-number',
	  '--column',
	  '--smart-case'
	},
	results_height = 0.30,
	prompt_position = "top",
	prompt_prefix = ">",
	sorting_strategy = "ascending",
	mappings = {
	  i = {
		["<esc>"] = actions.close
	  },
	},
  }
}
