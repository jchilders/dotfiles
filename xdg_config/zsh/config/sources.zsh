source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# like aliases, but they expand in place
source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 

# asdf is a version manager for Ruby, Node.js, etc.
# [ -d "${HOMEBREW_PREFIX}/opt/asdf" ] && source "${HOMEBREW_PREFIX}"/opt/asdf/libexec/asdf.sh
if [ -d $(brew --prefix asdf) ]; then
  export ASDF_DATA_DIR=$XDG_DATA_HOME/asdf
  export ASDF_GEM_DEFAULT_PACKAGES_FILE=$XDG_CONFIG_HOME/asdf/.default-gems
  . $(brew --prefix asdf)/libexec/asdf.sh
fi
