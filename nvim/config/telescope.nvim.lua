require('telescope').setup{
  defaults = {
    color_devicons = true,
    file_ignore_patterns = { 'png', 'jpg' },
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    layout_strategy = 'flex',
    scroll_strategy = 'cycle',
    prompt_prefix = "> ",
    winblend = 0
  }
}
