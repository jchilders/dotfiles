# Use neovim as pager for man
if alias -L run-help > /dev/null; then
  unalias run-help
fi
autoload run-help
export MANPAGER='nvim +Man!'
export HELPDIR=/usr/share/zsh/$(zsh --version | ruby -ane 'puts $F[1]')/help

# Override the `man` command so that it shows help pages for zsh builtins as
# well as for "normal" executables.
function man() {
  readonly page=${1:?"usage: man <command or builtin>"}

  if [[ -f $HELPDIR/$1 ]]; then
    run-help $1 | eval ${MANPAGER}
  else
    command man $1
  fi
}

# Aliases
alias ...='cd ../..'
alias cpwd="pwd | tr -d '\n' | pbcopy; print 'Current directory copied to pasteboard'"
alias diff='delta' # viewer for `git diff` and `diff`
alias gcb="git branch --show-current | tr -d '\n' | pbcopy; print 'Current branch copied to pasteboard'"
alias l='exa --all --classify --git --header --icons --long --no-permissions --no-user --color-scale'
alias tree='exa --tree'
alias python=/usr/local/bin/python3

# Abbreviations
# Silence "already exists" warnings from `abbr` when loading new shells

function addAbbreviations() {
  # Exit if abbreviations already defined. (`-s` is "file exists and has size > 0")
  [[ -s $ABBR_USER_ABBREVIATIONS_FILE ]] && return 1

  source /usr/local/share/zsh-abbr/zsh-abbr.zsh # like aliases, but they expand in place

  export ABBR_QUIET=1
  export ABBR_FORCE=1
  abbr add be='bundle exec'
  abbr add bi='bundle install'
  abbr add dcom='docker-compose'
  abbr add gd='git diff'
  abbr add gst='git status -sb'

  # Ruby and Rails helpers
  abbr add rc='rails console'
  abbr add rs='rails server' > /dev/null 2>&1
  abbr add rdbm='rails db:migrate'
  abbr add rdbms='rails db:migrate:status'
  abbr add rdbmt='rails db:migrate RAILS_ENV=test'
  abbr add rdbmst='rails db:migrate:status RAILS_ENV=test'
  unset ABBR_FORCE
  unset ABBR_QUIET
}
addAbbreviations

function killr() {
  if [[ -f tmp/pids/server.pid ]]; then
    pid=$(cat tmp/pids/server.pid)
    echo "Killing PID $pid"
    kill -5 $pid
    return 0
  else
    echo "server.pid file not found"
    return 1
  fi
}

# Change directory to source dir for given Homebrew formula or cask
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
