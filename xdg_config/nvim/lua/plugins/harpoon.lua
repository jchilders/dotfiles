return {
  {
    -- harpoon lets you mark a small number of key files on a per-project basis,
    -- and quickly nav to them
    -- <leader>hl - list harpoons
    -- <leader>ha - add harpoon
    -- C-h/j/k/l - go to first/second/third/fourth harpoon
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
      -- open list of files marked as harpooned
      vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      -- ctrl-h opens the first harpooned file, ctrl-j opens the second harpooned file...
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "<C-;>", function() harpoon:list():select(5) end)
    end,
  },
  {
    -- :Bd to really delete a buffer
    "famiu/bufdelete.nvim",
    enabled = true,
  },
}
