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

-- Insert binding.pry or binding.p above or below the current line, depending on the direction
-- direction is 'above' or 'below'
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
