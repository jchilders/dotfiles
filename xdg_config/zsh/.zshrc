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

# Sets up GitHub CLI (gh) command to work with 1Password CLI (`op`)
if [[ -f $XDG_CONFIG_HOME/op/plugins.sh ]]; then
  source $XDG_CONFIG_HOME/op/plugins.sh
fi

# zoxide: smarter cd
if type zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# prompt. See $XDG_CONFIG_HOME/starship.toml for configuration.
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# fzf fuzzy finder shell integration <ctrl-r> <ctrl-t> <opt-c>
if type fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv" ]; then
  source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
fi
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/jchilders/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/jchilders/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/jchilders/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/jchilders/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<