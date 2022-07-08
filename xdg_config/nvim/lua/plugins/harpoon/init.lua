local M = {}
M.__index = M

function M.init()
  require("harpoon").setup({
    global_settings = {
      enter_on_sendcmd = true,
    },
    projects = {
      -- Yes $HOME works
      --[[ ["$HOME/work/carerev/api_app"] = {
        term = {
          cmds = {
            "rails console"
          },
        },
      }, ]]
    },
  })
end

return M
