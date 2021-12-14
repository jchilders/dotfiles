[[ -f $HOME/.local_settings_no_commit.zsh ]] && source $HOME/.local_settings_no_commit.zsh

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-abbr/zsh-abbr.zsh # like aliases, but they expand in place

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ruby version manager
source $HOME/.rvm/scripts/rvm
