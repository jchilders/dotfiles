-- Automated session management
return {
  "folke/persistence.nvim",
  config = true,
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- options = { "buffers", "curdir", "tabpages", "winpos", "winsize" }, -- sessionoptions used for saving
    options = { "options" }, -- sessionoptions used for saving
  },
  keys = {
    { "<leader>ql", "<cmd>lua require('persistence').load()<cr>", desc = "Load NeoVim session" },
    { "<leader>qs", "<cmd>lua require('persistence').save()<cr>", desc = "Save NeoVim session" },
  },
}
