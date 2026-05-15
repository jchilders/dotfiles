return {
  {
    -- Snacks.notifier.show_history() - show notification history
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      notifier = {
        enabled = true,
        timeout = 5000,
        width = { min = 40, max = 0.45 },
        style = "compact",
        top_down = false,
      },
      styles = {
        notification = { wo = { wrap = true, linebreak = true } },
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    enabled = true,
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    main = "ibl",
    opts = {
      indent = { char = "┊" },
    },
  },
}
