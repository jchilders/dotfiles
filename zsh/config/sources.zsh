[[ -f $HOME/.local_settings_no_commit.zsh ]] && source $HOME/.local_settings_no_commit.zsh

HB_CNF_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[[ -f "$HB_CNF_HANDLER" ]] && source "$HB_CNF_HANDLER"

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-abbr/zsh-abbr.zsh # like aliases, but they expand in place

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ruby version manager
source $HOME/.rvm/scripts/rvm
