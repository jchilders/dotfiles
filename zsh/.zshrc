# zoxide: smarter cd
_ZO_DATA_DIR=$HOME/.local/share/zoxide
eval "$(zoxide init zsh)"

# prompt
eval "$(starship init zsh)"

foreach file (
  settings.zsh
  aliases.zsh
  exports.zsh
  fzf-widgets.zsh
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

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# direnv allows for directory-specific environment variables. To use, add
# .envrc file to directory to load project specific envars. Then:
# 
# > direnv allow .
#
# To allow it for that directory
eval "$(direnv hook zsh)"
