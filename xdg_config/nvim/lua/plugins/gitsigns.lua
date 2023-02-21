local gitsigns = require("gitsigns")

return {
  "lewis6991/gitsigns.nvim",
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
  keys = {
    { "<leader>ga", gitsigns.stage_hunk, desc = "Stage hunk" },
    { "<leader>gb", gitsigns.blame_line, desc = "git blame" },
    { "<leader>gp", gitsigns.prev_hunk, desc = "Go to previous unstaged hunk" },
    { "<leader>gn", gitsigns.next_hunk, desc = "Go to next unstaged hunk" },
    { "<leader>gr", gitsigns.reset_hunk, desc = "Undo changes to current hunk" },
    { "<leader>gd", gitsigns.preview_hunk, desc = "Preview hunk" },
    { "<leader>gq", function()
      gitsigns.setqflist("all")
    end, desc = "Set quickfix list to unstaged changes"},
  }
}
