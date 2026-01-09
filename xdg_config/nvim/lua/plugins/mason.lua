-- Helps install LSPs.
return {
  "mason-org/mason.nvim",
  enabled = true,
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
  },
  config = function ()
    require("mason.settings").set({
      ui = { border = "rounded" }
    })
    require("mason").setup()

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = {
        "html",
        "bashls",
        "dockerls",
        "jsonls",
        "pyright",
        "ruby_lsp",
        "rust_analyzer",
        "solargraph",
        "sqlls",
        "tailwindcss",
        "taplo",
        "ts_ls"
      },
      automatic_installation = true,
    })
  end
}
