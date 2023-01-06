-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

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
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

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
    config = { "\27LJ\2\nz\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22auto_save_enabled\2\25auto_restore_enabled\2\14log_level\nerror\nsetup\17auto-session\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/auto-session",
    url = "https://github.com/rmagatti/auto-session"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  buffertag = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14buffertag\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/buffertag",
    url = "https://github.com/ldelossa/buffertag"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
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
    config = { "\27LJ\2\n�\1\0\1\a\0\t\0\v6\1\0\0009\1\1\0019\1\2\0016\2\3\0009\2\4\0029\2\5\2'\4\6\0'\5\a\0009\6\b\1B\2\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\bset\vkeymap\bvim\rgitsigns\vloaded\fpackage�\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\14virt_text\2\18virt_text_pos\beol\ndelay\3�\3\22ignore_whitespace\1\1\0\2!current_line_blame_formatter1<author>::<author_time:%Y-%m-%d> - <summary>\23current_line_blame\1\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    config = { "\27LJ\2\nz\0\0\5\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0034\4\0\0=\4\6\3B\1\2\1K\0\1\0\rprojects\20global_settings\1\0\0\1\0\1\21enter_on_sendcmd\2\nsetup\fharpoon\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  kommentary = {
    config = { "\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequire�\3\1\0\f\0\18\0 6\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\0019\1\4\1'\3\5\0'\4\6\0'\5\a\0B\1\4\0019\1\b\0'\3\t\0005\4\n\0B\1\3\0019\1\b\0'\3\v\0005\4\f\0B\1\3\0015\1\r\0006\2\14\0\18\4\1\0B\2\2\4H\5\6�9\a\b\0\18\t\6\0005\n\15\0003\v\16\0=\v\17\nB\a\3\1F\5\3\3R\5�\127K\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\1\0\2 prefer_single_line_comments\2\31prefer_multi_line_comments\1\blua\1\0\1\31use_consistent_indentation\2\fdefault\23configure_language'<C-o><Plug>kommentary_line_default\n<C-k>\6i\bset\vkeymap\bvim\22kommentary.config\frequire\0" },
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
  ["lsp-zero.nvim"] = {
    config = { "\27LJ\2\nG\2\0\5\0\3\0\a6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0G\4\0\0C\1\1\0\21compare_locality\15cmp_buffer\frequire.\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\19nvim_list_bufs\bapi\bvim�\2\1\0\t\0\20\0 6\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\0019\1\4\0005\3\17\0004\4\5\0005\5\5\0>\5\1\0045\5\6\0>\5\2\0045\5\a\0>\5\3\0045\5\b\0005\6\n\0004\a\3\0003\b\t\0>\b\1\a=\a\v\6=\6\f\0055\6\14\0003\a\r\0=\a\15\6=\6\16\5>\5\4\4=\4\18\3B\1\2\0019\1\19\0B\1\1\1K\0\1\0\nsetup\fsources\1\0\0\voption\15get_bufnrs\1\0\0\0\fsorting\16comparators\1\0\0\0\1\0\1\tname\vbuffer\1\0\2\tname\fluasnip\19keyword_length\3\3\1\0\2\tname\rnvim_lsp\19keyword_length\3\3\1\0\1\tname\tpath\19setup_nvim_cmp\16recommended\vpreset\rlsp-zero\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n�\3\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\15symbol_map\1\0\25\tFile\b\rConstant\b\nColor\b\fKeyword\b\fSnippet\b\vStruct\bפּ\nEvent\b\tEnum\b\rOperator\b\nValue\b\tUnit\b塞\rProperty\bﰠ\vModule\b\14Interface\b\rFunction\b\nClass\bﴯ\18TypeParameter\5\rVariable\b\nField\bﰠ\16Constructor\b\15EnumMember\b\vMethod\b\vFolder\b\tText\b\14Reference\b\1\0\2\vpreset\rcodicons\tmode\16symbol_text\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    config = { "\27LJ\2\n�\1\0\0\4\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\5\0005\3\4\0=\3\6\2B\0\2\1K\0\1\0\21ensure_installed\1\0\0\1\3\0\0\15solargraph\16sumneko_lua\20mason-lspconfig\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["oxocarbon.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/oxocarbon.nvim",
    url = "https://github.com/nyoom-engineering/oxocarbon.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
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
    config = { "\27LJ\2\n/\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\16:normal! zx\bcmd\bvimM\1\1\6\1\5\0\v-\1\0\0009\1\0\1\18\3\1\0009\1\1\0015\4\3\0003\5\2\0=\5\4\4B\1\3\1+\1\2\0002\0\0�L\1\2\0\2�\tpost\1\0\0\0\fenhance\vselect�\n\1\0\n\0008\0e6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\0\0009\0\1\0'\2\4\0B\0\2\0016\0\5\0'\2\6\0B\0\2\0026\1\5\0'\3\a\0B\1\2\0026\2\5\0'\4\b\0B\2\2\0029\3\t\0005\5\15\0005\6\r\0005\a\n\0003\b\v\0=\b\f\a=\a\14\6=\6\16\0055\6\17\0006\a\5\0'\t\18\0B\a\2\0029\a\19\a=\a\20\0065\a\21\0=\a\22\0066\a\5\0'\t\18\0B\a\2\0029\a\23\a=\a\24\0064\a\0\0=\a\25\0065\a\26\0=\a\27\0065\a\28\0=\a\29\0066\a\5\0'\t\30\0B\a\2\0029\a\31\a9\a \a=\a!\0066\a\5\0'\t\30\0B\a\2\0029\a\"\a9\a \a=\a#\0066\a\5\0'\t\30\0B\a\2\0029\a$\a9\a \a=\a%\0066\a\5\0'\t\30\0B\a\2\0029\a&\a=\a&\0065\a*\0005\b(\0009\t'\1=\t)\b=\b+\a=\a,\6=\6-\0055\6/\0005\a.\0=\a0\0065\a1\0004\b\0\0=\b2\a=\a3\6=\0064\5B\3\2\0019\0035\0'\0050\0B\3\2\0019\0035\0'\0053\0B\3\2\0019\0035\0'\0056\0B\3\2\0019\0035\0'\0057\0B\3\2\0012\0\0�K\0\1\0\16file_create\rdotfiles\19load_extension\15extensions\fproject\14base_dirs\1\0\2\17hidden_files\2\14max_depth\3\4\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\rdefaults\rmappings\6i\1\0\0\n<esc>\1\0\0\nclose\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\3\0\0\n.git/\17node_modules\16file_sorter\23get_generic_sorter\22telescope.sorters\1\0\n\18prompt_prefix\t⦕ \14previewer\1\ruse_less\2\19color_devicons\2\20layout_strategy\15horizontal\21sorting_strategy\15descending\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\a  \20selection_caret\t⪢ \fpickers\1\0\0\15find_files\1\0\0\20attach_mappings\0\1\0\1\vhidden\2\nsetup\26telescope.actions.set\22telescope.actions\14telescope\frequire&packadd telescope-fzf-native.nvim#packadd telescope-project.nvim\25packadd plenary.nvim\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\2\0\a\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0K\0\1\0\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\n�\1\0\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3B\1\2\0016\1\6\0009\1\a\0014\2\0\0=\2\b\1K\0\1\0!matchup_matchparen_offscreen\6g\bvim\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["zephyr-nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/zephyr-nvim",
    url = "https://github.com/glepnir/zephyr-nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3B\1\2\0016\1\6\0009\1\a\0014\2\0\0=\2\b\1K\0\1\0!matchup_matchparen_offscreen\6g\bvim\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\nZ\0\0\2\0\a\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0K\0\1\0\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n�\3\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\15symbol_map\1\0\25\tFile\b\rConstant\b\nColor\b\fKeyword\b\fSnippet\b\vStruct\bפּ\nEvent\b\tEnum\b\rOperator\b\nValue\b\tUnit\b塞\rProperty\bﰠ\vModule\b\14Interface\b\rFunction\b\nClass\bﴯ\18TypeParameter\5\rVariable\b\nField\bﰠ\16Constructor\b\15EnumMember\b\vMethod\b\vFolder\b\tText\b\14Reference\b\1\0\2\vpreset\rcodicons\tmode\16symbol_text\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: lsp-zero.nvim
time([[Config for lsp-zero.nvim]], true)
try_loadstring("\27LJ\2\nG\2\0\5\0\3\0\a6\0\0\0'\2\1\0B\0\2\2\18\3\0\0009\1\2\0G\4\0\0C\1\1\0\21compare_locality\15cmp_buffer\frequire.\0\0\2\0\3\0\0046\0\0\0009\0\1\0009\0\2\0D\0\1\0\19nvim_list_bufs\bapi\bvim�\2\1\0\t\0\20\0 6\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\0019\1\4\0005\3\17\0004\4\5\0005\5\5\0>\5\1\0045\5\6\0>\5\2\0045\5\a\0>\5\3\0045\5\b\0005\6\n\0004\a\3\0003\b\t\0>\b\1\a=\a\v\6=\6\f\0055\6\14\0003\a\r\0=\a\15\6=\6\16\5>\5\4\4=\4\18\3B\1\2\0019\1\19\0B\1\1\1K\0\1\0\nsetup\fsources\1\0\0\voption\15get_bufnrs\1\0\0\0\fsorting\16comparators\1\0\0\0\1\0\1\tname\vbuffer\1\0\2\tname\fluasnip\19keyword_length\3\3\1\0\2\tname\rnvim_lsp\19keyword_length\3\3\1\0\1\tname\tpath\19setup_nvim_cmp\16recommended\vpreset\rlsp-zero\frequire\0", "config", "lsp-zero.nvim")
time([[Config for lsp-zero.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\1\a\0\t\0\v6\1\0\0009\1\1\0019\1\2\0016\2\3\0009\2\4\0029\2\5\2'\4\6\0'\5\a\0009\6\b\1B\2\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\bset\vkeymap\bvim\rgitsigns\vloaded\fpackage�\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\14virt_text\2\18virt_text_pos\beol\ndelay\3�\3\22ignore_whitespace\1\1\0\2!current_line_blame_formatter1<author>::<author_time:%Y-%m-%d> - <summary>\23current_line_blame\1\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: buffertag
time([[Config for buffertag]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14buffertag\frequire\0", "config", "buffertag")
time([[Config for buffertag]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n�\1\0\0\4\0\a\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\5\0005\3\4\0=\3\6\2B\0\2\1K\0\1\0\21ensure_installed\1\0\0\1\3\0\0\15solargraph\16sumneko_lua\20mason-lspconfig\nsetup\nmason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
try_loadstring("\27LJ\2\nz\0\0\5\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\0034\4\0\0=\4\6\3B\1\2\1K\0\1\0\rprojects\20global_settings\1\0\0\1\0\1\21enter_on_sendcmd\2\nsetup\fharpoon\frequire\0", "config", "harpoon")
time([[Config for harpoon]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\16:normal! zx\bcmd\bvimM\1\1\6\1\5\0\v-\1\0\0009\1\0\1\18\3\1\0009\1\1\0015\4\3\0003\5\2\0=\5\4\4B\1\3\1+\1\2\0002\0\0�L\1\2\0\2�\tpost\1\0\0\0\fenhance\vselect�\n\1\0\n\0008\0e6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\0\0009\0\1\0'\2\4\0B\0\2\0016\0\5\0'\2\6\0B\0\2\0026\1\5\0'\3\a\0B\1\2\0026\2\5\0'\4\b\0B\2\2\0029\3\t\0005\5\15\0005\6\r\0005\a\n\0003\b\v\0=\b\f\a=\a\14\6=\6\16\0055\6\17\0006\a\5\0'\t\18\0B\a\2\0029\a\19\a=\a\20\0065\a\21\0=\a\22\0066\a\5\0'\t\18\0B\a\2\0029\a\23\a=\a\24\0064\a\0\0=\a\25\0065\a\26\0=\a\27\0065\a\28\0=\a\29\0066\a\5\0'\t\30\0B\a\2\0029\a\31\a9\a \a=\a!\0066\a\5\0'\t\30\0B\a\2\0029\a\"\a9\a \a=\a#\0066\a\5\0'\t\30\0B\a\2\0029\a$\a9\a \a=\a%\0066\a\5\0'\t\30\0B\a\2\0029\a&\a=\a&\0065\a*\0005\b(\0009\t'\1=\t)\b=\b+\a=\a,\6=\6-\0055\6/\0005\a.\0=\a0\0065\a1\0004\b\0\0=\b2\a=\a3\6=\0064\5B\3\2\0019\0035\0'\0050\0B\3\2\0019\0035\0'\0053\0B\3\2\0019\0035\0'\0056\0B\3\2\0019\0035\0'\0057\0B\3\2\0012\0\0�K\0\1\0\16file_create\rdotfiles\19load_extension\15extensions\fproject\14base_dirs\1\0\2\17hidden_files\2\14max_depth\3\4\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\rdefaults\rmappings\6i\1\0\0\n<esc>\1\0\0\nclose\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\16borderchars\1\t\0\0\b─\b│\b─\b│\b╭\b╮\b╯\b╰\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\1\3\0\0\n.git/\17node_modules\16file_sorter\23get_generic_sorter\22telescope.sorters\1\0\n\18prompt_prefix\t⦕ \14previewer\1\ruse_less\2\19color_devicons\2\20layout_strategy\15horizontal\21sorting_strategy\15descending\23selection_strategy\nreset\17initial_mode\vinsert\17entry_prefix\a  \20selection_caret\t⪢ \fpickers\1\0\0\15find_files\1\0\0\20attach_mappings\0\1\0\1\vhidden\2\nsetup\26telescope.actions.set\22telescope.actions\14telescope\frequire&packadd telescope-fzf-native.nvim#packadd telescope-project.nvim\25packadd plenary.nvim\bcmd\bvim\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: auto-session
time([[Config for auto-session]], true)
try_loadstring("\27LJ\2\nz\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\22auto_save_enabled\2\25auto_restore_enabled\2\14log_level\nerror\nsetup\17auto-session\frequire\0", "config", "auto-session")
time([[Config for auto-session]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18nvim-surround\frequire\0", "config", "nvim-surround")
time([[Config for nvim-surround]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequire�\3\1\0\f\0\18\0 6\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\0019\1\4\1'\3\5\0'\4\6\0'\5\a\0B\1\4\0019\1\b\0'\3\t\0005\4\n\0B\1\3\0019\1\b\0'\3\v\0005\4\f\0B\1\3\0015\1\r\0006\2\14\0\18\4\1\0B\2\2\4H\5\6�9\a\b\0\18\t\6\0005\n\15\0003\v\16\0=\v\17\nB\a\3\1F\5\3\3R\5�\127K\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\1\0\2 prefer_single_line_comments\2\31prefer_multi_line_comments\1\blua\1\0\1\31use_consistent_indentation\2\fdefault\23configure_language'<C-o><Plug>kommentary_line_default\n<C-k>\6i\bset\vkeymap\bvim\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: lexima.vim
time([[Config for lexima.vim]], true)
try_loadstring("\27LJ\2\n;\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\0\0=\1\2\0K\0\1\0\30lexima_enable_basic_rules\6g\bvim\0", "config", "lexima.vim")
time([[Config for lexima.vim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
