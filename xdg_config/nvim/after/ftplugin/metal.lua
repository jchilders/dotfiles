-- Treat Metal as C++-like

vim.bo.commentstring = "// %s"
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.cindent = true

-- Useful for GPU-style brace formatting
vim.bo.cinoptions = vim.bo.cinoptions .. ",l1"

vim.opt_local.conceallevel = 0
