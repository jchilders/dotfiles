-- When opening a file, restore cursor position (`g'"`) to where it was when
-- that file was last edited
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "Brewfile", "*.thor", "*.jbuilder", "*.arb", "*.rbi" },
  command = "set filetype=ruby",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "Gemfile.lock" },
  command = "set filetype=yaml", -- not really but kinda
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "*.zsh" },
  command = "set filetype=bash",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "*.dt", "Dockerfile*" },
  command = "set filetype=dockerfile",
})

local function show_lsp_info()
-- Get LSP clients attached to the current buffer
local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
if #clients == 0 then
  vim.notify("No LSP client attached to this buffer.", vim.log.levels.INFO)
  return
end

-- Prepare the information to display
local lines = { "LSP Clients Attached:" }
for _, client in ipairs(clients) do
  table.insert(lines, string.format(" - Name: %s", client.name))
  table.insert(lines, string.format("   ID: %d", client.id))
  table.insert(lines, "   Capabilities:")
  for cap, value in pairs(client.server_capabilities) do
    table.insert(lines, string.format("     %s: %s", cap, tostring(value)))
  end
end

-- Calculate window dimensions
local win_width = math.floor(vim.o.columns * 0.8)
local win_height = math.floor(vim.o.lines * 0.75)
local col = math.floor((vim.o.columns - win_width) / 2)
local row = math.floor((vim.o.lines - win_height) / 2)

-- Create a floating window
local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines) -- Set content
vim.api.nvim_open_win(buf, true, {
  relative = "editor",
  width = win_width,
  height = win_height,
  col = col,
  row = row,
  style = "minimal",
  border = "rounded",
})

-- Close the window on key press
vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR>", { noremap = true, silent = true })
end-- Create a user command to call the function
vim.api.nvim_create_user_command("LspInfo", show_lsp_info, {})

-- Insert `binding.pry` or `binding.p` above or below the current line, depending on the `direction`,
-- where `direction` is one of 'above' or 'below'
local function insert_binding(direction)
  -- Check if the current buffer is a Ruby file
  if vim.bo.filetype ~= 'ruby' then
    print("This function only works in Ruby files.")
    return
  end

  -- Determine the text to insert based on Gemfile content
  local insert_text = 'binding.b'

  -- Get the git root directory
  local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')

  -- Check if Gemfile exists in the git root
  local gemfile_path = git_root .. '/Gemfile'
  if vim.fn.filereadable(gemfile_path) == 1 then
    -- Read the Gemfile content
    local gemfile_content = vim.fn.readfile(gemfile_path)

    -- Check if 'gem pry' line exists
    for _, line in ipairs(gemfile_content) do
      if line:match("gem%s+['\"]pry['\"]") then
        insert_text = 'binding.pry'
        break
      end
    end
  end

  local insert_cmd = direction == 'above' and 'O' or 'o'

  vim.cmd('normal! ' .. insert_cmd .. insert_text)
end

-- Map the functions to key combinations, only in Ruby files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    -- Insert below with <leader>db
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>db', '', {noremap = true, callback = function() insert_binding('below') end })
    -- Insert above with <leader>dB
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dB', '', {noremap = true, callback = function() insert_binding('above') end })
  end
})
