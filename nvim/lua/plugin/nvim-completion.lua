vim.cmd [[ set completeopt=menuone,noinsert,noselect ]]

-- Don't show the dumb matching stuff.
vim.cmd [[ set shortmess+=c ]]

vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { 'buffers', 'lsp' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
}

-- can be one or more of 'exact', 'substring', 'fuzzy', and 'all'
vim.g.completion_matching_strategy_list = { 'fuzzy' }

-- can be one of "length", "alphabet", "none"
vim.g.completion_sorting = { 'alphabet' }

vim.cmd [[ autocmd BufEnter * lua require'completion'.on_attach() ]]

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Use <Tab> and <S-Tab> to navigate through popup completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
