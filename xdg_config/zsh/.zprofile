# Re-assert path ordering after /etc/zprofile runs path_helper,
# which would otherwise prepend /usr/bin ahead of Homebrew.
source "$ZDOTDIR/config/path.zsh"
