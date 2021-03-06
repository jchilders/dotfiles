alias ..='cd ..'
alias l='exa --all --classify --git --header --icons --long --no-permissions --no-user --color-scale'
alias tree='exa --tree'

alias python=/usr/local/bin/python3

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

abbr add bi='bundle install' > /dev/null 2>&1
abbr add cpwd='pwd | pbcopy' > /dev/null 2>&1
abbr add dcom='docker-compose' > /dev/null 2>&1

alias gcb="git branch --show-current | tr -d '\n' | pbcopy"
abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' --force > /dev/null 2>&1
abbr icat="wezterm imgcat " > /dev/null 2>&1
abbr add muxi='tmuxinator' > /dev/null 2>&1

abbr add rc='bin/rails console' --force> /dev/null 2>&1
abbr add rdbm='bin/rake db:migrate' > /dev/null 2>&1
abbr add rdbms='bin/rake db:migrate:status' > /dev/null 2>&1
abbr add rdbmt='bin/rake db:migrate RAILS_ENV=test' > /dev/null 2>&1
abbr add rdbmst='bin/rake db:migrate:status RAILS_ENV=test'> /dev/null 2>&1

# Some (older) versions of Rails -- like the one I'm currently working with --
# do not pick up changes to controllers and force you to restart the server.
# This automates that. 
function rs {
  # If $PORT is defined, then start rails with the -p param. Otherwise... don't.
  [[ -v PORT ]] && port_arg=("-p $PORT") || unset port_arg
  watch_cmd=("watchexec --restart --watch 'app/controllers'")
  rails_cmd=("'bin/rails server $port_arg'")
  echo $watch_cmd $rails_cmd
  eval $watch_cmd $rails_cmd
}
