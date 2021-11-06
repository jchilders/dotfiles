alias ..='cd ..'
alias l='exa --all --classify --git --header --icons --long --no-permissions --no-user --color-scale'
alias tree='exa --tree'

# let man command work for both executables and builtins
alias man=run-help

alias python=/usr/local/bin/python3

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

abbr add be='bundle exec' > /dev/null 2>&1
abbr add bi='bundle install' > /dev/null 2>&1

alias cpwd="pwd | tr -d '\n' | pbcopy"

abbr add dcom='docker-compose' > /dev/null 2>&1

alias gcb="git branch --show-current | tr -d '\n' | pbcopy"
abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' > /dev/null 2>&1
abbr add muxi='tmuxinator' > /dev/null 2>&1

abbr add rdbm='bin/rake db:migrate' > /dev/null 2>&1
abbr add rdbms='bin/rake db:migrate:status' > /dev/null 2>&1
abbr add rdbmt='bin/rake db:migrate RAILS_ENV=test' > /dev/null 2>&1
abbr add rdbmst='bin/rake db:migrate:status RAILS_ENV=test'> /dev/null 2>&1

function rc() {
  if [[ -f bin/rails ]]; then
    bin/rails console
  elif [[ -f bin/console ]]; then
    bin/console
  else
    echo "No console found"
    return 1
  fi
}

function rs {
  # If $PORT is defined, then start rails with the -p param. Otherwise... don't.
  [[ -v PORT ]] && port_arg=("-p $PORT") || unset port_arg
  rails_cmd=("bin/rails server $port_arg")
  echo $rails_cmd
  eval $rails_cmd
}

# Change directory to source dir for given gem
function cdgem () {
  if [[ $# -eq 0 ]]; then
      echo "Usage: $0 <gem>"
      return 1
  fi

  cd $(gem open $1 -e echo)
}
