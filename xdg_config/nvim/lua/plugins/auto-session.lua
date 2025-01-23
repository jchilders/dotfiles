-- https://github.com/rmagatti/auto-session
-- :AutoSession
return {
  "rmagatti/auto-session",
  enabled = true,
  lazy = false,
  config = function()
    vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    require("auto-session").setup({
      use_git_branch = true,            -- Include git branch name in session name
      show_auto_restore_notif = true,   -- Whether to show a notification when auto-restoring
      session_lens = {
        load_on_setup = true,           -- Initialize on startup (requires Telescope)
      }
    })
  end
}
