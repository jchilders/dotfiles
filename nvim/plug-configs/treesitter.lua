require'lspconfig'.solargraph.setup {
	on_attach = require'completion'.on_attach,
	cmd = { "solargraph", "stdio" },
	filetypes = { "ruby" }
}

--require'nvim-treesitter.configs'.setup {
  --ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  --highlight = {
    --enable = true              -- false will disable the whole extension
  --},
  --indent = {
    --enable = true
  --},
  --refactor = {
    --highlight_definitions = { enable = true },
    --highlight_current_scope = { enable = false },
    --smart_rename = {
      --enable = true,
      --keymaps = {
        --smart_rename = "grr",
      --},
    --},
    --navigation = {
      --enable = true,
      --keymaps = {
        --goto_definition = "gnd",
        --list_definitions = "gnD",
        --list_definitions_toc = "gO",
        --goto_next_usage = "<a-*>",
        --goto_previous_usage = "<a-#>",
      --},
    --},
  --},
--}
