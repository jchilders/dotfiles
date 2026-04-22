typeset -U path PATH

if [[ -z ${HOMEBREW_PREFIX:-} ]]; then
  case "$(uname -s):$(uname -m)" in
    Darwin:arm64) export HOMEBREW_PREFIX="/opt/homebrew" ;;
    Darwin:*) export HOMEBREW_PREFIX="/usr/local" ;;
    *) export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew" ;;
  esac
fi

path=(
  "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  "${XDG_BIN_HOME:-$HOME/.local/bin}"
  "$HOME/.cargo/bin"
  "$HOME/bin"
  $path
)

export PATH
