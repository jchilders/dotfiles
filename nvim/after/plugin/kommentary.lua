-- kommentary - code commenting

local config = require('kommentary.config')

config.configure_language("javascriptreact", {
  multi_line_comment_strings = {"{/*", "*/}"},
})
