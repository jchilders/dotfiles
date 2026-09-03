-- Things to do when troublshooting treesitter issues:
--   `:TSUpdate`
--
-- This is the `main` branch rewrite. The old `master` branch is frozen at
-- Nvim 0.11 and will not run here. Differences that matter:
--   - no `configs.setup()`; parsers are installed via `install()`
--   - highlighting is opt-in per buffer via `vim.treesitter.start()`
--   - `ensure_installed`, `incremental_selection` and `ts_utils` are gone
--   - parsers are compiled locally, so the `tree-sitter` CLI is required
local parsers = {
  "bash",
  "cpp",
  "css",
  "git_rebase",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "ruby",
  "rust",
  "sql",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  enabled = true,
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
  },
  config = function()
    require("nvim-treesitter").install(parsers)

    -- Indentation stayed off in the master-branch config, so no indentexpr here.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("jc_treesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not lang then
          return
        end
        -- Fails for filetypes whose parser isn't installed (or is still
        -- compiling on first launch); that's expected, so stay quiet.
        pcall(vim.treesitter.start, ev.buf, lang)
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
