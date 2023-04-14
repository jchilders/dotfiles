source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# like aliases, but they expand in place
source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh 

# Ruby Version Manager
rvm_path="${XDG_DATA_HOME}/rvm"
[ -f "${rvm_path}"/scripts/rvm ] && source "${rvm_path}"/scripts/rvm
