-- harpoon lets you mark a small number of key files on a per-project basis,
-- and quickly nav to them
-- <leader>hl - list harpoons
-- <leader>ha - add harpoon
-- C-h/j/k/l - go to first/second/third/fourth harpoon
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon"):setup({
    })
  end
}
