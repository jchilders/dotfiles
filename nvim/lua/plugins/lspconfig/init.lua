local M = {}
M.__index = M

-- {{ lsp_installer }} --
-- :LspInstallInfo
-- :LspInstall <lsp server name>
-- :LspInstallLog
function M.init()
  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function(server)
    local opts = {}

    --[[ opts.handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable virtual_text. This helps with too many messages cluttering the UI. Show with
    -- vim.lsp.diagnostic.show_line_diagnostics()
    virtual_text = false
    }),
    } ]]

    if server.name == "solargraph" then
      opts.filetypes = { "ruby" }
    elseif server.name == "sumneko_lua" then
      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of
            -- Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            -- Get the language server to recognize certain globals
            globals = {
              "vim",
              "packer_plugins",
            },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
          },
        },
      }
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)

    vim.cmd([[ do User LspAttach Buffers ]])
  end)
end

return M
