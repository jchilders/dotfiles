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

-- if needed, bootstrap packer and exit
if require('core.bootstrap_packer')() then
	return
end

-- setup conf and lua modules
require("core.globals")
require("core.options").load()
require("core.mappings").load()
require("core.autocmd").load()

require("packer-config")
