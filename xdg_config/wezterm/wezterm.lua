local wezterm = require("wezterm")
local act = wezterm.action

local default_font_size = 20.0
local default_font = {
  -- family = "Inconsolata Nerd Font",
  family = "Source Code Pro for Powerline",
  -- family = "SpaceMono Nerd Font",
  weight = 'Regular'
}
local tab_text_color = '#f0f0f0'

local config = {
  colors = {
    background = "black",
    compose_cursor = "orange",
  },
  font_size = default_font_size,
  font = wezterm.font(default_font),
  cell_width = 0.9,
  default_cursor_style = "BlinkingBlock",

  -- Dim inactive panes
  inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.3,
  },

  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1500 },

  max_fps = 120,
  native_macos_fullscreen_mode = false,
  scrollback_lines = 3500,
  show_new_tab_button_in_tab_bar = false,

  -- Defaults for the tab bar
  window_frame = {
    -- font = wezterm.font(default_font),
    font_size = default_font_size,
    active_titlebar_bg = "#300030",
  },
}

-- Split on startup
wezterm.on("gui-startup", function(cmd)
  local _, pane, window = wezterm.mux.spawn_window(cmd or {})
  pane:split({ direction = "Right" })
  window:gui_window():maximize()
end)

-- Set the tab's title to be the current directory, unless the title has
-- already been set via e.g. <leader>r
wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  -- If a tab title is already set, use that
  local new_title = tab.tab_title
  -- wezterm.log_info("new_title: ", new_title)
  if not new_title or #new_title == 0 then
    new_title = tab.active_pane.title
  else
    return new_title
  end

  local pane = tab.active_pane
  local cwd_url = pane.current_working_dir
  if (cwd_url ~= nil) then
    local path = cwd_url.path
    -- wezterm.log_info("1 path: ", cwd_url.path)
    local basename = string.gsub(path, '.*/([^/]+.)$', '%1')
    -- wezterm.log_info("1.1 basename: ", basename)
    new_title = basename .. "/"

    -- if path contains "temp" then prefix the tab name with "TEMP"
    -- Doing this b/c I frequently clone the same repo into ~/temp, but forget which
    -- I'm working in
    if string.find(cwd_url.path, "temp") then
      new_title = "(TEMP) " .. new_title
    end
  end
  -- wezterm.log_info("2 new_title: ", new_title)

  local zoomed = tab.active_pane.is_zoomed and "*" or ""
  new_title = zoomed .. new_title

  local curr_tab_text_color = tab.is_active and tab_text_color or "#808080"

  return {
    { Foreground = { AnsiColor = "Navy" } },
    { Text = (tab.tab_index + 1) .. " " },
    { Foreground = { Color = curr_tab_text_color } },
    { Text = new_title },
  }
end)

-- Create a new tab and split it horizontally
local function new_tab_with_horizontal_split(window, pane)
  window:perform_action(act.SpawnTab "CurrentPaneDomain", pane)
  window:perform_action(act.SplitHorizontal { domain = "CurrentPaneDomain" }, pane)
end

config.keys = {
  -- New tab with horizontal split
  { key = "t", mods = "CMD", action = wezterm.action_callback(new_tab_with_horizontal_split) },
  { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
  { key = "F", mods = "SHIFT|CMD", action = "ToggleFullScreen" },
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
