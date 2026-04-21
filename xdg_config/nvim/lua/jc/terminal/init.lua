local override = vim.g.jc_terminal_emulator
local term_program = (vim.env.TERM_PROGRAM or ""):lower()

local backend
if override == "ghostty" or term_program == "ghostty" then
  backend = require("jc.terminal.ghostty")
else
  backend = require("jc.terminal.wezterm")
end

local M = setmetatable({}, { __index = backend })

function M.send_left(text)  backend.send_text(text, "left")  end
function M.send_right(text) backend.send_text(text, "right") end
function M.send_up(text)    backend.send_text(text, "up")    end
function M.send_down(text)  backend.send_text(text, "down")  end

return M
