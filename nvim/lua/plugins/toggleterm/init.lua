local M = {}
M.__index = M

local togterm = require("toggleterm.terminal")
local Terminal = togterm.Terminal

function M.init()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
	return 15
      elseif term.direction == "vertical" then
	return vim.o.columns * 0.5
      end
    end,
  })
end

local function float_term(cmd, opts)
  opts = opts or {}
  local defaults = {
    cmd = cmd,
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "single",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<esc>", "<cmd>close<CR>", {noremap = true, silent = true})
    end,
    -- function to run on closing the terminal
    --[[ on_close = function(term)
      vim.cmd("Closing terminal")
    end, ]]
  }
  opts = vim.tbl_deep_extend("keep", opts, defaults)

  return Terminal:new(opts)
end

local lazygit_float = float_term("lazygit")

function M.toggle_lazygit()
  lazygit_float:toggle()
end

local curr_diff_float = float_term("git diff " .. vim.fn.expand("%:p"), {
  close_on_exit = false,
})
function M.toggle_curr_diff()
  curr_diff_float:toggle()
end

local left_term = function()
  local term_id = togterm.get_toggled_id()

  if term_id == nil then
    return Terminal:new({
      direction = "vertical",
      size = vim.o.columns * 0.5,
      on_open = function(_)
	vim.cmd([[wincmd H]])
      end,
    })
  else
    return togterm.get(term_id)
  end
end
function M.toggle_left_term()
  return left_term():toggle()
end

return M
