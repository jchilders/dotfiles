local grp = vim.api.nvim_create_augroup("AsmAssembleOnSave", { clear = false })

vim.bo.makeprg = "as -o %:r.o %"
vim.bo.errorformat = "%f:%l:%c: %m"

vim.api.nvim_create_autocmd("BufWritePost", {
  group = grp,
  buffer = 0,
  callback = function()
    vim.cmd("silent make!")
    if #vim.fn.getqflist() > 0 then vim.cmd("cwindow") end
  end,
})
