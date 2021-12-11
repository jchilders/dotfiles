local execute = vim.api.nvim_command
local fn = vim.fn
local global = require("core.global")
local data_path = global.data_path
local sep_os_replacer = require("utils").sep_os_replacer
local packer_compiled = data_path .. "packer_compiled.vim"
local compile_to_lua = data_path .. "lua" .. global.path_sep .. "_compiled.lua"

-- ??Problems??
-- :PackerInstall
-- :PackerCompile
-- quit/reload

-- TODO: Use this idiom where appropriate:
--
--   local ok, icon = pcall(require, "nvim-web-devicons")
--   if ok then
--     web_devicons = icon
--   else
--     web_devicons = false
--    end

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

  -- persist and toggle multiple terminals
  -- :ToggleTerm size=40 dir=~/my_project direction=horizontal
  --
  -- `:h window`, but a few key mappings to know:
  --
  -- <C-W>L - move window to left (vim builtin)
  -- <C-W>R - move window to right (vim builtin)
  -- <C-W>X - Exchange curr window with next one.
  -- <C-W><C-X> - Same as above.
  --
  -- TODO: Add https://github.com/tknightz/telescope-termfinder.nvim
  -- TermExec cmd="git status"
  use ({
    "akinsho/toggleterm.nvim",
    config = require("plugins.toggleterm").init,
  })

  -- telescope
  use({
    "nvim-telescope/telescope.nvim",
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

  -- :Telescope tmux sessions
  -- :Telescope tmux windows
  use({
    "jchilders/telescope-tmux.nvim",
    branch = "incl_curr_session_opt",
  })

  -- harpoon lets you mark a small number of key files on a per-project basis,
  -- and quickly nav to them
  use({
    "ThePrimeagen/harpoon",
    config = require("plugins.harpoon").init,
  })

  -- faster lua-based filetype detection. helps with startup time.
  use({ "nathom/filetype.nvim" })

  -- automaticaly set `shiftwidth` & `expandtab`
  use({ "tpope/vim-sleuth" })

  -- code formatter. can handle embedded syntax blocks via `start_pattern`/`end_pattern` keys
  -- :Format
  use({
    "lukas-reineke/format.nvim",
    config = require("format").setup({
      ["*"] = {
        { cmd = { "sed -i 's/[ \t]*$//'" } }, -- remove trailing whitespace
      },
      lua = {
        { cmd = { "stylua" } },
      },
      python = {
        { cmd = { "black" } },
      },
    }),
  })

  -- {{ Tree-sitter treesitter }} --
  use({
    "nvim-treesitter/nvim-treesitter",
    config = require("plugins.nvim-treesitter").init,
  })

  -- :TSPlaygroundToggle
  use({ "nvim-treesitter/playground" })

  -- smart selection/moving/previewing of TS/LSP objects
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    disable = true -- disabled until I make keymaps for it
  })

  -- Use `v.` in normal mode in treesitter-enabled buffer to visually select
  -- progressively broader TS nodes
  use({ "RRethy/nvim-treesitter-textsubjects" })

  -- know how you can have e.g. HTML inside of a React file? If you want to
  -- comment out that HTML, this will use HTML comments instead of JS ones.
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    disable = false, -- disabling until I can integrate it with kommentary
  })

  use({
    "b3nj5m1n/kommentary",
    -- all config here is recommented by nvim-ts-context-commentstring docs
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_multi_line_comments = false,
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
  })

  -- automatically close & rename tags using treesitter
  use({
    "windwp/nvim-ts-autotag",
    ft = { "typescriptreact", "javascriptreact", "html" },
  })

  use({ "ray-x/lsp_signature.nvim", opt = true }) -- auto signature trigger

  -- helper for generating doc comments like:
  --   @param [String] my_param The paremeter that does a thing
  use({
    "danymat/neogen",
    disable = true, -- no ruby support yet
    cmd = { "DocGen" },
    config = require("plugins.neogen").init,
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- {{ LSP }}

  use({
    "neovim/nvim-lspconfig",
    "williamboman/nvim-lsp-installer",
  })

  use({ "nvim-lua/lsp-status.nvim" })

  use({
    "onsails/lspkind-nvim",
    config = require("plugins.lspkind-nvim").init,
  })

  -- Window/split containing a pretty list for showing diagnostics, references,
  -- telescope results, quickfix and location lists to help you solve all the
  -- trouble your code is causing.
  use({
    "folke/lsp-trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
    cmd = { "LspTroubleToggle" },
    requires = "kyazdani42/nvim-web-devicons",
  }) -- window for showing LSP detected issues in code

  -- {{ /LSP }}

  -- completion
  --[[ use({
    "hrsh7th/nvim-cmp",
    config = require("plugins.cmp").init,
    requires = {
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
  }) ]]

  -- autoclose parens, etc.
  use({ "windwp/nvim-autopairs" })

  -- look and feel of neovim
  -- colorscheme
  require("core.highlights") -- load before colorscheme cfg
  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
      vim.g.tokyonight_style = "night"

      vim.cmd([[colorscheme tokyonight]])
    end,
  })

  -- statusline
  use({
    "windwp/windline.nvim",
    config = function()
      require("plugins.statusline.windline")
    end,
  })

  -- adds current function/class/etc. name to statusline
  use({
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  -- indicate changed lines in gutter
  -- TODO: has mappings to stage chunks, other goodies. use.
  --
  use({
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup()
    end
  })

  -- better wild menu: e.g.: when you do `:e` and you want to navigate the completion popup
  -- currently funky.
  --[[ use({
    "gelguy/wilder.nvim",
    opt = true,
  }) ]]

  use({
    "Shatur/neovim-session-manager",
    disable = true,
    config = function()
      require("session_manager").setup({
        -- Define what to do when Neovim is started without arguments. Possible
        -- values: Disabled, CurrentDir, LastSession
        autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
        -- Automatically save last session on exit
        autosave_last_session = true,
      })
      require("telescope").load_extension("sessions")
    end,
  })

  -- {{ to investigate }}
  -- tpope/vim-repeat - allows `.` command to work w/ mappings
  -- jose-elias-alvarez/null-ls.nvim - lets you run shell cmds & send output to LSP which can then be read by nvim

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
