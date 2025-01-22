[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

if command -v brew >/dev/null; then
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Like aliases, but they expand in place
  [ -f $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh ] && source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 
fi

# mise is a version manager for handling Ruby, NodeJS, etc.
eval "$(mise activate zsh)"
