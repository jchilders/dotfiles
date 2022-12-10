#!/usr/bin/env osascript

# tell application "Finder" to open POSIX file "/Users/jchilders/work/carerev/api_app/hello_world.pdf"
on run argv
  tell application "System Events" to tell process "Preview"
      set frontmost to true
  end tell
end
