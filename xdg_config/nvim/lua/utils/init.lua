local M = {}

function M.map(bufnr, type, key, value, opt)
  if opt then
    vim.api.nvim_buf_set_keymap(bufnr, type, key, value, opt)
  else
    vim.api.nvim_buf_set_keymap(
      bufnr,
      type,
      key,
      value,
      { noremap = true, silent = true, expr = false }
    )
  end
end

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
    return
  end

  vim.cmd("copen")
end

-- TODO: Update this to use `vim.keymap.set`
function M.map_global(type, key, value, expr)
  vim.api.nvim_set_keymap(type, key, value, { noremap = true, silent = true, expr = expr })
end

return M
