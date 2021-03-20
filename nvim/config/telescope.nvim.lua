-- https://github.com/nvim-telescope/telescope.nvim

require('telescope').setup{
  defaults = {
    color_devicons = true,
    file_ignore_patterns = { 'png', 'jpg' },
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    layout_strategy = 'flex',
    prompt_prefix = "> ",
    scroll_strategy = 'cycle',
    winblend = 0
  }
}
