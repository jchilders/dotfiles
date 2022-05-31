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

# Add RVM binaries for managing different Ruby versions
path+=($HOME/.rvm/bin)

# Binaries built by Cargo (Rust)
path+=($HOME/.cargo/bin)

# My scripts
path+=($HOME/scripts)

# fpath is where zsh looks for command completion scripts
if type brew &>/dev/null; then
  fpath+=($(brew --prefix)/share/zsh/site-functions)
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# In all my years of Rails development Spring has caused far, far more issues
# than time it has saved. Disable it, with a vengeance.
export DISABLE_SPRING=1

export FZF_DEFAULT_COMMAND="fd"
export FZF_DEFAULT_OPTS="--height 30% --border --tiebreak=index --info=inline"
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/.ripgreprc

export NVM_DIR="$XDG_DATA_HOME/nvm"

# Speed up shell startup by lazy loading nvm/node/yarn stuff. See:
# https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922
if [ -d $NVM_DIR/versions/node ]; then
  NODE_GLOBALS+=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
fi
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

# Lazy-loading nvm + npm on node globals call
load_nvm () {
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"
}

# Making node global trigger the lazy loading
for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done
