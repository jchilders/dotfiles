function fish_user_key_bindings
  # ctrl-c: Clear current line
  bind -M insert \cc kill-whole-line force-repaint

  # ctrl-r: zsh-like history search
  # https://github.com/jbonjean/re-search
  bind -M insert \cr re_search
end
