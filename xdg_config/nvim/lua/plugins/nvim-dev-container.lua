-- https://codeberg.org/esensar/nvim-dev-container
--
-- DevcontainerLogs
-- DevcontainerEditNearestConfig
-- DevcontainerStart
-- DevcontainerAttach
-- DevcontainerExec

return {
  'https://codeberg.org/esensar/nvim-dev-container',
  enabled = false,
  config = function()
    require("devcontainer").setup({})
  end
}
