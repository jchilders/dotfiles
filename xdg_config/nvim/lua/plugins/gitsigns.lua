return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup {
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

      vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Stage change" })
      vim.keymap.set("n", "<leader>gA", gitsigns.stage_buffer, { desc = "Stage all changes made to current buffer" })
      vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame" })
      vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Go to previous unstaged hunk" })
      vim.keymap.set("n", "<leader>gP", gitsigns.preview_hunk, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Go to next unstaged hunk" })
      vim.keymap.set("n", "<leader>gu", gitsigns.reset_hunk, { desc = "Undo changes to current hunk" })
      vim.keymap.set("n", "<leader>gU", gitsigns.reset_buffer, { desc = "Undo all changes made to current buffer" })
      vim.keymap.set("n", "<leader>gq", function()
        gitsigns.setqflist("all")
      end, { desc = "Set quickfix list to unstaged changes" })
    end,
  },
  {
    "tpope/vim-rhubarb",
    enabled = true,
  },
}
