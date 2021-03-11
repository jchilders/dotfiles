
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
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}
