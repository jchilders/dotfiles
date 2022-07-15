-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/jchilders/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/jchilders/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/jchilders/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/jchilders/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/jchilders/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["auto-session"] = {
    config = { "\27LJ\2\ny\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22auto_save_enabled\2\25auto_restore_enabled\2\14log_level\tinfo\nsetup\17auto-session\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\ns\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\2\18close_command\rBdelete!\tmode\ttabs\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nÅ\1\0\1\a\0\t\0\v6\1\0\0009\1\1\0019\1\2\0016\2\3\0009\2\4\0029\2\5\2'\4\6\0'\5\a\0009\6\b\1B\2\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\bset\vkeymap\bvim\rgitsigns\vloaded\fpackageä\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\ndelay\3Ù\3\18virt_text_pos\beol\14virt_text\2\22ignore_whitespace\1\1\0\2\23current_line_blame\1!current_line_blame_formatter1<author>, <author_time:%Y-%m-%d> - <summary>\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    config = { "\27LJ\2\nz\0\0\4\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\2B\0\2\1K\0\1\0\rprojects\20global_settings\1\0\0\1\0\1\21enter_on_sendcmd\2\nsetup\fharpoon\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  kommentary = {
    config = { "\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequireÒ\4\1\0\f\0\25\0.6\0\0\0006\2\1\0'\3\2\0B\0\3\2\15\0\0\0X\1\bÄ6\0\1\0'\2\3\0B\0\2\0029\0\4\0005\2\6\0005\3\5\0=\3\a\2B\0\2\0016\0\1\0'\2\b\0B\0\2\0026\1\t\0009\1\n\0019\1\v\1'\3\f\0'\4\r\0'\5\14\0B\1\4\0019\1\15\0'\3\16\0005\4\17\0B\1\3\0019\1\15\0'\3\18\0005\4\19\0B\1\3\0015\1\20\0006\2\21\0\18\4\1\0B\2\2\4H\5\6Ä9\a\15\0\18\t\6\0005\n\22\0003\v\23\0=\v\24\nB\a\3\1F\5\3\3R\5¯\127K\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\1\0\2 prefer_single_line_comments\2\31prefer_multi_line_comments\1\blua\1\0\1\31use_consistent_indentation\2\fdefault\23configure_language'<C-o><Plug>kommentary_line_default\n<C-k>\6i\bset\vkeymap\bvim\22kommentary.config\26context_commentstring\1\0\0\1\0\2\venable\2\19enable_autocmd\1\nsetup\28nvim-treesitter.configs\20nvim-treesitter\frequire\npcall\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lexima.vim"] = {
    config = { "\27LJ\2\n;\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\30lexima_enable_basic_rules\6g\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lexima.vim",
    url = "https://github.com/cohama/lexima.vim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\nó\3\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\15symbol_map\1\0\25\rConstant\bÔ£æ\16Constructor\bÔê£\15EnumMember\bÔÖù\rFunction\bÔûî\vFolder\bÔùä\vMethod\bÔö¶\14Reference\bÔúÜ\tText\bÔùæ\tFile\bÔúò\vStruct\bÔ≠Ñ\nColor\bÔ£ó\nEvent\bÔÉß\fSnippet\bÔëè\rOperator\bÔöî\fKeyword\bÔ†ä\18TypeParameter\5\tEnum\bÔÖù\nValue\bÔ¢ü\tUnit\bÔ•¨\rProperty\bÔ∞†\vModule\bÔíá\14Interface\bÔÉ®\nClass\bÔ¥Ø\rVariable\bÔî™\nField\bÔ∞†\1\0\2\tmode\16symbol_text\vpreset\rcodicons\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  neogen = {
    config = { "\27LJ\2\nõ\1\0\0\5\0\t\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0B\0\4\1K\0\1\0.<cmd>lua require('neogen').generate()<CR>\16<leader>doc\6n\bset\vkeymap\bvim\nsetup\vneogen\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/neogen",
    url = "https://github.com/danymat/neogen"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nπ\1\0\2\5\1\b\0\15-\2\0\0009\2\1\0029\2\2\0029\3\0\0018\2\3\2'\3\3\0009\4\0\1&\2\4\2=\2\0\0015\2\5\0009\3\6\0009\3\a\0038\2\3\2=\2\4\1L\1\2\0\1¿\tname\vsource\1\0\5\tpath\v[Path]\rnvim_lua\n[Lua]\fluasnip\14[LuaSnip]\rnvim_lsp\n[LSP]\vbuffer\n[buf]\tmenu\6 \fdefault\fpresets\tkindC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireü\2\0\1\t\3\n\0--\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1#Ä-\1\1\0\15\0\1\0X\2\vÄ-\1\1\0009\1\2\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\3\1)\3ˇˇB\1\2\1X\1\21Ä-\1\2\0B\1\1\2\15\0\1\0X\2\15Ä6\1\4\0009\1\5\0019\1\6\0016\3\4\0009\3\5\0039\3\a\3'\5\b\0+\6\2\0+\a\2\0+\b\2\0B\3\5\2'\4\t\0+\5\2\0B\1\4\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\0¿\2¿\0\0\6n\f<s-tab>\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\tjump\rjumpable\21select_prev_item\fvisible˜\3\0\1\n\3\17\0H-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1>Ä-\1\1\0\15\0\1\0X\2\tÄ-\1\1\0009\1\2\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\3\1B\1\1\1X\0012Ä6\1\4\0009\1\5\0019\1\6\1\15\0\1\0X\2\24Ä6\1\a\0'\3\5\0B\1\2\2\n\1\0\0X\2(Ä9\2\b\1B\2\1\2\15\0\2\0X\3$Ä6\2\t\0009\2\n\0029\2\v\0026\4\t\0009\4\n\0049\4\f\4'\6\r\0+\a\2\0+\b\2\0+\t\2\0B\4\5\2'\5\14\0+\6\2\0B\2\4\1X\1\21Ä-\1\2\0B\1\1\2\15\0\1\0X\2\15Ä6\1\t\0009\1\n\0019\1\v\0016\3\t\0009\3\n\0039\3\f\3'\5\15\0+\6\2\0+\a\2\0+\b\2\0B\3\5\2'\4\16\0+\5\2\0B\1\4\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\0¿\2¿\0\0\6n\n<tab>\5/<cmd>lua require('neogen').jump_next()<CR>\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\rjumpable\frequire\vloaded\vneogen\19packer_plugins\19expand_or_jump\23expand_or_jumpable\21select_next_item\fvisibleg\0\1\3\1\5\1\0156\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\5Ä-\1\0\0009\1\3\1B\1\1\2\14\0\1\0X\2\3Ä-\1\0\0009\1\4\1B\1\1\2L\1\2\0\0¿\rcomplete\nclose\15pumvisible\afn\bvim\2.\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\19nvim_list_bufs\bapi\bvimÃ\a\1\0\f\1<\0o6\0\0\0009\0\1\0009\0\2\0\14\0\0\0X\0\4Ä6\0\3\0009\0\4\0'\2\5\0B\0\2\0016\0\6\0'\2\a\0B\0\2\0026\1\6\0'\3\b\0B\1\2\0026\2\6\0'\4\t\0B\2\2\0026\3\6\0'\5\n\0B\3\2\0029\3\v\3B\3\1\0019\3\f\0005\5\16\0005\6\14\0003\a\r\0=\a\15\6=\6\17\0055\6\19\0003\a\18\0=\a\20\6=\6\21\0055\6\22\0=\6\23\0055\6\27\0009\a\24\0003\t\25\0005\n\26\0B\a\3\2=\a\28\0069\a\24\0003\t\29\0005\n\30\0B\a\3\2=\a\31\0069\a\24\0009\a \a)\t¸ˇB\a\2\2=\a!\0069\a\24\0009\a \a)\t\4\0B\a\2\2=\a\"\0069\a\24\0003\t#\0B\a\2\2=\a$\0069\a\24\0009\a%\aB\a\1\2=\a&\0069\a\24\0009\a'\a5\t(\0B\a\2\2=\a)\6=\6\24\0054\6\5\0005\a*\0>\a\1\0065\a+\0>\a\2\0065\a,\0>\a\3\0065\a-\0005\b/\0003\t.\0=\t0\b=\b1\a>\a\4\6=\0062\5B\3\2\0019\3\f\0009\0033\3'\0054\0005\0066\0004\a\3\0005\b5\0>\b\1\a=\a2\6B\3\3\0019\3\f\0009\0033\3'\0057\0005\6;\0009\a8\0009\a2\a4\t\3\0005\n9\0>\n\1\t4\n\3\0005\v:\0>\v\1\nB\a\3\2=\a2\6B\3\3\0012\0\0ÄK\0\1\0\1¿\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\fsources\voption\15get_bufnrs\1\0\0\0\1\0\1\tname\vbuffer\1\0\1\tname\tpath\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nclose\14<C-Space>\0\n<C-f>\n<C-d>\16scroll_docs\n<Tab>\1\4\0\0\6i\6s\6c\0\f<S-Tab>\1\0\0\1\4\0\0\6i\6s\6c\0\fmapping\15completion\1\0\2\19keyword_length\3\1\16completeopt#menu,menuone,noselect,noinsert\fsnippet\vexpand\1\0\0\0\15formatting\1\0\0\vformat\1\0\0\0\nsetup\tinit\24plugins.cmp.luasnip\fluasnip\flspkind\bcmp\frequire\25packadd plenary.nvim\bcmd\bvim\vloaded\17plenary.nvim\19packer_plugins\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-gps"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-gps",
    url = "https://github.com/SmiteshP/nvim-gps"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\22plugins.lspconfig\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\nÖ\1\0\0\3\0\t\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\nö\1\0\0\4\0\t\0\r6\0\0\0009\0\1\0004\1\0\0=\1\2\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\2B\0\2\1K\0\1\0\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire!matchup_matchparen_offscreen\6g\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["windline.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.statusline.airline\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/windline.nvim",
    url = "https://github.com/windwp/windline.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: windline.nvim
time([[Config for windline.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.statusline.airline\frequire\0", "config", "windline.nvim")
time([[Config for windline.nvim]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequireÒ\4\1\0\f\0\25\0.6\0\0\0006\2\1\0'\3\2\0B\0\3\2\15\0\0\0X\1\bÄ6\0\1\0'\2\3\0B\0\2\0029\0\4\0005\2\6\0005\3\5\0=\3\a\2B\0\2\0016\0\1\0'\2\b\0B\0\2\0026\1\t\0009\1\n\0019\1\v\1'\3\f\0'\4\r\0'\5\14\0B\1\4\0019\1\15\0'\3\16\0005\4\17\0B\1\3\0019\1\15\0'\3\18\0005\4\19\0B\1\3\0015\1\20\0006\2\21\0\18\4\1\0B\2\2\4H\5\6Ä9\a\15\0\18\t\6\0005\n\22\0003\v\23\0=\v\24\nB\a\3\1F\5\3\3R\5¯\127K\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\1\0\2 prefer_single_line_comments\2\31prefer_multi_line_comments\1\blua\1\0\1\31use_consistent_indentation\2\fdefault\23configure_language'<C-o><Plug>kommentary_line_default\n<C-k>\6i\bset\vkeymap\bvim\22kommentary.config\26context_commentstring\1\0\0\1\0\2\venable\2\19enable_autocmd\1\nsetup\28nvim-treesitter.configs\20nvim-treesitter\frequire\npcall\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\nπ\1\0\2\5\1\b\0\15-\2\0\0009\2\1\0029\2\2\0029\3\0\0018\2\3\2'\3\3\0009\4\0\1&\2\4\2=\2\0\0015\2\5\0009\3\6\0009\3\a\0038\2\3\2=\2\4\1L\1\2\0\1¿\tname\vsource\1\0\5\tpath\v[Path]\rnvim_lua\n[Lua]\fluasnip\14[LuaSnip]\rnvim_lsp\n[LSP]\vbuffer\n[buf]\tmenu\6 \fdefault\fpresets\tkindC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequireü\2\0\1\t\3\n\0--\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1#Ä-\1\1\0\15\0\1\0X\2\vÄ-\1\1\0009\1\2\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\3\1)\3ˇˇB\1\2\1X\1\21Ä-\1\2\0B\1\1\2\15\0\1\0X\2\15Ä6\1\4\0009\1\5\0019\1\6\0016\3\4\0009\3\5\0039\3\a\3'\5\b\0+\6\2\0+\a\2\0+\b\2\0B\3\5\2'\4\t\0+\5\2\0B\1\4\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\0¿\2¿\0\0\6n\f<s-tab>\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\tjump\rjumpable\21select_prev_item\fvisible˜\3\0\1\n\3\17\0H-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1>Ä-\1\1\0\15\0\1\0X\2\tÄ-\1\1\0009\1\2\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\3\1B\1\1\1X\0012Ä6\1\4\0009\1\5\0019\1\6\1\15\0\1\0X\2\24Ä6\1\a\0'\3\5\0B\1\2\2\n\1\0\0X\2(Ä9\2\b\1B\2\1\2\15\0\2\0X\3$Ä6\2\t\0009\2\n\0029\2\v\0026\4\t\0009\4\n\0049\4\f\4'\6\r\0+\a\2\0+\b\2\0+\t\2\0B\4\5\2'\5\14\0+\6\2\0B\2\4\1X\1\21Ä-\1\2\0B\1\1\2\15\0\1\0X\2\15Ä6\1\t\0009\1\n\0019\1\v\0016\3\t\0009\3\n\0039\3\f\3'\5\15\0+\6\2\0+\a\2\0+\b\2\0B\3\5\2'\4\16\0+\5\2\0B\1\4\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\0¿\2¿\0\0\6n\n<tab>\5/<cmd>lua require('neogen').jump_next()<CR>\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\rjumpable\frequire\vloaded\vneogen\19packer_plugins\19expand_or_jump\23expand_or_jumpable\21select_next_item\fvisibleg\0\1\3\1\5\1\0156\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\5Ä-\1\0\0009\1\3\1B\1\1\2\14\0\1\0X\2\3Ä-\1\0\0009\1\4\1B\1\1\2L\1\2\0\0¿\rcomplete\nclose\15pumvisible\afn\bvim\2.\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\19nvim_list_bufs\bapi\bvimÃ\a\1\0\f\1<\0o6\0\0\0009\0\1\0009\0\2\0\14\0\0\0X\0\4Ä6\0\3\0009\0\4\0'\2\5\0B\0\2\0016\0\6\0'\2\a\0B\0\2\0026\1\6\0'\3\b\0B\1\2\0026\2\6\0'\4\t\0B\2\2\0026\3\6\0'\5\n\0B\3\2\0029\3\v\3B\3\1\0019\3\f\0005\5\16\0005\6\14\0003\a\r\0=\a\15\6=\6\17\0055\6\19\0003\a\18\0=\a\20\6=\6\21\0055\6\22\0=\6\23\0055\6\27\0009\a\24\0003\t\25\0005\n\26\0B\a\3\2=\a\28\0069\a\24\0003\t\29\0005\n\30\0B\a\3\2=\a\31\0069\a\24\0009\a \a)\t¸ˇB\a\2\2=\a!\0069\a\24\0009\a \a)\t\4\0B\a\2\2=\a\"\0069\a\24\0003\t#\0B\a\2\2=\a$\0069\a\24\0009\a%\aB\a\1\2=\a&\0069\a\24\0009\a'\a5\t(\0B\a\2\2=\a)\6=\6\24\0054\6\5\0005\a*\0>\a\1\0065\a+\0>\a\2\0065\a,\0>\a\3\0065\a-\0005\b/\0003\t.\0=\t0\b=\b1\a>\a\4\6=\0062\5B\3\2\0019\3\f\0009\0033\3'\0054\0005\0066\0004\a\3\0005\b5\0>\b\1\a=\a2\6B\3\3\0019\3\f\0009\0033\3'\0057\0005\6;\0009\a8\0009\a2\a4\t\3\0005\n9\0>\n\1\t4\n\3\0005\v:\0>\v\1\nB\a\3\2=\a2\6B\3\3\0012\0\0ÄK\0\1\0\1¿\1\0\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\vconfig\6:\1\0\0\1\0\1\tname\vbuffer\6/\fcmdline\fsources\voption\15get_bufnrs\1\0\0\0\1\0\1\tname\vbuffer\1\0\1\tname\tpath\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lsp\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nclose\14<C-Space>\0\n<C-f>\n<C-d>\16scroll_docs\n<Tab>\1\4\0\0\6i\6s\6c\0\f<S-Tab>\1\0\0\1\4\0\0\6i\6s\6c\0\fmapping\15completion\1\0\2\19keyword_length\3\1\16completeopt#menu,menuone,noselect,noinsert\fsnippet\vexpand\1\0\0\0\15formatting\1\0\0\vformat\1\0\0\0\nsetup\tinit\24plugins.cmp.luasnip\fluasnip\flspkind\bcmp\frequire\25packadd plenary.nvim\bcmd\bvim\vloaded\17plenary.nvim\19packer_plugins\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\22plugins.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: lexima.vim
time([[Config for lexima.vim]], true)
try_loadstring("\27LJ\2\n;\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\30lexima_enable_basic_rules\6g\bvim\0", "config", "lexima.vim")
time([[Config for lexima.vim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\nÖ\1\0\0\3\0\t\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
try_loadstring("\27LJ\2\nz\0\0\4\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\2B\0\2\1K\0\1\0\rprojects\20global_settings\1\0\0\1\0\1\21enter_on_sendcmd\2\nsetup\fharpoon\frequire\0", "config", "harpoon")
time([[Config for harpoon]], false)
-- Config for: neogen
time([[Config for neogen]], true)
try_loadstring("\27LJ\2\nõ\1\0\0\5\0\t\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0B\0\4\1K\0\1\0.<cmd>lua require('neogen').generate()<CR>\16<leader>doc\6n\bset\vkeymap\bvim\nsetup\vneogen\frequire\0", "config", "neogen")
time([[Config for neogen]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\nó\3\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\15symbol_map\1\0\25\rConstant\bÔ£æ\16Constructor\bÔê£\15EnumMember\bÔÖù\rFunction\bÔûî\vFolder\bÔùä\vMethod\bÔö¶\14Reference\bÔúÜ\tText\bÔùæ\tFile\bÔúò\vStruct\bÔ≠Ñ\nColor\bÔ£ó\nEvent\bÔÉß\fSnippet\bÔëè\rOperator\bÔöî\fKeyword\bÔ†ä\18TypeParameter\5\tEnum\bÔÖù\nValue\bÔ¢ü\tUnit\bÔ•¨\rProperty\bÔ∞†\vModule\bÔíá\14Interface\bÔÉ®\nClass\bÔ¥Ø\rVariable\bÔî™\nField\bÔ∞†\1\0\2\tmode\16symbol_text\vpreset\rcodicons\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nÅ\1\0\1\a\0\t\0\v6\1\0\0009\1\1\0019\1\2\0016\2\3\0009\2\4\0029\2\5\2'\4\6\0'\5\a\0009\6\b\1B\2\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\bset\vkeymap\bvim\rgitsigns\vloaded\fpackageä\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\ndelay\3Ù\3\18virt_text_pos\beol\14virt_text\2\22ignore_whitespace\1\1\0\2\23current_line_blame\1!current_line_blame_formatter1<author>, <author_time:%Y-%m-%d> - <summary>\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\ny\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22auto_save_enabled\2\25auto_restore_enabled\2\14log_level\tinfo\nsetup\17auto-session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\nö\1\0\0\4\0\t\0\r6\0\0\0009\0\1\0004\1\0\0=\1\2\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\2B\0\2\1K\0\1\0\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire!matchup_matchparen_offscreen\6g\bvim\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0", "config", "nvim-surround")
time([[Config for nvim-surround]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\ns\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\0\1\0\2\18close_command\rBdelete!\tmode\ttabs\nsetup\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
