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

command -v bat >/dev/null 2>&1 && alias cat='bat' # use bat as cat
command -v gotop >/dev/null 2>&1 && alias top='gotop'
command -v gping >/dev/null 2>&1 && alias ping='gping' # like ping but with a graph

if (( $+commands[op] )) && (( $+commands[aichat] )); then
  # Use 1password to read credentials for aichat
  alias aichat="op run --env-file=\"$XDG_CONFIG_HOME/aichat/.env\" --no-masking -- aichat"
fi

# Load abbreviations. Abbreviations are similar to aliases, but expand in place
# (like fish). To reload abbreviations run this function with the `--force`
# flag.
function loadAbbreviations() {
  # exit if abbreviations have already been already defined & the --force
  # parameter wasn't given
  [[ -s $ABBR_USER_ABBREVIATIONS_FILE && "$1" != "--force" ]] && return 1

  echo "Adding abbreviations"
  export ABBR_QUIET=1
  export ABBR_FORCE=1
  abbr add be='bundle exec'
  abbr add bi='bundle install'
  abbr add dcom='docker-compose'
  abbr add gd='git diff'
  abbr add gl='git l'
  abbr add gs='git status -sb'
  abbr add imgcat='wezterm imgcat'
  abbr add v='nvim'

  # Ruby and Rails helpers
  abbr add rc='rails console'
  abbr add rdbm='rails db:migrate'
  abbr add rdbms='rails db:migrate:status'
  abbr add rdbmt='rails db:migrate RAILS_ENV=test'
  abbr add rdbmst='rails db:migrate:status RAILS_ENV=test'
  # rails test branch - run tests, but only those that have changed from development
  abbr add rtb='rails test $(git diff development... --name-only | rg "_test.rb$")'

  unset ABBR_FORCE
  unset ABBR_QUIET
}
loadAbbreviations

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
cdgem() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 GEM_NAME"
        return 1
    fi

    local gem_name="$1"
    local gem_path=""
    
    # First try to find gem in Gemfile if it exists
    if [ -f "Gemfile" ]; then
        # Get the path from bundler
        gem_path=$(bundle show "$gem_name" 2>/dev/null)
        if [ $? -eq 0 ]; then
            cd "$gem_path"
            return 0
        fi
    fi
    
    # If not found in Gemfile or no Gemfile exists, try system gems
    gem_path=$(gem which "$gem_name" 2>/dev/null)
    if [ $? -eq 0 ]; then
        # gem which returns the path to a file within the gem
        # we need to get the gem's root directory
        gem_path=$(dirname $(dirname "$gem_path"))
        cd "$gem_path"
        return 0
    fi
    
    echo "Could not find gem: $gem_name"
    return 1
}
# function cdgem () {
#   if [[ $# -eq 0 ]]; then
#     echo "Usage: $0 <gem>"
#     return 1
#   fi
#
#   local gem_dir="$(bundle exec gem open $1 -e echo)"
#   if [ $? -ne 0 ]; then
#     echo "Error finding gem '$1'"
#     return 1
#   fi
#
#   cd $gem_dir
# }

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

  if [[ -e bin/dev ]]; then
    bin/dev
  else
    rails server -p $port
  fi
}

# On macOS, open Safari and switch to the correct tab
function open_localhost_and_switch_tabs() {
  local url=$1
  # Default to http://localhost if not set
  if [[ -z $url ]]; then
    url="http://localhost"
  fi
  
  # Append port to URL if it doesn't already contain one
  if [[ ! $url =~ :[0-9]+(/|$) ]]; then
    local port=${PORT:-3000}
    url="${url}:${port}"
  fi

  # Get list of Safari windows and tabs
  osascript -e '
    tell application "Safari"
      set windowList to every window
      repeat with theWindow in windowList
        set tabList to every tab of theWindow
        repeat with theTab in tabList
          if URL of theTab contains "'"$url"'" then
            set current tab of theWindow to theTab
            tell theTab to do JavaScript "window.location.reload()"
            activate
            return
          end if
        end repeat
      end repeat
      
      # If we get here, URL wasn''t found - open in new tab
      make new document
      set URL of document 1 to "'"$url"'"
      activate
    end tell
  '
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
