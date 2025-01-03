local uv = vim.loop
local emu = require("jc.wezterm")
local utils = require("jc.utils")

local M = {}

-- Base test configuration "class"
local TestConfig = {}
TestConfig.__index = TestConfig

function TestConfig.new(glob_pattern, base_cmd)
  local self = setmetatable({}, TestConfig)
  self.glob_pattern = glob_pattern
  self.base_cmd = base_cmd
  return self
end

function TestConfig:glob()
  return self.glob_pattern
end

function TestConfig:get_test_cmd(test_file)
  return self.base_cmd .. " " .. test_file
end

-- Default implementation uses line numbers
function TestConfig:get_single_test_cmd(test_file, linenr, test_name)
  local cmd = self:get_test_cmd(test_file)
  if linenr then
    cmd = cmd .. ":" .. linenr
  end
  return cmd
end

-- Find the nearest test name using treesitter
function TestConfig:find_nearest_test(bufnr)
  return nil, vim.api.nvim_buf_get_mark(bufnr, '.')[1]
end

-- Ruby test configuration
local RubyTestConfig = {}
setmetatable(RubyTestConfig, { __index = TestConfig })
RubyTestConfig.__index = RubyTestConfig

function RubyTestConfig.new()
  local self = setmetatable(
    TestConfig.new("(test|spec)/**/*_(test|spec)*.rb", ""),
    RubyTestConfig
  )
  return self
end

function RubyTestConfig:get_test_cmd(test_file)
  local is_spec = string.find(test_file, "_spec")
  local cmd
  if is_spec then
    -- check if the rspec command exists in the bin directory
    local has_rspec = vim.fn.filereadable("bin/rspec")
    cmd = has_rspec == 1 and "bin/rspec" or "rspec"
  else
    cmd = "bin/rails test"
  end
  return cmd .. " " .. test_file
end

-- JavaScript test configuration
local JSTestConfig = {}
setmetatable(JSTestConfig, { __index = TestConfig })
JSTestConfig.__index = JSTestConfig

function JSTestConfig.new()
  local self = setmetatable(
    TestConfig.new("app/javascript/**/*.test.jsx", "yarn test"),
    JSTestConfig
  )
  return self
end

-- TypeScript test configuration
local TSTestConfig = {}
setmetatable(TSTestConfig, { __index = TestConfig })
TSTestConfig.__index = TSTestConfig

function TSTestConfig.new()
  local self = setmetatable(
    TestConfig.new("src/**/*.test.ts(|x)", "npx vitest --run"),
    TSTestConfig
  )
  return self
end

-- Override to use --testNamePattern instead of line numbers
function TSTestConfig:get_single_test_cmd(test_file, linenr, test_name)
  local base_cmd = self:get_test_cmd(test_file)
  if test_name then
    -- Escape any special characters in the test name
    test_name = test_name:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
    return base_cmd .. " --testNamePattern=" .. vim.fn.shellescape(test_name)
  end
  return base_cmd
end

-- Override to use treesitter to find test names
function TSTestConfig:find_nearest_test(bufnr)
  local test_name = nil
  local linenr = vim.api.nvim_buf_get_mark(bufnr, '.')[1]

  -- Query tree-sitter for the nearest "it()" or "describe()" node
  local parser = vim.treesitter.get_parser(bufnr, "typescript")
  if parser then
    local lang_tree = parser:parse()
    local root = lang_tree[1]:root()
    
    local query = vim.treesitter.query.parse("typescript", [[
      (call_expression
        function: (identifier) @func_name
        (#match? @func_name "^(it|test|describe)$")
        arguments: (arguments 
          [
            (template_string) @test_name
            (string) @test_name
          ]
          (arrow_function) @function_body
        )
      )
    ]])

    if query then
      local closest_line = nil
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1  -- Convert to 0-based
      local current_test_name = nil
      local current_function_start = nil
      local current_function_end = nil

      -- Find the closest test block to our cursor
      for id, node, metadata in query:iter_captures(root, bufnr) do
        if query.captures[id] == "func_name" then
          current_function_start = node:start()
        elseif query.captures[id] == "test_name" then
          -- Store the current test name for the next function name we find
          current_test_name = vim.treesitter.get_node_text(node, bufnr)
          -- Remove quotes or backticks from the start and end
          current_test_name = current_test_name:gsub("^[`'\"]", ""):gsub("[`'\"]$", "")
        elseif query.captures[id] == "function_body" then
          current_function_end = node:end_()
          -- Check if cursor is within this test block
          if current_function_start <= cursor_line and cursor_line <= current_function_end then
            closest_line = current_function_start + 1  -- convert to 1-based line number
            linenr = closest_line
            test_name = current_test_name
          end
        end
      end
    else
      vim.notify("Failed to parse tree-sitter query", vim.log.levels.WARN, { title = "chuck_tester" })
    end
  end

  return test_name, linenr
end

-- Map of file extensions to their test configurations
local test_configs = {
  rb = RubyTestConfig.new(),
  jsx = JSTestConfig.new(),
  ts = TSTestConfig.new(),
  tsx = TSTestConfig.new()
}

-- Find the most recently modified test file in the current directory tree for the file being edited.
-- Returns nil if nothing found.
local function mru_test_file()
  local ext = vim.fn.expand("%:e") -- get the current file extension
  local config = test_configs[ext]
  
  if not config then
    vim.notify("Don't know how to handle ." .. ext .. " files", vim.log.levels.WARN, { title = "chuck_tester" })
    return nil
  end

  -- Get the glob pattern for this file type
  local glob = config:glob()

  -- Add zsh glob qualifier to sort by most recently modified
  glob = glob .. "(om[1])"
  local test_file = vim.fn.system("print -l " .. glob .. "  | tr -d '\n'")
  
  if vim.fn.stridx(test_file, "no matches found") >= 0 then
    vim.notify("No test found for type ." .. ext .. "\n" .. glob, vim.log.levels.WARN, { title = "chuck_tester" })
    return nil
  else
    vim.notify("Running " .. test_file, vim.log.levels.INFO, { title = "chuck_tester" })
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

function M.run_mru_test(linenr, test_name)
  local test_file = mru_test_file()
  if test_file == nil then
    return
  end

  local ext = vim.fn.expand("%:e")
  local config = test_configs[ext]
  
  if not config then
    return
  end

  local test_cmd = config:get_single_test_cmd(test_file, linenr, test_name)

  -- Check for docker environment
  local has_docker = vim.fn.filereadable("docker-compose.yml")
  if has_docker ~= 0 then
    test_cmd = "docker compose run --rm app " .. test_cmd
  end

  emu.send_left(test_cmd)
end

function M.run_mru_test_current_line()
  -- It may or may not be active, so we need to get the buffer number
  local bufnr = bufnr_for_test_file()

  if bufnr == -1 then
    vim.notify("No buffer for test file", vim.log.levels.ERROR)
    return "no"
  end

  local ext = vim.fn.expand("%:e")
  local config = test_configs[ext]
  
  if not config then
    return
  end

  local test_name, linenr = config:find_nearest_test(bufnr)
  
  if test_name then
    vim.notify("Running test: " .. test_name, vim.log.levels.INFO, { title = "chuck_tester" })
  else
    vim.notify("Running test at line " .. linenr, vim.log.levels.INFO, { title = "chuck_tester" })
  end

  return M.run_mru_test(linenr, test_name)
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
