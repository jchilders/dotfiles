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
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n—\1\0\1\b\0\t\0\r6\1\0\0009\1\1\0019\1\2\0016\2\3\0'\4\4\0B\2\2\0029\2\5\2\18\3\2\0'\5\6\0'\6\a\0009\a\b\1B\3\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\19map_buffer_new\nutils\frequire\rgitsigns\vloaded\fpackageŠ\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\14virt_text\2\22ignore_whitespace\1\ndelay\3ô\3\18virt_text_pos\beol\1\0\2!current_line_blame_formatter1<author>, <author_time:%Y-%m-%d> - <summary>\23current_line_blame\1\nsetup\rgitsigns\frequire\0" },
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
    config = { "\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequireó\3\1\0\v\0\17\0&6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\0016\0\5\0006\2\0\0'\3\6\0B\0\3\2\15\0\0\0X\1\b€6\0\0\0'\2\a\0B\0\2\0029\0\b\0005\2\n\0005\3\t\0=\3\v\2B\0\2\0015\0\f\0006\1\r\0\18\3\0\0B\1\2\4H\4\t€6\6\0\0'\b\1\0B\6\2\0029\6\2\6\18\b\5\0005\t\14\0003\n\15\0=\n\16\tB\6\3\1F\4\3\3R\4õ\127K\0\1\0\18hook_function\0\1\0\2\31single_line_comment_string\tauto\31multi_line_comment_strings\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\26context_commentstring\1\0\0\1\0\2\venable\2\19enable_autocmd\1\nsetup\28nvim-treesitter.configs\20nvim-treesitter\npcall\1\0\2\31use_consistent_indentation\2\31prefer_multi_line_comments\1\fdefault\23configure_language\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
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
    config = { "\27LJ\2\n…\1\0\0\3\0\t\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0" },
    loaded = true,
    path = "/Users/jchilders/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\nš\1\0\0\4\0\t\0\r6\0\0\0009\0\1\0004\1\0\0=\1\2\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\2B\0\2\1K\0\1\0\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire!matchup_matchparen_offscreen\6g\bvim\0" },
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
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\22plugins.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: windline.nvim
time([[Config for windline.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31plugins.statusline.airline\frequire\0", "config", "windline.nvim")
time([[Config for windline.nvim]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\n…\1\0\0\3\0\t\0\r6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\4\0'\1\6\0=\1\5\0006\0\0\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\27colorscheme tokyonight\bcmd\nnight\21tokyonight_style\6g\tdark\15background\6o\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\n^\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequireó\3\1\0\v\0\17\0&6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\0016\0\5\0006\2\0\0'\3\6\0B\0\3\2\15\0\0\0X\1\b€6\0\0\0'\2\a\0B\0\2\0029\0\b\0005\2\n\0005\3\t\0=\3\v\2B\0\2\0015\0\f\0006\1\r\0\18\3\0\0B\1\2\4H\4\t€6\6\0\0'\b\1\0B\6\2\0029\6\2\6\18\b\5\0005\t\14\0003\n\15\0=\n\16\tB\6\3\1F\4\3\3R\4õ\127K\0\1\0\18hook_function\0\1\0\2\31single_line_comment_string\tauto\31multi_line_comment_strings\tauto\npairs\1\3\0\0\20javascriptreact\20typescriptreact\26context_commentstring\1\0\0\1\0\2\venable\2\19enable_autocmd\1\nsetup\28nvim-treesitter.configs\20nvim-treesitter\npcall\1\0\2\31use_consistent_indentation\2\31prefer_multi_line_comments\1\fdefault\23configure_language\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n—\1\0\1\b\0\t\0\r6\1\0\0009\1\1\0019\1\2\0016\2\3\0'\4\4\0B\2\2\0029\2\5\2\18\3\2\0'\5\6\0'\6\a\0009\a\b\1B\3\4\1K\0\1\0\30toggle_current_line_blame\15<leader>gb\6n\19map_buffer_new\nutils\frequire\rgitsigns\vloaded\fpackageŠ\2\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14on_attach\0\28current_line_blame_opts\1\0\4\14virt_text\2\22ignore_whitespace\1\ndelay\3ô\3\18virt_text_pos\beol\1\0\2!current_line_blame_formatter1<author>, <author_time:%Y-%m-%d> - <summary>\23current_line_blame\1\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\nš\1\0\0\4\0\t\0\r6\0\0\0009\0\1\0004\1\0\0=\1\2\0006\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\2B\0\2\1K\0\1\0\fmatchup\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire!matchup_matchparen_offscreen\6g\bvim\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
try_loadstring("\27LJ\2\nz\0\0\4\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\2B\0\2\1K\0\1\0\rprojects\20global_settings\1\0\0\1\0\1\21enter_on_sendcmd\2\nsetup\fharpoon\frequire\0", "config", "harpoon")
time([[Config for harpoon]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
