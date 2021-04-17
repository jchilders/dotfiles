# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export LDFLAGS="-L/usr/local/opt/mysql@5.6/lib -L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.6/include -I/usr/local/opt/openssl@1.1/include"

export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl/lib/"

export FZF_DEFAULT_OPTS="--height 30% --layout=reverse --border --tiebreak=end --info=inline --select-1"
export FZF_DEFAULT_COMMAND="fd"
