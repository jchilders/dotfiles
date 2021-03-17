#### COLOUR
set -g pane-border-style fg=colour23
set -g pane-active-border-style fg=colour119,bg=colour63

# set selection & window list colors
set-window-option -g mode-style fg=colour111,bg=colour237

tm_icon="♟"
tm_color_active=colour213
tm_color_inactive=colour241
tm_color_feature=colour85

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

# clock
set-window-option -g clock-mode-colour $tm_color_active

# set left status to e.g. "session1 current_path@branch"
tm_session_name="#[fg=$tm_color_feature,bold]$tm_icon"
set -g status-left "#{tm_session_name} #S #[fg=colour231]#{b:pane_current_path}#[fg=colour255]@#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)"
# set -g status-left "#{tm_session_name} #S #[fg=colour231]#(git rev-parse --show-toplevel)#[fg=colour256]@#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)"
# set -g status-left "#{tm_session_name} #S #[fg=colour231]#(git rev-parse --show-toplevel)#[fg=colour255]@#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)"

# set-option -g status-style bg=colour235,fg=colour63,dim
set -g status-justify centre           # center window list for clarity
set-window-option -g window-status-style fg=colour215,bg=colour63,dim
set-window-option -g window-status-current-style fg=colour15,bg=colour23,bright

tm_date="#[fg=$tm_color_inactive] %R %d %b"
tm_host="#[fg=$tm_color_feature,bold]#h"
set -g status-right $tm_date' '$tm_host
