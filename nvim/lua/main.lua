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
require("core.globals")
require("core.options").load_options()
require("core.mappings").mappings()
require("core.autocmd").init()

local pack = require("packer-config")
pack.bootstrap()
pack.load_compile()
