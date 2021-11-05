# Custom widgets

function __fuzzy_find_file {
  IFS=$'\n' export found_file=("$(eval $1 | fzf --preview='bat -f {-1}')")
}

function __eval_found_file {
  if [ -n "$found_file" ]; then
    local cmd="$1 '$found_file'"
    print -s $cmd  # Add to history
    eval "$cmd"
  fi
  zle accept-line
}

function __fuzzy_search_git_status_and_eval {
  __fuzzy_find_file "git status -s"
  found_file=$(echo "$found_file" | awk ' { print $NF } ')
  __eval_found_file $1
}

# edit a file in app/models
function fuzzy_edit_rails_model {
  __fuzzy_find_file "fd --type=file . 'app/models'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_rails_model
bindkey '^om' fuzzy_edit_rails_model

# edit a file from app/views
function fuzzy_edit_rails_view {
  __fuzzy_find_file "fd --type=file . 'app/views'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_rails_view
bindkey '^ov' fuzzy_edit_rails_view

# edit a file from app/controllers
function fuzzy_edit_rails_controller {
  __fuzzy_find_file "fd --type=file . 'app/controllers'"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_rails_controller
bindkey '^oc' fuzzy_edit_rails_controller

function fuzzy_edit_file {
  __fuzzy_find_file "fd --type=file"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_file
bindkey '^oo' fuzzy_edit_file

# ANY file
function fuzzy_edit_any_file {
  __fuzzy_find_file "fd --type=file --hidden --no-ignore"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_any_file
bindkey '^oO' fuzzy_edit_any_file

# Git stuff. All prefixed with ^og

# git add file selected from from git status
function fuzzy_add_from_git_status {
  echo "-=-=> Adding"
  __fuzzy_search_git_status_and_eval "git add"
  echo "${found_file} added to index"
  echo
  git status -sb
}
zle -N fuzzy_add_from_git_status
bindkey '^oga' fuzzy_add_from_git_status

function fuzzy_switch_branch {
  local branch=$(all_branches | fzf --tiebreak=index)

  if [[ '' != $branch ]]; then
    git checkout $branch
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N fuzzy_switch_branch
bindkey '^ogb' fuzzy_switch_branch

# show diff of file selected from from git status
function fuzzy_diff_from_git_status {
  echo "-=-=> Diffing"
  __fuzzy_search_git_status_and_eval "git diff"
}
zle -N fuzzy_diff_from_git_status
bindkey '^ogd' fuzzy_diff_from_git_status

# edit file selected from git status
function fuzzy_edit_from_git_status {
  echo "-=-=> Editing from git status"
  __fuzzy_search_git_status_and_eval "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_from_git_status
bindkey '^ogs' fuzzy_edit_from_git_status
