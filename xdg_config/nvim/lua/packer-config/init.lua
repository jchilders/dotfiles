local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.globals")
local data_path = global.data_path -- $XDG_DATA_HOME/nvim/site
local sep_os_replacer = require("utils").sep_os_replacer
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"
local remap = require("utils").map_global
local bmap = require("utils").map_buffer_new

local disable_things = false

-- ??Problems??
-- :PackerInstall
-- :PackerClean
-- :PackerCompile
-- quit/reload

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

  -- telescope
  use({
    "nvim-telescope/telescope.nvim",
    disable = false,
    config = require("plugins.telescope").init,
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-project.nvim", opt = true },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        opt = true,
        run = "make",
      },
    },
  })

  -- harpoon lets you mark a small number of key files on a per-project basis,
  -- and quickly nav to them
  use({
    "ThePrimeagen/harpoon",
    disable = false,
    config = require("plugins.harpoon").init,
  })

  -- faster startup time
  use({ "nathom/filetype.nvim" })

  -- {{ Tree-sitter treesitter }} --
  use({
    "nvim-treesitter/nvim-treesitter",
    disable = false,
    config = require("plugins.nvim-treesitter").init,
  })

  -- :TSPlaygroundToggle
  use({ "nvim-treesitter/playground" })

  -- smart selection/moving/previewing of TS/LSP objects
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })

  -- Use `v.` in normal mode in treesitter-enabled buffer to visually select
  -- progressively broader TS nodes
  use({ "RRethy/nvim-treesitter-textsubjects" })

  -- comment code using directions or blocks. example:
  -- gc2j - comment current line and 2 down
  -- V2jgc - visually select current line & 2 down, then comment
  use({
    "b3nj5m1n/kommentary",
    disable = false,
    -- all config here is recommented by nvim-ts-context-commentstring docs
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_multi_line_comments = false,
        use_consistent_indentation = true,
      })

      require("nvim-treesitter.configs").setup({
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      })

      local filetypes = { "javascriptreact", "typescriptreact"}
      for _, filetype in pairs(filetypes) do
        require("kommentary.config").configure_language(filetype, {
          single_line_comment_string = "auto",
          multi_line_comment_strings = "auto",
          hook_function = function()
            require("ts_context_commentstring.internal").update_commentstring()
          end,
        })
      end
    end,
  })

  -- completion
  use({
    "hrsh7th/nvim-cmp",
    disable = false,
    config = require("plugins.cmp").init,
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      -- { "rafamadriz/friendly-snippets" },
    },
  })

  use({
    'andymass/vim-matchup',
    disable = false,
    config = function()
      vim.g.matchup_matchparen_offscreen = {}

      require'nvim-treesitter.configs'.setup({
        matchup = {
          enable = true
        }
      })
    end
  })

  use({
    "vim-test/vim-test",
    disable = true,
    cmd = { "TestFile" },
    requires = {
      {
        "neomake/neomake",
        cmd = { "Neomake" },
      },
      { "tpope/vim-dispatch", cmd = { "Dispatch" } },
    },
    wants = { "vim-dispatch", "neomake" },
  })

  -- use({ "ray-x/lsp_signature.nvim", opt = true }) -- auto signature trigger

  -- {{ LSP }}

  use({ "neovim/nvim-lspconfig" })
  use({ "williamboman/nvim-lsp-installer" })
  use({ "nvim-lua/lsp-status.nvim" })

	-- Add pictograms to completion window suggestion list
  use({
    "onsails/lspkind-nvim",
    disable = false,
    config = require("plugins.lspkind-nvim").init,
  })

  -- Window/split containing a pretty list for showing diagnostics, references,
  -- telescope results, quickfix and location lists to help you solve all the
  -- trouble your code is causing.
  use({
    "folke/lsp-trouble.nvim",
    disable = true,
    config = function()
      require("trouble").setup()
    end,
    cmd = { "LspTroubleToggle" },
    requires = "kyazdani42/nvim-web-devicons",
  }) -- window for showing LSP detected issues in code

  -- {{ /LSP }}

  -- autoclose parens, function defs, etc.
  -- :h lexima.vim
  use({
    "cohama/lexima.vim",
    disable = false,
    --[[ config = function()
      vim.g.lexima_enable_basic_rules = 0 -- turn it off for quotes/parens/etc
    end, ]]
  })

  -- look and feel of neovim

  require("core.highlights") -- load before colorscheme cfg

  -- colorscheme
  use({
    "folke/tokyonight.nvim",
    disable = false,
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
      vim.g.tokyonight_style = "night"

      vim.cmd([[colorscheme tokyonight]])
    end,
  })

  -- statusline
  use({
    "windwp/windline.nvim",
    disable = false,
    config = function()
      require("plugins.statusline.airline")
    end,
  })

  -- adds current function/class/etc. name to statusline
  use({
    "SmiteshP/nvim-gps",
    disable = false,
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- indicate changed lines in gutter
  use({
    'lewis6991/gitsigns.nvim',
    disable = false,
    requires = 'nvim-lua/plenary.nvim',
    config = function()
			require('gitsigns').setup({
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local bmap = require("utils").map_buffer_new
					bmap('n', '<leader>gb', gs.toggle_current_line_blame)
				end
			})
    end
  })

  -- Add documentation to a method/class/etc with a mapping.
  -- Currently set to `<leader>doc`
  use({
    "danymat/neogen",
    disable = false,
    config = function()
      require('neogen').setup({})

			local remap = require("utils").map_global
      remap("n", "<leader>doc", "<cmd>lua require('neogen').generate()<CR>")
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  })

  -- {{ to investigate }}
  -- mrjones2014/dash.nvim - Fuzzy search Dash.app (API docsets)
  -- tpope/vim-repeat - allows `.` command to work w/ mappings

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
  local install_path = sep_os_replacer(fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim")
  -- check if packer exists or is installed
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fetch packer
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")

    -- autocmd hook to wait for packer install and then after install load the needed config for plugins
    vim.cmd("autocmd User PackerComplete ++once lua require('load_config').init()")

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
    assert("Missing packer compile file Run PackerCompile Or PackerInstall to fix")
  end

  vim.cmd([[command! PackerCompile lua require('packer-config').auto_compile()]])
  vim.cmd([[command! PackerInstall lua require('packer-config').install()]])
  vim.cmd([[command! PackerUpdate lua require('packer-config').update()]])
  vim.cmd([[command! PackerSync lua require('packer-config').sync()]])
  vim.cmd([[command! PackerClean lua require('packer-config').clean()]])
  vim.cmd([[command! PackerStatus  lua require('packer-config').status()]])

  -- autocompile event
  vim.cmd([[autocmd User PackerComplete lua require('packer-config').auto_compile()]])
end

return plugins
