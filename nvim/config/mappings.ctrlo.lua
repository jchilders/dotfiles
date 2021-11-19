-- This file defines the mappings used to open files based upon fuzzy finding
-- by directory prefix, content search, or symbol search.
--
-- All are prefixed by <C-o>

TelescopeMapArgs = TelescopeMapArgs or {}

-- ty tjdevries learning a lot
local map_ctrlo = function(key, rhs, map_options, bufnr)
  local key = "<C-o>" .. key
  local mode = "n"
  local map_options
  if map_options == nil then
    map_options = {
      noremap = true,
      silent = true,
    }
  end

  if not bufnr then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

-- @param {string} f - telescope function to 2all
local map_ctrlo_tele = function(key, f, tele_options, bufnr)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  TelescopeMapArgs[map_key] = tele_options or {}
  local rhs = string.format("<cmd>lua R('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  map_ctrlo(key, rhs)
end

-- {{ ctrl-o mappings }}

map_ctrlo_tele("b", "buffers")

-- map_ctrlo_tele("F", "live_grep")
map_ctrlo_tele("f", "grep_string" )
map_ctrlo_tele("F", "search_all_files")

-- git
-- switch branches
map_ctrlo_tele("gb", "git_branches")
-- git history of file in current buffer
map_ctrlo_tele("gh", "git_bcommits")
-- edit changed file
map_ctrlo_tele("gs", "git_status")

-- files
map_ctrlo_tele("o", "find_files")
map_ctrlo_tele("O", "search_all_files")
map_ctrlo_tele("z", "search_only_files_of_type")

-- lsp
-- little r -> Search for LSP references to word under cursor
map_ctrlo_tele("r", "lsp_references")

map_ctrlo_tele("q", "quickfix")

-- little t -> Search list of symbols (tags) for current document
map_ctrlo_tele("t", "lsp_document_symbols")
-- Big T -> Search list of symbols (tags) from entire workspace
map_ctrlo_tele("T", "lsp_workspace_symbols")

-- rails
map_ctrlo_tele("rc", "find_files", { search_dir = "app/controllers" })
map_ctrlo_tele("rm", "find_files", { search_dir = "app/models" })
map_ctrlo_tele("rv", "find_files", { search_dir = "app/views" })
