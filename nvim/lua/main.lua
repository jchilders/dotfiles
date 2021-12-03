-- Main Load File
-- Execution Flow of each loaded configuration
-- for various plugins
-- also a lot of configuration for plugins can be found
-- in the packer config setup
-- because of lazyloading
local g = vim.g

-- disable unused vim builtins -- decreases startup time
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "logipat",
  "rrhelper",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- setup conf and lua modules
require("core.global")
require("core.options").load_options()
require("core.mappings").mappings()
require("core.autocmd").init()

local pack = require("packer-config")
pack.bootstrap()
pack.load_compile()
