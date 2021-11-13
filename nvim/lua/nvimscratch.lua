-- https://learnxinyminutes.com/docs/lua/

-- print vim global named 'coq_settings'
lua print(vim.inspect(vim.g.coq_settings))

lua print(vim.inspect(vim.api.nvim_win_get_cursor(0)))
lua require('jc.utils').P(vim.treesitter.parse_query("ruby", "(string)"))

lua require('jc.utils').P(vim.treesitter.get_parser(0, "ruby"):parse()[1]:root())

:lua local row, col = unpack(vim.api.nvim_win_get_cursor(0))
:lua print(row)

lua require('jc.utils').P(vim.treesitter.language.inspect_language("ruby"))

lua print(vim.treesitter.inspect_language('ruby'))


:lua print(vim.api.nvim_win_get_cursor(0))
vim.api.nvim_win_get_cursor(0)

:lua vim.api.nvim_win_set_cursor(0, {1,0})

PrintTable = function(t)
  for k,v in pairs(t) do
    print(k,v)
  end
end

t = {}
t[1] = "def hi"
t[2] = "  puts 'hi'"
t[3] = "end"
t

PrintTable(t)
table.concat(t, "\r")
PrintTable(table.concat(t, "\r"))

for k, v in pairs(t) do
  print(v)
end

if str:sub(#str, #str) ~= "\r" then
  print("it is NOT")
else
  print("it IS")
end

if str:sub(#str, #str) ~= "\r" then
  print("it is NOT, in fact, a single carriage return")
end

-- add to end of table
t[#t+1] = "\n"

function split(str, delim)
  if delim == nil then
    delim = "%s"
  end

  local t={}
  for substr in string.gmatch(str, "([^" .. delim .. "]+)") do
    table.insert(t, substr)
  end

  return t
end

str = "this/is/a/path"
str
matches = split(str, "/")
PrintTable(matches)

for k, v in pairs(matches) do
  print(v)
end

scratch_file = matches[#matches] .."_scratch.rb"

print("Last match: '" .. matches[#matches] .. "'")

lua require('jc.utils').add_gem_to_lsp_workspace("sidekiq")

print(vim.api.nvim_buf_get_name(1))
print(vim.inspect(vim.api.nvim_list_bufs()))
lua require('jc.utils').P(vim.treesitter.language.inspect_language("ruby"))

((_) @quote (vim-match? @quote "^\\"$"))
lua print(vim.inspect(require('jc.quote-toggler').query_treesitter('((_) @quote (vim-match? @quote "^\\"$"))')))
lua print(vim.inspect(require('jc.quote-toggler').query_treesitter('((_) @node)')))
lua print(vim.inspect(require('jc.quote-toggler').query_treesitter('("")')))
lua print(vim.inspect(require('jc.quote-toggler').next_node()))

lua print(vim.inspect(require('jc.quote-toggler').next_string_for_current_line()))

tree = vim.treesitter.get_parser(0, "ruby"):parse()[1]:root()
tree

lua print(vim.inspect(require('jc.quote-toggler').query_treesitter('(string (string_content) @str)')))
LUA_PATH
print(LUA_PATH)
print(vim.g.lua_path)

lua print(require('jc.git_utils').current_repo_name())
lua require('jc.utils').key_mapper("Q", "<NOP>")

