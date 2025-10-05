[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

if command -v brew >/dev/null; then
  [ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [ -f $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Like aliases, but they expand in place
  [ -f $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh ] && source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 
fi

# mise is a version manager for handling Ruby, NodeJS, etc.
command -v mise >/dev/null && eval "$(mise activate zsh)"
