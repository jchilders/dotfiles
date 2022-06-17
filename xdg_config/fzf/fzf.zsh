# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOMEBREW_PREFIX/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOMEBREW_PREFIX/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
# Sets up ctrl-r ^r/ctrl-t ^t bindings
# CTRL_R
# CTRL_T
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
