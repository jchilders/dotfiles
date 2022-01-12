alias ..='cd ..'
alias ...='cd ../..'
alias diff='delta' # viewer for `git diff` and `diff`
alias l='exa --all --classify --git --header --icons --long --no-permissions --no-user --color-scale'
alias tree='exa --tree'

if alias -L run-help > /dev/null; then
  unalias run-help
fi
autoload run-help
export MANPAGER='nvim +Man!'
export HELPDIR=/usr/share/zsh/$(zsh --version | ruby -ane 'puts $F[1]')/help

# override the `man` command so that it can show both help pages for normal
# executables as well as zsh builtins
function man() {
  readonly page=${1:?"usage: man <command or builtin>"}
  if [[ -f $HELPDIR/$1 ]]; then
    run-help $1 | eval ${MANPAGER}
  else
    command man $1
  fi
}

alias python=/usr/local/bin/python3

# abbr does in-place (at the prompt) text expansion
abbr add be='bundle exec' > /dev/null 2>&1
abbr add bi='bundle install' > /dev/null 2>&1

alias cpwd="pwd | tr -d '\n' | pbcopy; print 'Current diretory sent to pasteboard'"

abbr add dcom='docker-compose' > /dev/null 2>&1

alias gcb="git branch --show-current | tr -d '\n' | pbcopy; print 'Current branch sent to pasteboard'"
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

# Change directory to source dir for given Homebrew forumla or cask
function cdbrew {
  if [[ $# -eq 0 ]]; then
      echo "Usage: $0 <formula or cask name>"
      return 1
  fi

  fcellar="$(brew --cellar $1)"
  fver="$(brew info --json $1 | jq -r 'map(.installed)[0][0] | .version')"
  fdir="$fcellar/$fver"
  if [[ -d $fdir ]]; then
    cd $fdir
  else
    echo "$0: can't go to $fdir"
    return 1
  fi
}

# Change directory to source dir for given RubyGem
function cdgem () {
  if [[ $# -eq 0 ]]; then
      echo "Usage: $0 <gem>"
      return 1
  fi

  cd $(gem open $1 -e echo)
}
