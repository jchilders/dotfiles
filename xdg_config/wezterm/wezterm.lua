local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

local default_font_family = "Monofur Nerd Font"
local default_font_size = 18.0
local tab_text_color = '#f0f0f0'

config.font = wezterm.font(default_font_family)
config.font_size = default_font_size
config.colors = {
  background = "black",
  compose_cursor = "orange",
}

config.show_new_tab_button_in_tab_bar = false

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  -- Return the explicitly set title, if one has been set
  if tab.tab_title and #tab.tab_title > 0 then
    return tab.tab_title
  end

  local cwd_uri = tab.active_pane.current_working_dir
  local basename = string.gsub(cwd_uri, '(.*[/\\])(.*)', '%2')
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
  saturation = 0.8,
  brightness = 0.3,
}

-- Mappings
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
  { key = "F", mods = "CMD",  action = "ToggleFullScreen" },
  { key = "H", mods = "CMD", action = act.ActivatePaneDirection("Left"), },
  { key = "L", mods = "CMD", action = act.ActivatePaneDirection("Right"), },
  { key = "K", mods = "CMD", action = act.ActivatePaneDirection("Up"), },
  { key = "J", mods = "CMD", action = act.ActivatePaneDirection("Down"), },
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
  { key = "N", mods = "CMD", action = act.RotatePanes "Clockwise", },
  { key = "O", mods = "CMD", action = "ShowTabNavigator" },
  { key = "P", mods = "CMD", action = act.RotatePanes "CounterClockwise", },
  { key = "%", mods = "LEADER",    action = act.SplitHorizontal, },
  { key = "+", mods = "CMD", action = act.IncreaseFontSize, },
  { key = "-", mods = "LEADER",    action = act.SplitVertical, },
  { key = "[", mods = "LEADER",    action = act.ActivateCopyMode, },
}

-- CTRL-SHIFT-L :: opens wezterm debug overlay. can type lua cmds here

-- get info on panes for current tab
-- https://wezfurlong.org/wezterm/config/lua/MuxTab/panes_with_info.html

-- wezterm.action.ActivatePaneDirection 'Left'
-- wezterm.action.ActivatePaneByIndex(1)

-- wezterm.gui.screens() -- get list of screens

local function current_branch(pane)
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri == nil then
    return " ⊘"
  end
  local cwd = cwd_uri.gsub(cwd_uri, '^file://(.*)', '%1')
  local success, stdout, _ = wezterm.run_child_process({
    'git',
    '-C',
    cwd,
    'branch',
    '--show-current'
  })
  local git_branch = success and string.format(" %s", string.gsub(stdout, "^(.+)\n$", "%1")) or " ❓"

  return git_branch
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
