# zoxide: smarter cd
if type zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# prompt
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

foreach file (
  options.zsh
  aliases.zsh
  exports.zsh
  ctrlo-widgets.zsh
  misc-widgets.zsh
) {
  source $ZDOTDIR/config/$file
}
unset file

if [[ -f $HOME/.local_settings_no_commit.zsh ]]; then
  source $HOME/.local_settings_no_commit.zsh
fi

# Source the completions installed by homebrew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

if [[ -f $XDG_CONFIG_HOME/ripgrep/.ripgreprc ]]; then
  export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/.ripgreprc
fi

if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# direnv allows for directory-specific environment variables. To use, add
# .envrc file to directory to load project specific envars. Then:
# 
# > direnv allow .
#
# To allow it for that directory
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# ruby version manager
source $HOME/.rvm/scripts/rvm

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export LDFLAGS="-L/usr/local/opt/postgresql@11/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@11/include"
