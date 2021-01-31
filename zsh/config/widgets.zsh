# # Custom functions/widgets
# TODO: DRY this stuff up

function myls {
	[[ "$CONTEXT" = cont ]] && return
	zle push-input
	zle -R
	zle accept-line
	print -n $(exa --color=always --all --oneline)
}
zle -N myls
bindkey '^[l' myls

# WIP
__fuzzy_get_file() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  local file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
}

# show diff of file selected from from git status
# edit from selected from git status
fuzzy_edit_from_git_status() {
  # __fuzzy_get_file
  # echo "file: '${file}'"
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}' --prompt='EDIT > ')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	local cmd="${EDITOR:-nvim} '$file'"
	print -s $cmd  # Add to history
	eval "$cmd"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_from_git_status
bindkey '^os' fuzzy_edit_from_git_status

fuzzy_diff_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}' --prompt='DIFF > ')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	git diff $file
  fi
  zle reset-prompt
}
zle -N fuzzy_diff_from_git_status
bindkey '^od' fuzzy_diff_from_git_status

# git add file selected from from git status
fuzzy_add_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}' --prompt='ADD > ')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	git add $file
  fi
  zle reset-prompt
}
zle -N fuzzy_add_from_git_status
bindkey '^oa' fuzzy_add_from_git_status

# edit a file from app/controllers
fuzzy_edit_rails_controller() {
  IFS=$'\n' file=$(fd --type=file . 'app/controllers' | fzf --query="$1" --preview='bat -f {-1}' --prompt='controller > ')
  if [ -n "$file" ]; then
	local cmd="${EDITOR:-nvim} '$file'"
	# zle kill-whole-line
	zle -U $cmd
	# zle -R
	zle accept-line
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_rails_controller
bindkey '^oc' fuzzy_edit_rails_controller

fuzzy_edit_rails_model() {
  IFS=$'\n' file=$(fd --type=file . 'app/models' | fzf --query="$1" --preview='bat -f {-1}' --prompt='model > ')
  if [ -n "$file" ]; then
	local cmd="${EDITOR:-nvim} '$file'"
	print -s $cmd  # Add to history
	eval "$cmd"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_rails_model
bindkey '^om' fuzzy_edit_rails_model

fuzzy_edit_any_file() {
  IFS=$'\n' file=$(fd --type=file $1 | fzf --query="$1" --preview='bat -f {-1}' --prompt='edit > ')
  if [ -n "$file" ]; then
	local cmd="${EDITOR:-nvim} '$file'"
	eval "$cmd"
	print -s $cmd
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_any_file
bindkey '^oe' fuzzy_edit_any_file

