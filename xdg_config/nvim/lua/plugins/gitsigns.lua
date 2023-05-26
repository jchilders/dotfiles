return {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  config = function()
    require("gitsigns").setup {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "¤" },
      },
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- "eol" | "overlay" | "right_align"
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>::<author_time:%Y-%m-%d> - <summary>",
    }
  end,
}
