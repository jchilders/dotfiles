-- https://github.com/nvim-telescope/telescope.nvim

-- Telescope stuff I need to import for configuration
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    color_devicons = true,
    file_ignore_patterns = { '%.png', '%.jpg', '%.svg', '%.ttf', '%.eot', '%.gif', '%.swf', '%.woff', '%.pdf' },
    layout_config = {
      preview_cutoff = 1, -- Preview should always show (unless previewer = false)
      prompt_position = 'bottom',
      height = 15,
      horizontal = {
        mirror = true,
      },
      vertical = {
        mirror = true,
      }
    },
    layout_strategy = 'flex',
    mappings = {
      n = {
        ['<c-x>'] = actions.select_horizontal,
        ['<c-q>'] = actions.send_to_qflist,
      },
      i = {
        ['<c-x>'] = actions.select_horizontal,
        ['<c-q>'] = actions.send_to_qflist,
      },
    },
    prompt_prefix = '🔍 ',
    results_title = false,
    sorting_strategy = 'ascending',
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}

-- require fzf extension for better fzf sorting algorithm
require('telescope').load_extension('fzf')
