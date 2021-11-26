local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.global")
local data_path = global.data_path
local sep_os_replacer = require("utils").sep_os_replacer
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"

local is_private = vim.fn.expand("$USER") == "dashie"

-- nil because packer is opt
local packer = nil

local function init()
  packer = require("packer")
  packer.init({
    compile_path = packer_compiled,
    disable_commands = true,
    display = {
      open_fn = require("packer.util").float,
    },
    git = { clone_timeout = 120 },
  })
  packer.reset()
  local use = packer.use

  use({ "kyazdani42/nvim-web-devicons" })

  use({
      "windwp/windline.nvim",
      config = function()
        require("plugins.statusline.windline")
      end,
      }) -- statusline

  use({ "romgrk/barbar.nvim", requires = "kyazdani42/nvim-web-devicons" }) -- bufferline

  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
      vim.g.tokyonight_style = "night"
      vim.g.tokyonight_transparent = not vim.g.neovide and true or false

      vim.cmd([[colorscheme tokyonight]])
      require("core.highlights")
    end,
  })


  use({
    "vim-test/vim-test",
    cmd = { "TestFile" },
    requires = {
      {
        "neomake/neomake",
        cmd = { "Neomake" },
      },
      { "tpope/vim-dispatch", cmd = { "Dispatch" } },
    },
    wants = { "vim-dispatch", "neomake" },
  }) -- testing


  use({ "b3nj5m1n/kommentary", opt = true })

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    cmd = { "Telescope" },
--    config = require("plugins.telescope").init,
    config = function()
      vim.cmd([[echo hellooooooooooooooooooo]])
      require("telescope").setup({
        defaults = {
          prompt_prefix = "?> "
        }
      })
    end,
    requires = {
      {'nvim-lua/plenary.nvim'},
    },
  }

--  use({
--    "nvim-telescope/telescope.nvim",
--    -- config = require("plugins.telescope").init,
--    config = function()
--      vim.cmd([[echo hellooooooooooooooooooo]])
--      require("telescope").setup()
--    end,
--    requires = {
--      { "nvim-lua/plenary.nvim", opt = false },
--      { "nvim-telescope/telescope-project.nvim", opt = true },
--      {
--        "nvim-telescope/telescope-fzf-native.nvim",
--        opt = true,
--        run = "make",
--      },
--    },
--  })


  -- lib
  use({ "wbthomason/packer.nvim", opt = true })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    if not packer then
      init()
    end
    return packer[key]
  end,
})

-- Bootstrap Packer and the Plugins + loads configs afterwards
function plugins.bootstrap()
  local install_path = sep_os_replacer(
    fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
  )
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    execute(
      "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
    )
    execute("packadd packer.nvim")

    -- autocmd hook to wait for packer install and then after install load the needed config for plugins
    vim.cmd(
      "autocmd User PackerComplete ++once lua require('load_config').init()"
    )

    -- load packer plugins
    init()

    -- install packer plugins
    require("packer").sync()
  else
    -- add packer and load plugins and config
    execute("packadd packer.nvim")
    init()
    require("load_config").init()
  end
end

-- converts the compiled file to lua
function plugins.convert_compile_file()
  local lines = {}
  local lnum = 1
  lines[#lines + 1] = "vim.cmd [[packadd packer.nvim]]\n"
  for line in io.lines(packer_compiled) do
    lnum = lnum + 1
    if lnum > 15 then
      lines[#lines + 1] = line .. "\n"
      if line == "END" then
        break
      end
    end
  end
  table.remove(lines, #lines)
  if fn.isdirectory(data_path .. "lua") ~= 1 then
    os.execute("mkdir -p " .. data_path .. "lua")
  end
  if fn.filereadable(compile_to_lua) == 1 then
    os.remove(compile_to_lua)
  end
  local file = io.open(compile_to_lua, "w")
  for _, line in ipairs(lines) do
    file:write(line)
  end
  file:close()

  os.remove(packer_compiled)
end

-- autocompile function called by autocmd on packer complete
function plugins.auto_compile()
  plugins.compile()
  plugins.convert_compile_file()
end

-- loads the compiled packer file and sets the commands for packer
function plugins.load_compile()
  if fn.filereadable(compile_to_lua) == 1 then
    require("_compiled")
  else
    assert(
      "Missing packer compile file Run PackerCompile Or PackerInstall to fix"
    )
  end

  vim.cmd(
    [[command! PackerCompile lua require('packer-config').auto_compile()]]
  )
  vim.cmd([[command! PackerInstall lua require('packer-config').install()]])
  vim.cmd([[command! PackerUpdate lua require('packer-config').update()]])
  vim.cmd([[command! PackerSync lua require('packer-config').sync()]])
  vim.cmd([[command! PackerClean lua require('packer-config').clean()]])
  vim.cmd([[command! PackerStatus  lua require('packer-config').status()]])

  -- autocompile event
  vim.cmd(
    [[autocmd User PackerComplete lua require('packer-config').auto_compile()]]
  )
end

return plugins
