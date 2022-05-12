# like aliases, but they expand in place
source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# Ruby version manager
source $HOME/.rvm/scripts/rvm
