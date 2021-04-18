-- pictographs for lsp selectors
require('lspkind').init({})

local nvim_lsp = require('lspconfig')

nvim_lsp.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  flags = { debounce_text_changes = 150, },
  on_attach = function(_, _)
    require'completion'.on_attach()
    print 'Attached to Solargraph LSP'
  end,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Disable virtual_text on file load
      -- Show with vim.lsp.diagnostic.show_line_diagnostics()
      virtual_text = false
    }
    ),
  }
}

USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_main_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
  sumneko_root_path = "/Users/" .. USER .. "/.local/share/nvim/lspinstall/lua"
  sumneko_main_path = sumneko_root_path .. "/sumneko-lua/extension/server"
  sumneko_binary = sumneko_root_path .. "/sumneko-lua-language-server"
elseif vim.fn.has("unix") == 1 then
  sumneko_root_path = "/home/" .. USER .. "/.local/share/nvim/lspinstall/lua/lua-language-server"
  sumneko_binary = "/home/" .. USER .. "/.local/share/nvim/lspinstall/lua/lua-language-server/bin/Linux/lua-language-server"
else
  print("Unsupported system for sumneko")
end

nvim_lsp.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_main_path .. "/main.lua"},
  on_attach = function(_, _)
    print 'Attached to Sumneko'
  end,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
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
}
