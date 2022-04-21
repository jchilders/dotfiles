# Custom widgets

function __find_file {
  IFS=$'\n' export found_file=("$(eval $1 | fzf --ansi --tac --no-sort --preview='bat -f {-1}')")
}

function __eval_found_file {
  if [ -n "$found_file" ]; then
    local cmd="$1 '$found_file'"
    print -s $cmd  # Add to history
    eval "$cmd"
  fi
  zle accept-line
}

function __search_git_status_and_eval {
  __find_file "sorted_status"
  found_file=$(echo "$found_file" | awk ' { print $NF } ')
  __eval_found_file $1
}

function __is_git_repo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function edit_file {
  if __is_git_repo; then
    __find_file "fd --type=file --type=symlink"
    __eval_found_file "${EDITOR:-nvim}"
  else
    edit_any_file
  fi
}
zle -N edit_file
bindkey '^oo' edit_file

# ANY file
function edit_any_file {
  __find_file "fd --type=file --type=symlink --hidden --no-ignore"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N edit_any_file
bindkey '^oO' edit_any_file

function edit_rails_controller {
  __find_file "fd --type=file . 'app/controllers'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N edit_rails_controller
bindkey '^orc' edit_rails_controller

function edit_rails_model {
  __find_file "fd --type=file . 'app/models'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N edit_rails_model
bindkey '^orm' edit_rails_model

function edit_rails_view {
  __find_file "fd --type=file . 'app/views'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N edit_rails_view
bindkey '^orv' edit_rails_view

# Git stuff. All are prefixed with ^og

function add_from_git_status {
  if [[ -n "$found_file" ]]; then
    echo
    read -k "answer?Add $found_file to the git staging area? [Y/n/d] "

    # This monstrosity is necessary b/c I could not get the case statment below
    # to work with the carriage return character, which is what you get when
    # you just hit enter on the above call to `read`.
    # Maybe something to do with IFS?
    hex_answer=$(printf "%s" "$answer" | hexdump -v -e '/1 "%02x"')
    if [[ $hex_answer == '0d' ]]; then
      __eval_found_file "git add"
      unset -v found_file
      echo
      git status -s
      return
    fi

    case $answer in
      (y | Y )
        __eval_found_file "git add"
        unset -v found_file
        echo
        git status -s
        ;;
      (d | D )
        __eval_found_file "git diff"
        ;;
      (*)
        unset -v found_file
        zle reset-prompt
        ;;
    esac
  else
    __search_git_status_and_eval "git add"
    git status -s
  fi
}
zle -N add_from_git_status
bindkey '^oga' add_from_git_status

# show diff of file selected from from git status
function diff_from_git_status {
  __search_git_status_and_eval "git diff"
}
zle -N diff_from_git_status
bindkey '^ogd' diff_from_git_status

# edit file selected from git status
function edit_from_git_status {
  __search_git_status_and_eval "${EDITOR:-nvim}"
}
zle -N edit_from_git_status
bindkey '^ogs' edit_from_git_status

function switch_branch {
  # TODO: handle git worktrees
  # all_branches is an executable script
  local branch=$(all_branches | fzf --tiebreak=index)

  if [[ '' != $branch ]]; then
    git checkout $branch
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N switch_branch
bindkey '^ogb' switch_branch
