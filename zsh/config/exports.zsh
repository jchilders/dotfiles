# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
export PATH="$PATH:$HOME/workspace/dotfiles/scripts"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl/lib/"

export FZF_DEFAULT_OPTS="--height 30% --layout=reverse --border --tiebreak=end --info=inline --select-1"
export FZF_DEFAULT_COMMAND="fd"

export MANPAGER='nvim +Man!'

# mcfly: smarter history search
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=true
eval "$(mcfly init zsh)"

