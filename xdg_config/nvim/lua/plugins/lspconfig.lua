-- Automatically configures LSPs installed with Mason
--
-- :LspInfo - Shows which servers buffer is attached to

return {
  "neovim/nvim-lspconfig",
  enabled = true,
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local severity = vim.diagnostic.severity

    local severity_icons = {
      [severity.ERROR] = "",
      [severity.WARN] = "",
      [severity.INFO] = "",
      [severity.HINT] = "",
    }

    local severity_highlights = {
      [severity.ERROR] = "DiagnosticFloatingError",
      [severity.WARN] = "DiagnosticFloatingWarn",
      [severity.INFO] = "DiagnosticFloatingInfo",
      [severity.HINT] = "DiagnosticFloatingHint",
    }

    vim.diagnostic.config({
      float = {
        border = "rounded",
        focusable = false,
        source = "if_many",
        severity_sort = true,
        prefix = function(diagnostic)
          local icon = severity_icons[diagnostic.severity] or "•"
          local hl = severity_highlights[diagnostic.severity] or "DiagnosticFloatingInfo"
          return icon, hl
        end,
        format = function(diagnostic)
          return " " .. diagnostic.message
        end,
      },
    })

    -- Configure and enable each installed LSP server.
    mason_lspconfig.setup({
      automatic_enable = false,
      ensure_installed = { "ltex" },  -- Ensure ltex is available
    })

    for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
      local opts = {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }

      if server_name == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        }
      end
      if server_name == "pyright" then
        opts.settings = {
          python = {
            analysis = {
              venvPath = ".",
              venv = ".venv",
            },
          },
        }
      end

      vim.lsp.config(server_name, opts)
      vim.lsp.enable(server_name)
    end

    -- Specific configuration for ltex-ls for gitcommit and markdown files
    local ltex_opts = {
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      filetypes = { "gitcommit", "markdown" },
      settings = {
        ltex = {
          language = "en-US",
          diagnosticSeverity = "information",  -- Show as info rather than error
          inheritDict = true,
          dictionary = {},
          disabledRules = {
            ["en-US"] = {
              "WHITESPACE_RULE",           -- Disable whitespace warnings
              "COMMA_PARENTHESIS_WHITESPACE", -- Common in code comments
              "EN_QUOTES",                 -- Often triggered in code contexts
              "MORFOLOGIK_RULE_EN_US",     -- Main spelling rule (more forgiving)
            },
          },
          hiddenFalsePositives = {},
          sentenceCacheSize = 2000,
          additionalRules = {
            motherTongue = "en-US",
          },
        },
      },
    }

    -- Setup ltex-ls specifically for the desired file types using the new API
    vim.lsp.config("ltex", ltex_opts)
    vim.lsp.enable("ltex")

    -- Global LSP keymaps
    vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float() end, { desc = "Open diagnostic float" })
    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, { desc = "Set loc list from diagnostics" })

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>sig', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })

    require("jc.lsp_auto").setup()
  end,
}
