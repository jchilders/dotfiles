-- https://github.com/VonHeikemen/lsp-zero.nvim
-- LSP logs are usually in ~.local/state/nvim/lsp.log
-- :lua =vim.lsp.get_log_path()
return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  enabled = true,
  dependencies = {
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    lsp_zero.on_attach(function(_, bufnr)
      -- see :help lsp-zero-keybindings
      -- to learn the available actions
      lsp_zero.default_keymaps({buffer = bufnr})
    end)

    require("mason.settings").set({
      ui = { border = "rounded" }
    })
    require("mason").setup({})

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = {
        "bashls",
        "dockerls",
        "grammarly",
        "jsonls",
        "lemminx",
        "ltex",
        "lua_ls",
        "rubocop",
        "rust_analyzer",
        "solargraph",
        "sqlls",
        "tailwindcss",
        "taplo",
        "tsserver",
      },
      handlers = {
        lsp_zero.default_setup,
      },
      automatic_installation = true,
    })

    local handlers = {
      lua_ls = {
        Lua = {
          diagnostics = { globals = {"vim"} },
          telemetry = { enable = false },
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME }
          },
        },
      },
    }
    mason_lspconfig.setup_handlers({
      function(server_name)
        local normal_capabilities = vim.lsp.protocol.make_client_capabilities()
        local def_capabilities = require("cmp_nvim_lsp").default_capabilities(normal_capabilities)

        require("lspconfig")[server_name].setup {
          capabilities = def_capabilities,
          settings = handlers[server_name]
        }
      end,
    })

    lsp_zero.preset("recommended")

    local cmp = require("cmp")
    local cmp_action = require('lsp-zero').cmp_action()
    cmp.setup({
      sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 3 },
        {
          name = "buffer",
          sorting = {
            -- distance-based sorting
            comparators = {
              function(...)
                local cmp_buffer = require("cmp_buffer")
                return cmp_buffer:compare_locality(...)
              end,
            }
          },
          option = {
            -- get completion suggestions from all buffers, not just current one
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          }
        },
        { name = 'copilot' },
      },
      mapping = cmp.mapping.preset.insert({
        -- Ctrl+Space to trigger completion menu
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
      }),
    })

    lsp_zero.setup() -- this needs to be last
  end
}
