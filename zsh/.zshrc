# Turn on vi mode
# bindkey -v

# SCRATCH STUFF
# function _accept-line-with-echo {
    # echo "Executing: $BUFFER"
    # zle .accept-line
# }
# zle -N accept-line _accept-line-with-echo

# just_run_vi() {
  # local cmd="vim"
  # zle -U $cmd
  # zle accept-line
# }
# zle -N just_run_vi
# bindkey '^ov' just_run_vi
# END SCRATCH STUFF

# plugin manager
# https://github.com/zdharma/zinit
# source ~/.zinit/bin/zinit.zsh
# zinit load zsh-users/zsh-syntax-highlighting

# z - fast directory switching
. /usr/local/etc/profile.d/z.sh

# when no args are given to z, or z returns no results, use fzf
unalias z &> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --nth 2.. +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')" || exit 1
}

# prompt
eval "$(starship init zsh)"

foreach file (
  aliases.zsh
  exports.zsh
  fzf-widgets.zsh
  settings.zsh
  widgets.zsh
) {
  source $ZDOTDIR/config/$file
}
unset file

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
