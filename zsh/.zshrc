# Turn on vi mode
bindkey -v

# plugin manager
# https://github.com/zdharma/zinit
source ~/.zinit/bin/zinit.zsh

# z - fast directory switching
. /usr/local/etc/profile.d/z.sh

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

# prompt
eval "$(starship init zsh)"

abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' --force > /dev/null 2>&1

abbr add rc='rails console' --force> /dev/null 2>&1
abbr add rdbm='rake db:migrate' > /dev/null 2>&1
abbr add rdbms='rake db:migrate:status'> /dev/null 2>&1
abbr add rs='rails server' --force> /dev/null 2>&1

alias ..='cd ..'
alias l='exa -al'
alias gcb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export FZF_DEFAULT_OPTS="--height 30% --layout=reverse --border --tiebreak=end --info=inline --select-1"
export PATH="$PATH:$HOME/.rvm/bin"

# Plugins
zinit load zsh-users/zsh-syntax-highlighting

# Custom functions
# TODO: Move these into separate files
# TODO: DRY this stuff up

# edit from selected from git status
fuzzy_edit_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_from_git_status
bindkey '^os' fuzzy_edit_from_git_status

# show diff of file selected from from git status
fuzzy_diff_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	git diff "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_diff_from_git_status
bindkey '^od' fuzzy_diff_from_git_status

# git add file selected from from git status
fuzzy_add_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	git add "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_add_from_git_status
bindkey '^oa' fuzzy_add_from_git_status

# edit a file from app/controllers
fuzzy_edit_rails_controller() {
  if [[ ! -d ./app/controllers ]]; then
	zle reset-prompt
	return
  fi
  IFS=$'\n' file=$(fd --type=file . 'app/controllers' | fzf)
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_rails_controller
bindkey '^oc' fuzzy_edit_rails_controller

# edit a file from app/models
fuzzy_edit_rails_model() {
  if [[ ! -d ./app/models ]]; then
	zle reset-prompt
	return
  fi
  IFS=$'\n' file=$(fd --type=file . 'app/models' | fzf)
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_rails_model
bindkey '^om' fuzzy_edit_rails_model

fuzzy_edit_file() {
  IFS=$'\n' file=$(fd --hidden $1 | fzf)
  if [ -n "$file" ]; then
	local cmd="${EDITOR:-nvim} '$file'"
	eval "$cmd"
	print -s $cmd
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_file
bindkey '^of' fuzzy_edit_file
