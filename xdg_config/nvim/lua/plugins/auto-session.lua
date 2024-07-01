return {
  "rmagatti/auto-session",
  enabled = true,
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
      auto_session_use_git_branch = true,
      auto_save_enabled = true,
    }
  end
}
