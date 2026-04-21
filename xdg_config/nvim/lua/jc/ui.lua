local M = {}

-- Toggle the display of non-text UI: sign column, relative line numbers,
-- indent-blankline guides, and LSP diagnostics. Useful for a clean view.
function M.toggle_zenish()
  if vim.wo.relativenumber == true then
    vim.wo.signcolumn = "no"
    vim.wo.relativenumber = false
    vim.wo.number = false
    require("ibl").update { enabled = false }
    vim.diagnostic.enable(false)
  else
    vim.wo.signcolumn = "yes"
    vim.wo.relativenumber = true
    vim.wo.number = true
    require("ibl").update { enabled = true }
    vim.diagnostic.enable(true)
  end
end

function M.toggle_qf()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

return M
