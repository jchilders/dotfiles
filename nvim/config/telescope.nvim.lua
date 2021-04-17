-- https://github.com/nvim-telescope/telescope.nvim

require('telescope').setup{
  defaults = {
    borderchars = {
      { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    },
    file_ignore_patterns = { 'png', 'jpg' },
    layout_strategy = "center",
    preview_cutoff = 1, -- Preview should always show (unless previewer = false)
    results_height = 15,
    sorting_strategy = "ascending",
    results_title = false,
  }
}
