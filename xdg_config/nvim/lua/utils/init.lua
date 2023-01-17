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
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  end
end

-- TODO: Update this to use `vim.keymap.set`
function M.map_global(type, key, value, expr)
  vim.api.nvim_set_keymap(type, key, value, { noremap = true, silent = true, expr = expr })
end

function M.ci()
  vim.cmd([[packadd nvim-notify]])
  local notify = require("notify")
  notify.setup({
    -- Animation style (see below for details)
    -- stages = "fade",
    -- Default timeout for notifications
    timeout = 3000,
    -- For stages that change opacity this is treated as the highlight behind the window
    background_colour = "NotifyBG",
    -- Icons for the different levels
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
  })
  local Job = require("plenary.job")
  local ci = { "LOADING" }
  Job
    :new({
      command = "hub",
      args = { "ci-status", "-f", "%t %S%n" },
      on_exit = function(j, _)
        local result = ""
        local count = 0
        ci = j:result()

        for _, msg in ipairs(ci) do
          if count >= 0 then
            result = result .. msg .. "\n"
            count = 0
          else
            result = result .. msg
            count = count + 1
          end
        end

        notify(result, _, { title = "Github CI" })
      end,
    })
    :start()
end

return M
