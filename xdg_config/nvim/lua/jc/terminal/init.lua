local override = vim.g.jc_terminal_emulator
local term_program = (vim.env.TERM_PROGRAM or ""):lower()

if override == "ghostty" or term_program == "ghostty" then
  return require("jc.terminal.ghostty")
end

return require("jc.terminal.wezterm")
