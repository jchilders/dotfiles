-- https://github.com/rmagatti/auto-session
return {
  "rmagatti/auto-session",
  enabled = true,
  lazy = false,
  config = function()
    require("auto-session").setup {
      log_level = "warn",
      auto_save_enabled = true,
      auto_session_enabled = true,
      -- auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_use_git_branch = true,
      -- Session lens lets you pick a session using Telescope. I don't use it, so disable it.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = false,
      }
    }
  end
}
