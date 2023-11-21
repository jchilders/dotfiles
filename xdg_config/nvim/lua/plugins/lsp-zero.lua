-- LSP logs are usually in ~.local/state/nvim/lsp.log
-- :lua =vim.lsp.get_log_path()
return {
  "VonHeikemen/lsp-zero.nvim",
  enabled = true,
  dependencies = {
    -- LSP Support
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("mason.settings").set({
      ui = { border = "rounded" }
    })
    require("mason").setup()

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
        "ruby_ls",
        "rust_analyzer",
        "sqlls",
        "tailwindcss",
        "taplo",
        "tsserver",
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


    local lsp_zero = require("lsp-zero")
    lsp_zero.preset("recommended")
    lsp_zero.setup_nvim_cmp({
      sources = {
	{ name = "path" },
	{ name = "nvim_lsp", keyword_length = 3 },
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
	}
      },
    })

    lsp_zero.setup() -- this needs to be last
  end
}
