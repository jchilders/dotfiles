local wezterm = require("wezterm")

local function font_with_fallback(name, params)
  local names = {
    name,
    "Fantasque Sans Mono",
    "Inconsolata",
    "PowerlineExtraSymbols",
    "Anonymice Nerd Font",
    "FontAwesome",
  }
  return wezterm.font_with_fallback(names, params)
end

return {
  font = wezterm.font_with_fallback({
    "Fantasque Sans Mono",
    "Inconsolata",
    "PowerlineExtraSymbols",
    "Anonymice Nerd Font",
    "FontAwesome",
  }),
  font_size = 18.0,
  font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = font_with_fallback("Fantasque Sans Mono", { italic = true, weight = "Regular" }),
    },
    {
      intensity = "Bold",
      italic = false,
      font = font_with_fallback("Fantasque Sans Mono", { italic = false, weight = "Bold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = font_with_fallback("Fantasque Sans Mono", { italic = true, weight = "Bold" }),
    },
  },
  line_height = 1.1,
  keys = {
    { key = "f", mods = "CTRL|CMD", action = "ToggleFullScreen" },
    { key = "l", mods = "SHIFT|CMD", action = "ShowTabNavigator" },
    {
      key = "s",
      mods = "SHIFT|CMD",
      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    { key = "z", mods = "SHIFT|CMD", action = "TogglePaneZoomState" },
    {
      key = "LeftArrow",
      mods = "SHIFT|CMD",
      action = wezterm.action({
        ActivatePaneDirection = "Left",
      }),
    },
    {
      key = "RightArrow",
      mods = "SHIFT|CMD",
      action = wezterm.action({
        ActivatePaneDirection = "Right",
      }),
    },
    {
      key = "UpArrow",
      mods = "SHIFT|CMD",
      action = wezterm.action({ ActivatePaneDirection = "Up" }),
    },
    {
      key = "DownArrow",
      mods = "SHIFT|CMD",
      action = wezterm.action({ ActivatePaneDirection = "Down" }),
    },
  },
}
