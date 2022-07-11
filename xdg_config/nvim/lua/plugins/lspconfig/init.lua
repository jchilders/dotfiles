local M = {}
M.__index = M

local lspconfig = require('lspconfig')
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

  local servers = lsp_installer.get_installed_servers()
  for _, server in ipairs(servers) do
    local attach_noty = function(_, bufnr)
      print("Buffer " .. bufnr .. " attached to " .. server.name)
    end

    if server.name == 'sumneko_lua' then
      lspconfig.sumneko_lua.setup({
        on_attach = attach_noty,
        settings = {
          Lua = {
            diagnostics = {
              -- Silence the `undefined global 'vim'` warning sumneko gives
              globals = { 'vim' }
            }
          }
        }
      })
    else
      lspconfig[server.name].setup({
        on_attach = attach_noty,
      })
    end
  end
end

return M
