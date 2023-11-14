-- Shows a tree-like outline of symbols for the current file
-- https://github.com/hedyhli/outline.nvim
return {
  "hedyhli/outline.nvim",
  enabled = true,
  config = function()
    -- vim.keymap.set("n", "<leader>tt", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
    vim.keymap.set("n",
      "<leader>ot", -- outline toggle
      function ()
        local outline = require("outline")
        outline.toggle_outline()
      end,
      { desc = "Toggle Outline" }
    )

    require("outline").setup({
      outline_window = {
        show_cursorline = true,
        hide_cursor = false,
      },
    })
  end,
}
