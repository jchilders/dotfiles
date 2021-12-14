# these need to happen in the given order
foreach file (
  options.zsh
  sources.zsh
  aliases.zsh
  exports.zsh
  ctrlo-widgets.zsh
  misc-widgets.zsh
) {
  source $ZDOTDIR/config/$file
}
unset file

# Source the completions installed by homebrew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi
# zoxide: smarter cd
if type zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# prompt
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# direnv allows for directory-specific environment variables. To use, add
# .envrc file to directory to load project specific envars. Then:
# 
# > direnv allow .
#
# To allow your new .envrc file to be loaded for that directory
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi
