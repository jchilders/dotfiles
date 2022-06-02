local M = {}
M.__index = M

local jcu = require("jc.utils")
local lsp_config = require('lspconfig')
local lsp_installer = require("nvim-lsp-installer")

-- {{ lsp_installer }} --
-- :LspInstallInfo
-- :LspInstall <lsp server name>
-- :LspInstallLog
-- :LspInfo
function M.init()
  lsp_installer.setup({
    automatic_installation = true,
  })

  local lsp_servers = lsp_installer.get_installed_servers()
  for _, lsp in ipairs(lsp_servers) do
    lsp_config[lsp.name].setup({
      on_attach = function(client, bufnr)
        print("Attached to "..jcu.lsp_name())
      end,
    })
  end
end

return M
