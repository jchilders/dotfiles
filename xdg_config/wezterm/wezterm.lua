local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

local default_font_family = "Monofur Nerd Font"
local default_font_size = 20.0
local tab_text_color = '#f0f0f0'

config.font = wezterm.font(default_font_family)
config.font_size = default_font_size
config.colors = {
  background = "black",
  compose_cursor = "orange",
}

config.show_new_tab_button_in_tab_bar = false

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
  -- Return the explicitly set title, if one has been set
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end

  local cwd_url = tab.active_pane.current_working_dir
  cwd_url = cwd_url.path or ""
  local basename = string.gsub(cwd_url, '(.*[/\\])(.*)', '%2')
  local zoomed = tab.active_pane.is_zoomed and "*" or ""
  local tab_title = basename .. zoomed

  local curr_tab_text_color = tab.is_active and tab_text_color or "#808080"
  -- local active_tab_attr = tab.is_active and "Bold" or "Normal"

  return {
    { Foreground = { AnsiColor = "Navy" } },
    { Text = (tab.tab_index + 1) .. " " },
    { Foreground = { Color = curr_tab_text_color } },
    { Text = tab_title },
  }
end)

-- Defaults for the tab bar
config.window_frame = {
  font = wezterm.font { family = default_font_family },
  font_size = default_font_size,
  active_titlebar_bg = "#300030",
}

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

-- Mappings
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = {
  { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
  { key = "F", mods = "SHIFT|CMD",  action = "ToggleFullScreen" },
  { key = "H", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Left"), },
  { key = "L", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Right"), },
  { key = "K", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Up"), },
  { key = "J", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Down"), },
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  { key = "N", mods = "SHIFT|CMD", action = act.RotatePanes "Clockwise", },
  { key = "O", mods = "SHIFT|CMD", action = "ShowTabNavigator" },
  { key = "P", mods = "SHIFT|CMD", action = act.RotatePanes "CounterClockwise", },
  { key = "%", mods = "LEADER", action = act.SplitHorizontal, },
  { key = "-", mods = "LEADER", action = act.SplitVertical, },
  { key = "+", mods = "SHIFT|CMD", action = act.IncreaseFontSize, },
  { key = "-", mods = "SHIFT|CMD", action = act.DecreaseFontSize, },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode, },
  -- SHIFT-CMD-C :: opens wezterm debug overlay. used to test cfg changes
  { key = 'C', mods = 'SHIFT|CMD', action = wezterm.action.ShowDebugOverlay },
}

-- get info on panes for current tab
-- https://wezfurlong.org/wezterm/config/lua/MuxTab/panes_with_info.html
--
-- wezterm.action.ActivatePaneDirection 'Left'
-- wezterm.action.ActivatePaneByIndex(1)

-- wezterm.gui.screens() -- get list of screens

local function current_branch(_)
  local handle = io.popen('git rev-parse --abbrev-ref HEAD')
  if handle == nil then
    return "nill❓"
  end

  local result = handle:read("*a")
  handle:close()

  return string.gsub(result, "^%s*(.-)%s*$", "%1")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local colors = {
  '#3c1361',
  '#52307c',
  '#663a82',
  '#7c5295',
  '#b491c8',
}

wezterm.on('update-status', function(window, pane)
  local cells = {}
  table.insert(cells, { Background = { Color = '#200020' } })
  table.insert(cells, { Foreground = { Color = colors[1] } })
  table.insert(cells, { Text = SOLID_LEFT_ARROW })
  table.insert(cells, { Background = { Color = colors[1] } })
  table.insert(cells, { Foreground = { Color = tab_text_color } })
  table.insert(cells, { Text = " " .. current_branch(pane) .. " " })

  window:set_right_status(wezterm.format(cells))
end)

return config
