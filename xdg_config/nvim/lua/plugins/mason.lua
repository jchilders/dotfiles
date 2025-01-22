-- Helps install LSPs.
return {
  "williamboman/mason.nvim",
  enabled = false,
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
        "bashls",
        "dockerls",
        "jsonls",
        "lemminx",
        "lua_ls",
        "rubocop",
        "ruby_lsp",
        "rust_analyzer",
        "solargraph",
        "sqlls",
        "tailwindcss",
        "taplo",
      },
      automatic_installation = true })
  end
}
