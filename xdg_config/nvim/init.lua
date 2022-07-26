-- disable unused vim builtins -- decreases startup time
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"logipat",
	"matchit",
	"matchparen",
	"rrhelper",
	"tar",
	"tarPlugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 0
end

local bootstrap = require('core.bootstrap_packer')
if bootstrap.needed() then
  bootstrap.bootstrap()
end

-- setup conf and lua modules
require("core.globals")
require("core.options").load()
require("core.mappings").load()
require("core.autocmd").load()

require("packer-config")
