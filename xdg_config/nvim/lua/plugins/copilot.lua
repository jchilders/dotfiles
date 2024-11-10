-- lua implementation of copilot.vim. faster.
--
-- https://github.com/zbirenbaum/copilot.lua
return {
  "zbirenbaum/copilot.lua",
  enabled = true,
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    require('copilot').setup({
      suggestion = { enabled = true },
      panel = { enabled = true },
      -- suggestion = {
      --   enabled = true,
      --   auto_trigger = true,
      --   debounce = 75,
      --   keymap = {
      --     accept = "<S-Enter>",
      --     accept_word = false,
      --     accept_line = false,
      --     next = "<Tab>",
      --     prev = "<S-Tab>",
      --     dismiss = "<C-]>",
      --   },
      -- },
    })
    require('copilot_cmp').setup()
  end
}
