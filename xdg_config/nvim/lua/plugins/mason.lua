-- Helps install LSPs.
return {
  "williamboman/mason.nvim",
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
        "lua_ls",
        "bashls",
        "dockerls",
        "jsonls",
        "lemminx",
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
