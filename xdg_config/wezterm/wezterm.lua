local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

local default_font_family = "Monofur Nerd Font"
local default_font_size = 18.0

config.background = {
  {
    source = {
      File = "/Users/jchilders/Library/Mobile Documents/com~apple~CloudDocs/Wallpapers/zen circle.jpg"
    },
    hsb = {
      brightness = 0.025
    }
  }
}
config.color_scheme = "tokyonight"
config.colors = {
  background = "black",
  compose_cursor = "orange",
  tab_bar = {
    active_tab = {
      fg_color = "#ffffff",
      bg_color = "#700070",
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
  { key = "f", mods = "CTRL|CMD", action = "ToggleFullScreen" },
  { key = "o", mods = "SHIFT|CMD", action = "ShowTabNavigator" },
  { key = "%", mods = "LEADER", action = act.SplitHorizontal, },
  { key = "-", mods = "LEADER", action = act.SplitVertical, },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode, },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
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
      action = wezterm.action_callback(function(window, pane, line)
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
-- https://wezfurlong.org/wezterm/config/lua/MuxTab/panes_with_info.html?h=pane
-- tab:panes_with_info()

-- wezterm.action.ActivatePaneDirection 'Left'
-- wezterm.action.ActivatePaneByIndex(1)

-- wezterm.gui.screens() -- get list of screens

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find '/'
    local cwd = ''
    local hostname = ''
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find '[.]'
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash)

      table.insert(cells, cwd)
      if hostname ~= '' then
        table.insert(cells, hostname)
      end
    end
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M'
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#f0f0f0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

return config
