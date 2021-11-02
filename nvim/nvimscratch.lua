-- print vim global named 'coq_settings'
lua print(vim.inspect(vim.g.coq_settings))

:lua print(vim.inspect(vim.api.nvim_win_get_cursor(0)))

:lua local row, col = unpack(vim.api.nvim_win_get_cursor(0))
:lua print(row)

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

PrintTable(t)
table.concat(t, "\r")
PrintTable(table.concat(t, "\r"))



for k, v in pairs(t) do
  print(v)
end

if str:sub(#str, #str) ~= "\r" then
  print("it is NOT")
  str = str .. "\r"
else
  print("it IS")
end

if str:sub(#str, #str) ~= "\r" then
  print("it is NOT, in fact, a single carriage return")
end

-- add to end of table
t[#t+1] = "\n"
