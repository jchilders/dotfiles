export XDG_DATA_HOME="$HOME/.local/share"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# GNU coreutils
export PATH=/usr/local/opt/grep/libexec/gnubin:$PATH
# Binaries built by Cargo (Rust)
export PATH=$PATH:$HOME/.cargo/bin
# Python binaries
export PATH=$PATH:$HOME/Library/Python/3.8/bin
# Add RVM binaries for managing different Ruby versions
export PATH=$HOME/.rvm/bin:$PATH
# My scripts
export PATH=$PATH:$HOME/scripts

# In all my years of Rails development Spring has caused far, far more issues
# than time it has saved. Disable it, with a vengeance.
export DISABLE_SPRING=1

# TODO: Verify this is necessary
eval $(brew shellenv)

export FZF_DEFAULT_COMMAND="fd"
export FZF_DEFAULT_OPTS="--height 30% --border --tiebreak=index --info=inline"
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/.ripgreprc

export NVM_DIR="$XDG_DATA_HOME/nvm"

# Speed up shell startup by lazy loading nvm/node/yarn stuff. Graciously
# provided by christophemarois
# https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922
NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
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
