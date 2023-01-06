-- ??Problems??
-- :PackerInstall
-- :PackerClean
-- :PackerCompile
-- quit/reload
-- nvim --headless -c 'autocmd User PackerCompile quitall' -c 'PackerSync'
-- ~/bin/clean_nvim

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  autoremove = true,
  log = { level = 'info' },
  -- display = {
  --   open_fn = function()
  --     return require("packer.util").float({ border = "rounded" })
  --   end,
  -- },
})

return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  -- use "miversen33/import.nvim"
  -- require("import")

  -- {{ Tree-sitter treesitter }} --
  use({
    "nvim-treesitter/nvim-treesitter",
    config = require("plugins.nvim-treesitter").init(),
  })
  -- use "nvim-treesitter/nvim-treesitter-textobjects"

  -- Use `v.` in normal mode in treesitter-enabled buffer to visually select
  -- progressively broader TS nodes
  -- use "RRethy/nvim-treesitter-textsubjects"

  -- TSPlayground requires nightly build
  -- :TSPlaygroundToggle
  use({ "nvim-treesitter/playground" })

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

  -- harpoon lets you mark a small number of key files on a per-project basis,
  -- and quickly nav to them
  -- <leader>hl - list harpoons
  -- <leader>ha - add harpoon
  -- C-h/j/k/l - go to first/second/third/fourth harpoon
  use({
    "ThePrimeagen/harpoon",
    config = function()
      local harpoon = require("harpoon")

      harpoon.setup({
        global_settings = {
          enter_on_sendcmd = true,
        },
        projects = {
          -- Yes $HOME works
          --[[ ["$HOME/work/carerev/api_app"] = {
            term = {
              cmds = {
                "rails console"
              },
            },
          }, ]]
        },
      })
    end,
    requires = {
      { "nvim-lua/plenary.nvim" },
    }
  })

  -- comment code using directions or blocks. example:
  -- gc2j - comment current line and 2 down
  -- V2jgc - visually select current line & 2 down, then comment
  -- gcaf - with `af` mapped to treesitter `@function.outer`, comment out current function
  use({
    "b3nj5m1n/kommentary",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local konfig = require("kommentary.config")
      vim.keymap.set('i', '<C-k>', "<C-o><Plug>kommentary_line_default")

      konfig.configure_language("default", {
        use_consistent_indentation = true,
      })

      -- Always use single line comments for Lua
      konfig.configure_language("lua", {
        prefer_multi_line_comments = false,
        prefer_single_line_comments = true,
      })

      local filetypes = { "javascriptreact", "typescriptreact"}
      for _, filetype in pairs(filetypes) do
        konfig.configure_language(filetype, {
          single_line_comment_string = "auto",
          multi_line_comment_strings = "auto",
          hook_function = function()
            require("ts_context_commentstring.internal").update_commentstring()
          end,
        })
      end
    end,
  })

  -- Displays visual indicator of matching parenthesis, bracket, function
  -- `def`/`end`, etc.
  use({
    'andymass/vim-matchup',
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local ts_config = require('nvim-treesitter.configs')
      ts_config.setup({
        matchup = {
          enable = true,
        }
      })

      -- turn off updating statusline when match is outside of viewport
      vim.g.matchup_matchparen_offscreen = {}
    end
  })

  -- autoclose function defs, if statements, etc.
  -- :h lexima.vim
  use({
    "cohama/lexima.vim",
    config = function()
      vim.g.lexima_enable_basic_rules = 0 -- turn it off for quotes/parens/etc
    end,
  })

  -- ysw( - surround word with parens (`w` here is a text object)
  -- ds" - delete surrounding quotes
  -- cs"' - change surrounding double quotes with single quotes
  -- dsq - delete closest surrounding quote
  -- dss - delete closest surrounding whatever
  -- :h nvim-surround
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end
  })

  -- For splits, show filename in upper right of viewport
  -- :BuffertagToggle
  use({
    "ldelossa/buffertag",
    config = function()
      require('buffertag').setup()
    end
  })

  -- {{ LSP }}

  -- Manage LSPs, linters, DAP servers, formatters, etc.
  -- :Mason
  use({
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "solargraph", "sumneko_lua" }
      })
    end,
    requires = {
      { "williamboman/mason-lspconfig.nvim" },
      { "neovim/nvim-lspconfig" },
    }
  })

  -- LSP/completion/snippet all in one
  -- <C-d> - go to next placeholder in snippet
  -- <C-b> - go to previous placeholder in snippet
  use({
    "VonHeikemen/lsp-zero.nvim",
    requires = {
      -- LSP Support
      {"neovim/nvim-lspconfig"},
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},

      -- Autocompletion
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"saadparwaiz1/cmp_luasnip"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-nvim-lua"},

      -- Snippets
      {"L3MON4D3/LuaSnip"},
      {"rafamadriz/friendly-snippets"},
    },
    config = function()
      local lsp = require('lsp-zero')
      lsp.preset('recommended')

      lsp.setup_nvim_cmp({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp', keyword_length = 3 },
          { name = 'luasnip', keyword_length = 3 },
          {
            name = "buffer",
            sorting = {
              -- distance-based sorting
              comparators = {
                function(...)
                  local cmp_buffer = require('cmp_buffer')
                  return cmp_buffer:compare_locality(...)
                end,
              }
            },
            option = {
              -- get completion suggestions from all buffers, not just current one
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            }
          }
        },
      })

      lsp.setup() -- this needs to be last
    end
  })

  -- Show function signature as you type
  -- use({ "ray-x/lsp_signature.nvim", opt = false }) 

  use "kyazdani42/nvim-web-devicons"

  -- Add pictograms to completion window suggestion list
  use({
    "onsails/lspkind-nvim",
    config = require("plugins.lspkind-nvim").init,
  })

  -- colorschemes
  require("core.highlights") -- load before colorscheme cfg

  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.o.background = "dark" -- or light if you so prefer
      vim.g.tokyonight_style = "night"
    end,
  })

  use {'nyoom-engineering/oxocarbon.nvim'}

  use({
    'glepnir/zephyr-nvim',
    requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
  })

  -- statusline
  -- use({
   -- "windwp/windline.nvim",
   -- config = function()
   --   require("plugins.statusline.windline")
   -- end,
  -- })

  -- add current function/class/etc name to statusline
  -- deprecated
  -- use({
  --   "SmiteshP/nvim-gps",
  --   requires = "nvim-treesitter/nvim-treesitter",
  -- })

  -- add current function/class/etc name to statusline
  -- replacement for nvim-gps, but doesn't work with solargraph
  --[[ use({
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }) ]]

  -- indicate changed lines in gutter, as well as other git goodies
  use({
    'lewis6991/gitsigns.nvim',
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
        current_line_blame_formatter = '<author>::<author_time:%Y-%m-%d> - <summary>',
        on_attach = function(_)
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame)
        end
      })
    end
  })

  -- Delete buffers without affecting layout
  -- :Bdelete :Bdelete! :Bd!
  use "famiu/bufdelete.nvim"

  -- Automatically saves nvim session on exit, or loads the saved session on load
  -- :SaveSession :RestoreSession :DeleteSession
  use({
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_restore_enabled = true,
        auto_save_enabled = true,
      }
    end
  })

  -- Add documentation to a method/class/etc with a mapping.
  -- Currently set to `<leader>doc`
  -- use({
  --   "danymat/neogen",
  --   config = function()
  --     require('neogen').setup({})

  --     vim.keymap.set("n", "<leader>doc", "<cmd>lua require('neogen').generate()<CR>")
  --   end,
  --   requires = "nvim-treesitter/nvim-treesitter",
  --   -- Uncomment next line if you want to follow only stable versions
  --   -- tag = "*"
  -- })

  if BootstrapPacker then
    require('packer').sync()
  end
end)
