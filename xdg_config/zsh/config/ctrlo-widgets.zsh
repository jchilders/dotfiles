# Use fzf to find a file based on fuzzy matching, preview it, and open it in
# $EDITOR on enter. It is smart enough to handle previewing images. It expects the first
# (and only) argument to be a command that will output a list of files.
#
# Example:
#
#   __find_file "fd --type=file"
function __find_file() {
  local -a files
  local cmd=${1:?usage: __find_file "command"}
  local preview_cmd='
    if file --mime-type -b {} | grep -q "^image/"; then
      chafa --size=555x${FZF_PREVIEW_LINES} {}
    else 
      bat --color always --style numbers --line-range :200 {}
    fi'

  files=("${(@f)$(eval $cmd 2>/dev/null)}") || return 2

  if (( ${#files[@]} == 0 )); then
    return 2
  fi

  found_file=$(print -l $files | fzf --ansi --multi --cycle --preview="$preview_cmd")
  return $?  # 0 = selected, 130 = cancelled by user (ESC/Ctrl-C)
}

# Like __find_file but shows "No files found" message only when there are no files.
# Silently returns non-zero when user cancels fzf (ESC/Ctrl-C).
function __find_file_required() {
  __find_file "$@"
  local rc=$?
  if (( rc == 2 )); then
    __no_files_found
  elif (( rc != 0 )); then
    zle reset-prompt
  fi
  return $rc
}

function __no_files_found {
  unset -v found_file
  if [[ -n "$ZLE" ]]; then
    zle -M "No files found"
  else
    print -r -- "No files found"
  fi
}

function __eval_found_file {
  if [ -n "$found_file" ]; then
    local cmd
    if file --mime-type -b "$found_file" | grep -qF image/; then
      cmd=(chafa "$found_file")
    else
      cmd=(${=1} "$found_file") # Split $1 into an array
    fi

    # Add to history (with proper quoting)
    local line="${(j: :)${(q)cmd[@]}}"
    print -r -s -- "$line"

    command "${cmd[@]}"
  fi
  zle accept-line
}

function __search_git_status_and_eval {
  __find_file_required "sorted_status" || return 1
  found_file=$(echo "$found_file" | awk ' { print $NF } ')
  __eval_found_file $1
}

function __is_git_repo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function edit_file {
  if __is_git_repo; then
    __find_file_required "fd --type=file --type=symlink" || return 1
    __eval_found_file "${EDITOR:-nvim}"
  else
    edit_any_file
  fi
}
zle -N edit_file
bindkey -M viins '^oo' edit_file
bindkey -M viins '^o^o' edit_file

# ANY file
function edit_any_file {
  __find_file_required "fd --type=file --type=symlink --hidden --no-ignore" || return 1
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N edit_any_file
bindkey -M viins '^oO' edit_any_file

function git_changed_files_curr_branch {
  # this xargs stuff is needed so it still works when you're in a subdirectory
  # of the git root
  # grealpath - realpath from gnu coreutils, has `relative-to` flag
  local -a diff_files
  diff_files=("${(@f)$(git diff --name-only main 2>/dev/null)}")
  if (( ${#diff_files[@]} == 0 )); then
    if [[ -n "$ZLE" ]]; then
      zle -M "Squeaky clean! 🧼"
    else
      print -r -- "Squeaky clean! 🧼"
    fi
    return 0
  fi
  __find_file_required "git diff --name-only main 2>/dev/null | xargs -I '{}' grealpath --relative-to=. $(git rev-parse --show-toplevel)/'{}'" || return 1
  __eval_found_file "${EDITOR:-nvim}"
}
zle -N git_changed_files_curr_branch
bindkey -M viins '^ogc' git_changed_files_curr_branch

# Git stuff. All are prefixed with ^og

function add_from_git_status {
  if [[ -n "$found_file" ]]; then
    echo
    read -k "answer?Add $found_file to the git staging area? [Y/n/d/c] "

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
      ( c )
        __eval_found_file "git checkout"
        ;;
      ( d )
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
bindkey -M viins '^oga' add_from_git_status

# show diff of file selected from from git status
function diff_from_git_status {
  __find_file_required "sorted_status" || return 1
  found_file=$(echo "$found_file" | awk ' { print $NF } ')

  if [[ ! -e "$found_file" ]]; then
    echo "Deleted: $found_file"
    zle accept-line
  else
    __eval_found_file "git diff"
  fi
}
zle -N diff_from_git_status
bindkey -M viins '^ogd' diff_from_git_status

# edit file selected from git status
function edit_from_git_status {
  __search_git_status_and_eval "${EDITOR:-nvim}"
}
zle -N edit_from_git_status
bindkey -M viins '^ogs' edit_from_git_status

function switch_branch {
  # TODO: handle git worktrees
  # all_other_branches is an executable script
  local branch=$(all_other_branches | fzf --tiebreak=index --cycle)

  if [[ '' != $branch ]]; then
    git switch $branch
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N switch_branch
bindkey -M viins '^ogb' switch_branch

function switch_worktree {
  if ! __is_git_repo; then
    zle -M "Not a git repo"
    return 1
  fi

  local dir
  dir=$(git worktree list 2>/dev/null | fzf --height 30% --cycle | awk '{print $1}')
  if [[ -n "$dir" ]]; then
    builtin cd "$dir"
  fi
  zle reset-prompt
}
zle -N switch_worktree
bindkey -M viins '^ogw' switch_worktree
