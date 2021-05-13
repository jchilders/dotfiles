local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback({
    "Fantasque Sans Mono",
    "PowerlineExtraSymbols",
    "Anonymice Nerd Font",
    "FontAwesome",
  }),
  font_size = 16.0,
  harfbuzz_features = {"calt=1", "clig=0", "liga=0"},
  keys = {
    { key = "f", mods="CTRL|CMD", action="ToggleFullScreen" },
    { key = "l", mods="SHIFT|CMD", action="ShowTabNavigator" },
    { key = "s", mods="SHIFT|CMD", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "z", mods="SHIFT|CMD", action="TogglePaneZoomState" },
    { key = "LeftArrow", mods="SHIFT|CMD", action=wezterm.action{ActivatePaneDirection="Left"}},
    { key = "RightArrow", mods="SHIFT|CMD", action=wezterm.action{ActivatePaneDirection="Right"}},
    { key = "UpArrow", mods="SHIFT|CMD", action=wezterm.action{ActivatePaneDirection="Up"}},
    { key = "DownArrow", mods="SHIFT|CMD", action=wezterm.action{ActivatePaneDirection="Down"}},
  },
}
