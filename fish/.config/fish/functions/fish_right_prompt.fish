# Defined in /var/folders/9m/1d95x8t52qn38sp9v8k_yg380000gn/T//fish.maq16i/fish_right_prompt.fish @ line 2
# Did this to turn off the right aligned clock
function fish_right_prompt
  set_color $fish_color_autosuggestion ^/dev/null; or set_color 555
  # date "+%H:%M:%S"
  # set_color normal
end
