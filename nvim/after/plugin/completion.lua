vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

-- :setglobal

-- Not currently working (... with vim-plug?). See:
-- https://github.com/ms-jpq/coq_nvim/issues/11
-- Manually enable with :COQnow
vim.g.coq_settings = { auto_start = true }
