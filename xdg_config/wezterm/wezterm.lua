local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

local default_font_family = "Monofur Nerd Font"
local default_font_size = 18.0

-- Foreground color for tab & status text
local tab_text_color = '#f0f0f0'
local tab_bg = '#700070'

config.color_scheme = "tokyonight"
config.colors = {
  background = "black",
  compose_cursor = "orange",
  tab_bar = {
    active_tab = {
      fg_color = tab_text_color,
      bg_color = tab_bg,
      intensity = "Bold",
    }
  }
}

config.cursor_blink_rate = 800
config.cursor_blink_ease_in = "Linear"

config.window_frame = {
  -- The font used in the tab bar.
  font = wezterm.font { family = default_font_family, weight = "Bold" },

  -- The size of the font in the tab bar.
  font_size = default_font_size,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = "#200020",
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.3,
}

config.font = wezterm.font(default_font_family, { weight = 'Bold' })
config.font_size = default_font_size

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = "f", mods = "CTRL|CMD",  action = "ToggleFullScreen" },
  { key = "o", mods = "SHIFT|CMD", action = "ShowTabNavigator" },
  { key = "%", mods = "LEADER",    action = act.SplitHorizontal, },
  { key = "-", mods = "LEADER",    action = act.SplitVertical, },
  { key = "[", mods = "LEADER",    action = act.ActivateCopyMode, },
  { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
  { key = "h", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Left"), },
  { key = "l", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Right"), },
  { key = "k", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Up"), },
  { key = "j", mods = "SHIFT|CMD", action = act.ActivatePaneDirection("Down"), },
  { key = "=", mods = "SHIFT|CMD", action = act.IncreaseFontSize, },
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  { key = "N", mods = "SHIFT|CMD", action = act.RotatePanes "Clockwise", },
  { key = "P", mods = "SHIFT|CMD", action = act.RotatePanes "CounterClockwise", },
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

-- Background colors for right status text
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

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local function _basename(tab2)
    local pane = tab2.active_pane
    local uri = pane.current_working_dir
    local basename = string.gsub(uri, '(.*[/\\])(.*)', '%2')
    return basename
  end

  local tab_title = string.format("%s", _basename(tab))

  return {
    { Text = tab_title }
  }
end)

return config
