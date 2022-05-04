local M = {}
M.__index = M

function M.init()
  require("harpoon").setup({
    global_settings = {
      enter_on_sendcmd = true,
    },
    projects = {
      -- Yes $HOME works
      ["$HOME/workspace/dva/vets-api"] = {
        term = {
          cmds = {
            "bin/rails server",
            "foreman start",
          },
        },
      },
    },
  })
end

return M
