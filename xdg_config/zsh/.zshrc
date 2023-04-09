# init homebrew env vars if we haven't already
if [[ ! -v HOMEBREW_PREFIX ]] then
  OS="$(uname)"
  if [[ "${OS}" == "Darwin" ]] then
    UNAME_MACHINE="$(/usr/bin/uname -m)"
    if [[ "${UNAME_MACHINE}" == "arm64" ]] then
      # On ARM macOS, the homebrew installer script installs to /opt/homebrew
      HOMEBREW_PREFIX="/opt/homebrew"
    else
      # On Intel macOS, the homebrew installer script installs to /usr/local
      HOMEBREW_PREFIX="/usr/local"
    fi
  else
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi

  # Add brew-managed bins to path, etc.
  eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

# Load machine-specific config: API keys, etc.
if [[ -f $HOME/.env.local ]]; then
  source $HOME/.env.local
fi

# these need to happen in the given order
foreach file (
  exports.zsh
  options.zsh
  sources.zsh
  aliases.zsh
  ctrlo-widgets.zsh
  misc-widgets.zsh
) {
  source $ZDOTDIR/config/$file
}
unset file

# 1password completions
if type op &>/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

# Sets up GitHub CLI (gh) command to work with 1Password CLI (op)
if [[ -f $XDG_CONFIG_HOME/op/plugins.sh ]]; then
  source /Users/jchilders/.config/op/plugins.sh
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
# .envrc file to the directory to enable loading of project specific envars.
# Then:
# 
# > direnv allow .
#
# to allow the new .envrc file to be loaded for that directory
if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

if type rustup &>/dev/null; then
  . "$HOME/.cargo/env"
fi
