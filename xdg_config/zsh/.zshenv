# Minimal environment for every zsh shell, including non-interactive shells
# launched by GUI apps like Codex.

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

source "$ZDOTDIR/config/path.zsh"
