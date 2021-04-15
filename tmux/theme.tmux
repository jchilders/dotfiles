set -g @themepack 'powerline/default/purple'

set -g @themepack-status-left-area-middle-format " #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD | cut -c 1-30)"
set -g @themepack-status-right-area-middle-format "%a %b %d"
