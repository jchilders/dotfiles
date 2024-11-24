[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

if command -v brew >/dev/null; then
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Like aliases, but they expand in place
  [ -f $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh ] && source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 
fi

# asdf is a version manager for hanglnig Ruby, Node.js, etc.
if command -v brew >/dev/null; then
  asdf_dir="$(brew --prefix asdf)/libexec"
else
  asdf_dir="$HOME/.asdf"
fi

if [ -d "$asdf_dir" ]; then
  export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf
  export ASDF_GEM_DEFAULT_PACKAGES_FILE=$XDG_CONFIG_HOME/asdf/.default-gems
  
  # Load asdf
  . "$asdf_dir/asdf.sh"

  if type rust &>/dev/null; then
    [ $(asdf list rust) ] && source "$(asdf where rust)/env"
  fi
fi
