local uv = vim.loop
local emu = require("jc.wezterm")
local utils = require("jc.utils")

local M = {}

-- Find the most recently modified test file in the current directory tree for the file being edited. Example: if the file being edited is a .rb file then it will look for a minitest file in the `test` directory.
-- Returns nil if nothing found.
local function mru_test_file()
  local ext = vim.fn.expand("%:e") -- get the current file extension

  local glob;
  if ext == "rb" then -- ruby/rails/rspec/minitest
    glob = "(test|spec)/**/*_(test|spec)*.rb"
  elseif ext == "jsx" then
    glob = "app/javascript/**/*.test.jsx"
  elseif ext == "ts" or ext == "tsx" then
    glob = "src/**/*.test.ts(|x)"
  else
    vim.notify("Don't know how to handle ." .. ext .. " files", vim.log.levels.WARN, { title = "Muxor" })
    return nil
  end

  -- Now we need to actually find the file. Getting the most recently modified file for a directory tree turned out to be an interesting exercise. I landed on using zsh glob qualifiers because that, somewhat surprisingly, turned out to be faster than anything else: `find`, `exa`, `fd`, `stat`. Tried 'em all, and globbing was the fastest. This was close, though:
  --   fd -t file -e rb --search-path spec --search-path test --exec-batch ls -rth | tail -n 1

  -- https://zsh.sourceforge.io/Doc/Release/Expansion.html - 14.8.7
  -- `(om)` tells zsh to sort the glob matches by last modified date
  glob = glob .. "(om[1])"
  local test_file = vim.fn.system("print -l " .. glob .. "  | tr -d '\n'")
  if vim.fn.stridx(test_file, "no matches found") >= 0 then
    vim.notify("No test found for type ." .. ext .. "\n" .. glob, vim.log.levels.WARN, { title = "Muxor" })
    return nil
  else
    vim.notify("Running ".. test_file, vim.log.levels.INFO, { title = "Muxor" })
  end

  return test_file
end

-- Get the buffer number for the most recently modified test file
-- If the file is not open, open it
local bufnr_for_test_file = function()
  local test_file = mru_test_file()
  if test_file == nil then
    vim.notify("No test file found", vim.log.levels.WARN)
    return -1
  end

  local bufnr = vim.fn.bufnr(test_file)
  if bufnr == -1 then
    vim.cmd('edit ' .. test_file)
    bufnr = vim.fn.bufnr(test_file)
  end

  return vim.fn.bufnr(test_file)
end

-- Find and run the most recently modified test
-- :au BufWritePost <buffer>  lua require("jc.chuck_tester").run_mru_test()
function M.run_mru_test(linenr)
  local test_file = mru_test_file()
  if test_file == nil then
    return
  end

  local ext = vim.fn.expand("%:e") -- get the current file extension
  local test_cmd;

  -- TODO abstract this out. big if/else == bad
  if ext == "rb" then
    local is_spec = string.find(test_file, "_spec")
    if is_spec then
      -- check if the rspec command exists in the bin directory
      local has_rspec = vim.fn.filereadable("bin/rspec")
      if has_rspec == 1 then
        test_cmd = "bin/rspec"
      else
        test_cmd = "rspec"
      end
    else
      test_cmd = "bin/rails test"
    end

    test_cmd = test_cmd .. " " .. test_file

    if linenr ~= nil then
      test_cmd = test_cmd .. ":" .. linenr
    end
  elseif ext == "jsx" then -- JS/React
    test_cmd = "yarn test " .. test_file
  elseif ext == "ts" then -- TypeScript
    test_cmd = "npx vitest --run " .. test_file
  end

  local has_docker = vim.fn.filereadable("docker-compose.yml")
  if has_docker ~= 0 then
    test_cmd = "docker compose run --rm app " .. test_cmd
  end

  emu.send_left(test_cmd)
end

function M.run_mru_test_current_line()
  local bufnr = bufnr_for_test_file()

  if bufnr == -1 then
    vim.notify("No buffer for test file", vim.log.levels.ERROR)
    return "no"
  end

  local linenr = vim.api.nvim_buf_get_mark(bufnr, '.')[1]
  return M.run_mru_test(linenr)
end

function M.edit_mru_test()
  local ok, test_file = pcall(mru_test_file)
  if not ok then
    vim.notify("No test file found to run", vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. test_file)
end

return M
