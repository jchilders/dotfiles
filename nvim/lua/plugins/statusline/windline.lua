local windline = require("windline")
local helper = require("windline.helpers")
local b_components = require("windline.components.basic")
-- local animation = require("wlanimation")
-- local efffects = require("wlanimation.effects")
local state = _G.WindLine.state

local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")

--[[ local anim_colors = {
  "#90CAF9",
  "#64B5F6",
  "#42A5F5",
  "#2196F3",
  "#1E88E5",
  "#1976D2",
  "#1565C0",
  "#0D47A1",
} ]]

local hl_list = {
  Normal = { "NormalFg", "NormalBg" },
  Black = { "white", "black" },
  White = { "black", "white" },
  -- Inactive = { "InactiveFg", "InactiveBg" },
  Inactive = { "yellow", "red" },
  -- Active = { "ActiveFg", "ActiveBg" },
  Active = { "white", "green" },
}

local basic = {}

local breakpoint_width = 90
basic.divider = { b_components.divider, "" }
basic.bg = { "StatusLine", "StatusLineNC" }

local colors_mode = {
  Normal = { "blue", "green" },
  Insert = { "green", "transparent" },
  Visual = { "yellow", "transparent" },
  Replace = { "blue_light", "transparent" },
  Command = { "magenta", "transparent" },
}

local language_mode = {
  default = { "white", "black" },
  java = { "red", "black" },
  javascript = { "red", "black" },
  javascriptreact = { "red", "black" },
  lua = { "blue", "black" },
  magenta = { "magenta", "black" },
  python = { "blue", "black" },
  ruby = { "red", "black" },
  rust = { "orange", "black" },
  sh = { "white", "black" },
  typescript = { "blue", "black" },
  typescriptreact = { "blue", "black" },
  white = { "white", "black" },
  zsh = { "white", "black" },
}

basic.vi_mode = {
  name = "vi_mode",
  hl_colors = colors_mode,
  text = function()
    -- ⽔ (water)
    return { { " ⽔ ", state.mode[2] } }
  end,
}

basic.source_context = {
  name = "source_context",
  hl_colors = colors_mode,
  text = function()
    local gps = require("nvim-gps")

    if gps.is_available() then
      return {
        { gps.get_location(), "white" },
      }
    else
      return {
        { b_components.line_col, "white" },
        { b_components.progress, "" },
      }
    end
  end,
}

basic.lsp_diagnos = {
  name = "diagnostic",
  hl_colors = {
    red = { "red", "black" },
    yellow = { "yellow", "black" },
    blue = { "blue", "black" },
    trans = { "transparent", "transparent" },
    sep = { "black", "white" },
    spacer = { "black", "black" },
  },
  width = breakpoint_width,
  text = function()
    if lsp_comps.check_lsp() then
      return {
        { " ", "red" },
        {
          lsp_comps.lsp_error({
            format = " %s",
            show_zero = true,
          }),
          "red",
        },
        {
          lsp_comps.lsp_warning({
            format = "  %s",
            show_zero = true,
          }),
          "yellow",
        },
        {
          lsp_comps.lsp_hint({
            format = "  %s",
            show_zero = true,
          }),
          "blue",
        },
        { " ", "spacer" },
        { helper.separators.slant_right, "sep" },
      }
    end
    return ""
  end,
}

local icon_comp = b_components.cache_file_icon({
  default = "",
  hl_colors = { "white", "black" },
})

basic.file = {
  name = "file",
  hl_colors = language_mode,
  text = function(bufnr, _, width)
    -- local filetype = vim.bo.filetype
    -- local len = string.len(filetype)

    if width > breakpoint_width then
      return {
        icon_comp(bufnr),
        { " ", "" },
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
      }
    else
      return {
        { b_components.cache_file_size(), "default" },
        { " ", "" },
        { b_components.cache_file_name("[No Name]", ""), "magenta" },
        { " ", "" },
        { b_components.file_modified(" "), "magenta" },
      }
    end
  end,
}

basic.file_position = {
  hl_colors = {
    default = hl_list.Black,
    white = { "white", "black" },
    magenta = { "magenta", "black" },
  },
  text = function(_, _, width)
    if width < breakpoint_width then
      return {
        { b_components.line_col, "white" },
        { b_components.progress, "" },
      }
    end
  end,
}

basic.git = {
  name = "git",
  hl_colors = {
    green = { "green", "black_light" },
    red = { "red", "black_light" },
    blue = { "blue", "black_light" },
    trans = { "transparent", "transparent" },
    spacer = { "black_light", "black_light" },
    sep = { "black_light", "grey" },
    septwo = { "black_light", "black" },
  },
  width = breakpoint_width,
  text = function()
    if git_comps.is_git() then
      if packer_plugins["neomake"] == nil then
        return {
          { helper.separators.slant_left, "septwo" },
          { " ", "spacer" },
          {
            git_comps.diff_added({
              format = " %s",
              show_zero = true,
            }),
            "green",
          },
          {
            git_comps.diff_removed({
              format = "  %s",
              show_zero = true,
            }),
            "red",
          },
          {
            git_comps.diff_changed({
              format = " 柳%s",
              show_zero = true,
            }),
            "blue",
          },
        }
      end
    end
    if git_comps.is_git() then
      if packer_plugins["neomake"] ~= nil and packer_plugins["neomake"].loaded then
        return {
          { helper.separators.slant_left, "sep" },
          { " ", "spacer" },
          {
            git_comps.diff_added({
              format = " %s",
              show_zero = true,
            }),
            "green",
          },
          {
            git_comps.diff_removed({
              format = "  %s",
              show_zero = true,
            }),
            "red",
          },
          {
            git_comps.diff_changed({
              format = " 柳%s",
              show_zero = true,
            }),
            "blue",
          },
        }
      end
    end
    return ""
  end,
}

basic.lsp_names = {
  name = "lsp_names",
  hl_colors = {
    green = { "green", "black" },
    magenta = { "magenta", "black" },
    sep = { "black", "transparent" },
    sepdebug = { "black", "yellow" },
    spacer = { "black", "black" },
  },
  width = breakpoint_width,
  text = function()
    if lsp_comps.check_lsp() then
      return {
        {
          helper.separators.slant_left,
          "sep",
        },
        { " ", "spacer" },
        { lsp_comps.lsp_name(), "magenta" },
        { " ", "spacer" },
        { helper.separators.slant_left_thin, "magenta" },
      }
    end
    return ""
  end,
}

local default = {
  filetypes = { "default", "terminal" },
  active = {
    basic.vi_mode,
    basic.file,
    basic.source_context,
    basic.divider,
    basic.file_position,
    basic.lsp_names,
    basic.lsp_diagnos,
    { " ", { "black_light", "black_light" } },
  },
  show_last_status = true,
  inactive = {
    basic.vi_mode,
    basic.file,
    basic.divider,
    basic.git,
    { git_comps.git_branch(), { "magenta", "black" }, breakpoint_width },
    { " ", hl_list.Black },
  },
}

local quickfix = {
  filetypes = { "qf", "Trouble" },
  active = {
    { "🚦 Quickfix ", { "white", "black" } },
    { helper.separators.slant_right, { "black", "black_light" } },
    { " Total : %L ", { "cyan", "black_light" } },
    { helper.separators.slant_right, { "black_light", "transparent" } },
    { " ", { "InactiveFg", "transparent" } },
    basic.divider,
    { helper.separators.slant_left_2, { "black", "transparent" } },
    { "🧛 ", { "white", "black" } },
  },
  always_active = true,
}

windline.setup({
  colors_name = function(colors)
    -- print(vim.inspect(colors))
    -- ADD MORE COLOR HERE ----
    colors.FilenameFg = colors.white_light
    -- colors.FilenameBg = colors.black_light
    colors.FilenameBg = colors.magenta
    colors.transparent = "#38303f"
    colors.grey = "#3d3d3d"
    colors.orange = "#d8a657"

    return colors
  end,
  statuslines = {
    default,
    quickfix,
    -- repl,
    -- explorer,
    -- dashboard,
  },
})

--[[ animation.stop_all()

animation.animation({
  data = {
    { "waveright1", efffects.list_color(anim_colors, 2) },
    { "waveright2", efffects.list_color(anim_colors, 3) },
    { "waveright3", efffects.list_color(anim_colors, 4) },
    { "waveright4", efffects.list_color(anim_colors, 5) },
    { "waveright5", efffects.list_color(anim_colors, 6) },
    { "waveright6", efffects.list_color(anim_colors, 7) },
    { "waveright7", efffects.list_color(anim_colors, 8) },
    { "waveright8", efffects.list_color(anim_colors, 9) },
    { "waveright9", efffects.list_color(anim_colors, 10) },
  },
  timeout = nil,
  delay = 200,
  interval = 150,
})

local loading = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
animation.basic_animation({
  timeout = nil,
  delay = 200,
  interval = 150,
  effect = efffects.list_text(loading),
  on_tick = function(value)
    loading_text = value
  end,
}) ]]
