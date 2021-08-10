vim.opt.completeopt = { "menuone", "noselect" }

local has_compe, compe = pcall(require, "compe")

if has_compe then
  compe.setup {
    autocomplete = true, -- Open popup automatically
    debug = false;
    enabled = true;
    preselect = "always",
    source = {
      path = true;
      buffer = true;
      nvim_lsp = true;
    };
  }

  vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()", { silent = true, noremap = true, expr = true })

  -- Some sources might rely on compe#confirm() mapping. For example, to expand snippets from the completion menu, you
  -- have to use compe#confirm() mapping.
  vim.api.nvim_set_keymap("i", "<c-y>", 'compe#confirm("<c-y>")', { silent = true, noremap = true, expr = true })

  vim.api.nvim_set_keymap("i", "<c-e>", 'compe#close("<c-e>")', { silent = true, noremap = true, expr = true })
end
