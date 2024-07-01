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
alias l='eza --all --long --git --icons --no-user --time-style relative'
alias tree='eza --tree'

# Abbreviations
function addAbbreviations() {
  # exit if abbreviations have already been already defined
  [[ -s $ABBR_USER_ABBREVIATIONS_FILE ]] && return 1

  export ABBR_QUIET=1
  export ABBR_FORCE=1
  abbr add be='bundle exec'
  abbr add bi='bundle install'
  abbr add dcom='docker-compose'
  abbr add gd='git diff'
  abbr add gst='git status -sb'
  abbr add imgcat='wezterm imgcat'

  # Ruby and Rails helpers
  # abbr add rc='rails console'
  abbr add rc='docker exec -it $(docker ps --filter "ancestor=dentaltrac10-rails-web" --filter "status=running" --format "{{.ID}}") bundle exec rails console'
  abbr add rdbm='rails db:migrate'
  abbr add rdbms='rails db:migrate:status'
  abbr add rdbmt='rails db:migrate RAILS_ENV=test'
  abbr add rdbmst='rails db:migrate:status RAILS_ENV=test'
  # rails test branch - run tests, but only those that have changed from development
  abbr add rtb='rails test $(git diff development... --name-only | rg "_test.rb$")'

  unset ABBR_FORCE
  unset ABBR_QUIET
}
addAbbreviations

# Change directory to source dir for given Homebrew formula or cask
# This has to be a function (instead of a script under bin/) because you can't
# cd from a script & have it stick. zsh spawns a child process to execute a
# script, while functions happen in the same process they were called from.
function cdbrew {
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <formula or cask name>"
    return 1
  fi

  local fcellar="$(brew --cellar $1)"
  local fver="$(brew info --json $1 | jq -r 'map(.installed)[0][0] | .version')"
  local fdir="$fcellar/$fver"
  if [[ -d $fdir ]]; then
    cd $fdir
  else
    echo "$0: can't go to $fdir"
    return 1
  fi
}

# Change directory to source dir for given RubyGem
# Shell wisdom: This must be a function (rather than a standlone script)
# because you can't cd from a script & have it stick. zsh spawns a child
# process to execute a script, while functions happen in the same process they
# were called from.
function cdgem () {
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <gem>"
    return 1
  fi

  local gem_dir="$(bundle exec gem open $1 -e echo)"
  if [ $? -ne 0 ]; then
    echo "Error finding gem '$1'"
    return 1
  fi

  cd $gem_dir
}

function cwd_is_git_repo() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Start Rails with foreman if Procfile.dev exists, otherwise just use rails
function rs {
  local port=${1:-3000}
  local pid=$(lsof -i tcp:$port -t)
  if [[ -n $pid ]]; then
    echo "Port $port is already in use by process $pid"
    return 1
  fi

  if [[ -e Procfile.dev ]]; then
    foreman start -f Procfile.dev
  else
    rails server -p $port
  fi
}

# Set the tmux window name to the git root dir, or just the pwd if we aren't in a
# git repository
# function tmux_window_name() {
#   local new_name
#   $(cwd_is_git_repo)
#   if [[ $? -eq 0 ]]; then
#     new_name=$(git rev-parse --show-toplevel 2>/dev/null | xargs basename)
#   else
#     new_name=$(pwd | xargs basename)
#   fi
#
#   if [[ -n "$TMUX" ]]; then
#     if [[ -n "$new_name" ]]; then
#       tmux rename-window "$new_name"
#     fi
#   fi
# }
#
# chpwd_functions+=(tmux_window_name)

# Determine whether the tmux status bar should be at the top of the display or
# the bottom. Need to do this because when using a display with a notch (i.e.
# the M1 MBP) the window list -- which is normally centered in the tmux status
# bar -- is hidden by the notch.
# function single_display() {
#   local num_displays=$(system_profiler -json SPDisplaysDataType | jq '.SPDisplaysDataType[0].spdisplays_ndrvs' | jq 'length')
#   [[ $num_displays -eq 1 ]]
# }

# Edit last migration. Let's you quickly do:
#   > rails g migration add_foo_to_bar
#   > vilm # opens migration created above
function vilm {
  if [ ! -d db/migrate ]; then
    print "No db/migrate directory"
    return 1
  fi

  $EDITOR $(print -l db/migrate/*.rb(oc) | head -1 | tr -d '\n')
}
