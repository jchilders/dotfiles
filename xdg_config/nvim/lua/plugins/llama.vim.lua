-- Local LLM-assisted text completion.
-- https://github.com/ggml-org/llama.vim
--
-- Requires a running llama.cpp server:
--    llama-server -m <model>
--
-- Start the server in a separate process:

-- local Job = require("plenary.job")
--
-- local function write_to_log(message)
--   local log_file_path = vim.fn.stdpath('cache') .. '/llama.nvim.log'  -- Default log file location
--
--   local file = io.open(log_file_path, "a")
--   if file then
--     local timestamp = os.date("%Y-%m-%d %H:%M:%S")
--     file:write(string.format("[%s] %s\n", timestamp, message))
--     file:close()
--   else
--     vim.notify("Failed to open log file: " .. log_file_path, vim.log.levels.ERROR)
--   end
-- end
--
-- local function start_llama_server()
--   write_to_log("llama-server: starting")
--   Job:new({
--     command = '/opt/homebrew/bin/llama-server',
--     args = { '-m', '~/Library/Caches/llama.cpp/ggml-org_Qwen2.5-Coder-7B-Q8_0-GGUF_qwen2.5-coder-7b-q8_0.gguf',
--     '--port', '8012',
--     '-ngl', '99',
--     '-fa',
--     '-ub', '1024',
--     '-b', '1024',
--     '-dt', '0.1',
--     '--ctx-size', '0',
--     '--cache-reuse', '256' },
--     env = {},
--     detached = true,
--     on_exit = function(_, return_val)
--       write_to_log("llama-server: exited with exit code " .. return_val)
--     end,
--     on_stdout = function(_, data, _)
--       write_to_log("llama-server: " .. data)
--     end
--   }):start()
-- end

-- start_llama_server()

return {
  "ggml-org/llama.vim",
  enabled = true,
  lazy = false,
}
