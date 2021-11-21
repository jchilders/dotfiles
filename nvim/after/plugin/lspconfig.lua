-- All LSP-related config items live here, except for mappings

-- {{ lspkind: pictographs for lsp selectors }} --
require('lspkind').init({})

-- {{ lsp_installer }} --
-- :LspInstallInfo
-- :LspInstall <lsp server name>
-- :LspInstallLog
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = function(_server, _)
            print("LSP: Attached to " .. _server.name)
        end
        -- TODO: Turn off rubocop messages
    }
    opts.handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable virtual_text. This helps with too many messages cluttering the UI. Show with
            -- vim.lsp.diagnostic.show_line_diagnostics()
            virtual_text = false
        }),
    }

    if server.name == "solargraph" then
        opts.filetypes = { "ruby" }
    elseif server.name == "sumneko_lua" then
        opts.settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of
                    -- Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
                }
            }
        }
        -- opts.root_dir = function() ... end
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)

    vim.cmd([[ do User LspAttach Buffers ]])
end)
