if [[ -z $XDG_CONFIG_HOME ]]
then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -z $XDG_DATA_HOME ]]
then
  export XDG_DATA_HOME="$HOME/.local/share"
fi

if [[ -z $XDG_CACHE_HOME ]]
then
  export XDG_CACHE_HOME="$HOME/.cache"
fi

if [[ -z $XDG_STATE_HOME ]]
then
  export XDG_STATE_HOME="$HOME/.local/state"
fi

if [[ -z $XDG_BIN_HOME ]]
then
  export XDG_BIN_HOME="$HOME/.local/bin"
fi

[[ -d $ZDOTDIR ]] || mkdir -p "$ZDOTDIR"

export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"

# Dedupe fpath on re-source (path is already -U'd in .zshenv)
typeset -U fpath

# fpath is where zsh looks for command completion scripts
if [[ -n $HOMEBREW_PREFIX ]]; then
  fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)
fi

export HOMEBREW_NO_ENV_HINTS=1

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Speed up new shells
ABBR_AUTOLOAD=0

export AWS_PAGER="bat --plain"
export FZF_DEFAULT_COMMAND="fd"
export FZF_DEFAULT_OPTS="--height 30% --border --tiebreak=index --info=inline"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/.ripgreprc

# colon-separated list of directories to exclude from zoxide dir switcher
export _ZO_EXCLUDE_DIRS="$HOME/temp/*"

# Speed up shell startup by lazy loading nvm/node/yarn stuff. See:
# https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922
if [ -d $NVM_DIR/versions/node ]; then
  NODE_GLOBALS+=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
fi
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

# Lazy-loading nvm + npm on node globals call
load_nvm () {
  local nvm_sh="$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$nvm_sh" ] && . "$nvm_sh"
}

# Making node global trigger the lazy loading
for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS[@]}; load_nvm; ${cmd} \$@ }"
done
