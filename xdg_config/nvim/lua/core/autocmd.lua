-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.filetype.add({
  extension = {
    metal = "metal",
  },
})

vim.treesitter.language.register("cpp", "metal")

vim.api.nvim_create_augroup("ShebangFiletypeDetect", { clear = true })

-- I frequently paste scripts with shebangs into extensionless files. This autocmd
-- automatically sets the filetype for those on save, preventing the nead to reload
-- the file to enable syntax
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "ShebangFiletypeDetect",
  callback = function(args)
    local buf = args.buf

    -- If filetype is already set, don't touch it
    if vim.bo[buf].filetype ~= "" then
      return
    end

    -- Read first line only
    local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    if not first_line then
      return
    end

    -- Shebang check
    if not first_line:match("^#!") then
      return
    end

    -- Re-run filetype detection
    vim.cmd("filetype detect")
  end,
})

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
