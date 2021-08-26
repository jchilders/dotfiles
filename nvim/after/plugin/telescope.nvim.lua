-- https://github.com/nvim-telescope/telescope.nvim

-- Telescope stuff I need to import for configuration
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    borderchars             = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
    color_devicons = true,
    file_ignore_patterns = { '%.png', '%.jpg', '%.ttf', '%.eot', '%.gif', '%.swf', '%.woff', '%.pdf' },
    layout_strategy = 'vertical',
    mappings = {
      n = {
        ["<c-d>"] = actions.delete_buffer,
        ['<c-q>'] = actions.send_to_qflist,
        ['<c-x>'] = actions.select_horizontal,
      },
      i = {
        ["<c-d>"] = actions.delete_buffer,
        ['<c-q>'] = actions.send_to_qflist,
        ['<c-x>'] = actions.select_horizontal,
      },
    },
    prompt_prefix = '🔍 ',
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
