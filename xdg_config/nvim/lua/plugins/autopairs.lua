-- A super powerful autopair plugin for Neovim that supports multiple characters
-- https://github.com/windwp/nvim-autopairs

return {
  "windwp/nvim-autopairs",
  enabled = true,
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt" },
      enable_check_bracket_line = false,
    })
  end
}
