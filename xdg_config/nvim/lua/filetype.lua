vim.api.nvim_create_augroup("shebang_filetype", { clear = true })

-- Set `filetype` based on shebang `#!`
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  group = "shebang_filetype",
  pattern = "*",
  callback = function()
    local shebang = vim.fn.getline(1)
    if shebang:match('^#!.*%bruby%b') then
      vim.bo.filetype = 'ruby'
    elseif shebang:match('^#!.*%bzsh%b') then
      vim.bo.filetype = 'zsh'
    elseif shebang:match('^#!.*%bpython%b') then
      vim.bo.filetype = 'python'
    elseif shebang:match('^#!.*%bbash%b') then
      vim.bo.filetype = 'sh'
    elseif shebang:match('^#!.*%bnode%b') then
      vim.bo.filetype = 'javascript'
    elseif shebang:match('^#!.*%bosascript%b') then
      vim.bo.filetype = 'applescript'
    end
  end,
})

