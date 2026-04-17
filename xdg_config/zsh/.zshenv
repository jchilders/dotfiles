# Minimal environment for every zsh shell, including non-interactive shells
# launched by GUI apps like Codex.

typeset -U path PATH

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ -z ${HOMEBREW_PREFIX:-} ]]; then
  case "$(uname -s):$(uname -m)" in
    Darwin:arm64) export HOMEBREW_PREFIX="/opt/homebrew" ;;
    Darwin:*) export HOMEBREW_PREFIX="/usr/local" ;;
    *) export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew" ;;
  esac
fi

path=(
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  "${XDG_BIN_HOME:-$HOME/.local/bin}"
  "$HOME/.cargo/bin"
  "$HOME/bin"
  $path
)

export PATH
