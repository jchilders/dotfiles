-- nvim-luadev - Lua Development for Neovim
-- :Luadev
-- https://github.com/bfredl/nvim-luadev
return {
  "bfredl/nvim-luadev",
  enabled = true,
  ft = "lua",
  keys = {
    { "<leader>rl", "<Plug>(Luadev-RunLine)<cr>", mode = "n", desc = "Run in luadev repl" },
    { "<leader>rl", "<Plug>(Luadev-Run)<cr>", mode = "v", desc = "Run visual selection in luadev repl" },
  }
}
