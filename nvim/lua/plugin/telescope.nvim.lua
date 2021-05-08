-- https://github.com/nvim-telescope/telescope.nvim

-- Telescope stuff I need to import for configuration
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ['<c-x>'] = false,
        ['<c-s>'] = actions.select_horizontal,
        ['<c-q>'] = actions.send_to_qflist,
      },
      i = {
        ['<c-x>'] = false,
        ['<c-s>'] = actions.select_horizontal,
        ['<c-q>'] = actions.send_to_qflist,
      },
    },
    -- borderchars = {
      -- { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      -- prompt = {'─', '│', ' ', '│', '╭', '╮', '│', '│'},
      -- results = {'─', '│', '─', '│', '├', '┤', '╯', '╰'},
      -- preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    -- },
    color_devicons = true,
    file_ignore_patterns = { 'png', 'jpg' },
    prompt_prefix = '🔍 ',
    prompt_position = 'bottom',
    preview_cutoff = 1, -- Preview should always show (unless previewer = false)
    results_height = 15,
    sorting_strategy = 'ascending',
    results_title = false,
    layout_defaults = {
      horizontal = {
        mirror = true,
      },
      vertical = {
        mirror = true,
      }
    },
    layout_strategy = 'flex',
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}
-- require fzf extension for fzf sorting algorithm
require('telescope').load_extension('fzf')
