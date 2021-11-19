-- This file defines the mappings used to open files based upon fuzzy finding
-- by directory prefix, content search, or symbol search.
--
-- All are prefixed by <C-o>

TelescopeMapArgs = TelescopeMapArgs or {}

-- ty tjdevries learning a lot
local map_ctrlo = function(key, rhs, options, bufnr)
  local key = "<C-o>" .. key
  local mode = "n"
  local map_options
  if options == nil then
    options = {
      noremap = true,
      silent = true,
    }
  end

  if not bufnr then
    vim.api.nvim_set_keymap(mode, key, rhs, options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, options)
  end
end

-- @param {string} f - telescope function to call
local map_ctrlo_tscope = function(key, f, options, bufnr)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)
  TelescopeMapArgs[map_key] = options or {}
  local rhs = string.format("<cmd>lua R('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", f, map_key)

  map_ctrlo(key, rhs, options, bufnr)
end

-- {{ ctrl-o mappings }}

map_ctrlo_tscope("b", "buffers")

-- map_ctrlo_tscope("F", "live_grep")
map_ctrlo_tscope("f", "grep_string" )
map_ctrlo_tscope("F", "search_all_files")

-- git
-- switch branches
map_ctrlo_tscope("gb", "git_branches")
-- git history of file in current buffer
map_ctrlo_tscope("gh", "git_bcommits")
-- edit changed file
map_ctrlo_tscope("gs", "git_status")

-- files
map_ctrlo_tscope("o", "find_files")
map_ctrlo_tscope("O", "search_all_files")
map_ctrlo_tscope("z", "search_only_files_of_type")

-- lsp
-- little r -> Search for LSP references to word under cursor
map_ctrlo_tscope("r", "lsp_references")

map_ctrlo_tscope("q", "quickfix")

-- little t -> Search list of symbols (tags) for current document
map_ctrlo_tscope("t", "lsp_document_symbols")
-- Big T -> Search list of symbols (tags) from entire workspace
map_ctrlo_tscope("T", "lsp_workspace_symbols")

-- rails
map_ctrlo_tscope("rc", "find_files", { search_dir = "app/controllers" })
map_ctrlo_tscope("rm", "find_files", { search_dir = "app/models" })
map_ctrlo_tscope("rv", "find_files", { search_dir = "app/views" })

-- harpoon
-- map_ctrlo("1", "find_files", { search_dir = "app/controllers" })

