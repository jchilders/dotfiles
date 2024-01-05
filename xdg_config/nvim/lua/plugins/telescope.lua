return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  dependencies = { "nvim-lua/plenary.nvim", "junegunn/fzf", "edluffy/hologram.nvim" },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          height = 0.5,
          width = 0.8
        },
        border = true,
        sorting_strategy = "ascending",
      }
    })
  end
}
