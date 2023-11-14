return {
  "VonHeikemen/lsp-zero.nvim",
  enabled = true,
  dependencies = {
    "folke/neodev.nvim",
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
    -- neodev fixes the 'undefined global "vim"' message, as well as doing other cool things
    require("neodev").setup() -- needs to happen before LSP init

    local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    if not (cmp_nvim_lsp_status_ok) then
      print("cmp_nvim_lsp not installed")
      return
    end

    require("mason.settings").set({
      ui = { border = "rounded" }
    })
    require("mason").setup()

    -- LSP logs are usually in ~.local/state/nvim/lsp.log
    -- :lua =vim.lsp.get_log_path()
    local mason_lspconfig = require "mason-lspconfig"
    local servers = {
      lua_ls = {
	Lua = {
	  diagnostics = { globals = {"vim"} },
	  telemetry = { enable = false },
	  workspace = { checkThirdParty = false },
	},
      },
    }
    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers({
      function(server_name)
	local normal_capabilities = vim.lsp.protocol.make_client_capabilities()
	local capabilities = cmp_nvim_lsp.default_capabilities(normal_capabilities)

	require("lspconfig")[server_name].setup {
	  capabilities = capabilities,
	  settings = servers[server_name]
	}
      end,
    })

    local lsp = require("lsp-zero")
    lsp.on_attach(function(_, _)
      local outline = require("outline")
      outline.open_outline({ focus_outline = false })
    end)

    lsp.preset("recommended")
    lsp.setup_nvim_cmp({
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

    lsp.setup() -- this needs to be last
  end
}
