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

# edit file selected from git status
function fuzzy_edit_from_git_status {
  __fuzzy_search_git_status_and_eval "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_from_git_status
bindkey '^os' fuzzy_edit_from_git_status

# show diff of file selected from from git status
function fuzzy_diff_from_git_status {
  __fuzzy_search_git_status_and_eval "git diff"
}
zle -N fuzzy_diff_from_git_status
bindkey '^od' fuzzy_diff_from_git_status

# git add file selected from from git status
function fuzzy_add_from_git_status {
  __fuzzy_search_git_status_and_eval "git add"
  echo "${found_file} added to index"
  echo
  git status -sb
}
zle -N fuzzy_add_from_git_status
bindkey '^oa' fuzzy_add_from_git_status

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

function fuzzy_edit_any_file {
  __fuzzy_find_file "fd --type=file --hidden --no-ignore"
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N fuzzy_edit_any_file
bindkey '^of' fuzzy_edit_any_file
