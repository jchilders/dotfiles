-- This file defines the mappings used to open files based upon fuzzy finding
-- by directory prefix, content search, or symbol search.
--
-- All are prefixed by <C-o>

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = "n"
  local rhs = string.format("<cmd>lua R('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  local map_options = {
    noremap = true,
    silent = true,
  }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

local map_ctrlo = function(key, f, options, buffer)
  map_tele("<C-o>" .. key, f, options, buffer)
end

-- {{ ctrl-o mappings }}

map_ctrlo("b", "buffers")

-- map_ctrlo("F", "live_grep")
map_ctrlo("f", "grep_string" )
map_ctrlo("F", "search_all_files")

-- git
-- switch branches
map_ctrlo("gb", "git_branches")
-- git history of file in current buffer
map_ctrlo("gh", "git_bcommits")
-- edit changed file
map_ctrlo("gs", "git_status")

-- files
map_ctrlo("o", "find_files")
map_ctrlo("O", "search_all_files")
map_ctrlo("z", "search_only_files_of_type")

-- lsp
-- little r -> Search for LSP references to word under cursor
map_ctrlo("r", "lsp_references")
-- little t -> Search list of symbols (tags) for current document
map_ctrlo("t", "lsp_document_symbols")
-- Big T -> Search list of symbols (tags) from entire workspace
map_ctrlo("T", "lsp_workspace_symbols")

-- rails
map_ctrlo("rc", "find_files", { search_dir = "app/controllers" })
map_ctrlo("rm", "find_files", { search_dir = "app/models" })
map_ctrlo("rv", "find_files", { search_dir = "app/views" })
