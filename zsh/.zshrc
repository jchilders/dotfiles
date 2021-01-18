# Path to your oh-my-zsh installation.
export ZSH="/Users/jchilders/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
  ruby
  z
  zsh-abbr
  zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Turn on vi mode
# bindkey -v

abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' --force > /dev/null 2>&1

abbr add rc='rails console' --force> /dev/null 2>&1
abbr add rdbm='rake db:migrate' > /dev/null 2>&1
abbr add rdbms='rake db:migrate:status'> /dev/null 2>&1
abbr add rs='rails server' --force> /dev/null 2>&1

alias l='exa -al'
alias gcb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

# Activates tmux session by default
tmux attach &> /dev/null

if [[ ! $TERM =~ screen ]]; then
  exec tmux
fi

# Custom functions
# TODO: Move these into separate files

# vi from git status
fuzzy_edit_from_git_status() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_from_git_status
bindkey '^O^S' fuzzy_edit_from_git_status

# diff from git status
dst() {
  IFS=$'\n' out=("$(git status -s | fzf --query="$1" --preview='bat -f {-1}')")
  file=$(head -2 <<< "$out" | tail -1 | awk ' { print $2 } ')
  if [ -n "$file" ]; then
	git diff "$file"
  fi
}

fuzzy_edit_controller() {
  IFS=$'\n' file=$(fd . 'app/controllers' | fzf)
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_controller
bindkey '^O^O' fuzzy_edit_controller

fuzzy_edit_model() {
  IFS=$'\n' file=$(fd . 'app/models' | fzf)
  if [ -n "$file" ]; then
	${EDITOR:-nvim} "$file"
  fi
  zle reset-prompt
}
zle -N fuzzy_edit_model
bindkey '^O^M' fuzzy_edit_model
