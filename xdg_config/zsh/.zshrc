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

  # Add brew-managed bins to path
  [ -f $HOMEBREW_PREFIX/bin/brew ] && eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

# Load machine-specific config: API keys, etc.
if [[ -f $HOME/.env.local ]]; then
  source $HOME/.env.local
fi

# these need to happen in the given order
foreach file (
  exports.zsh
  sources.zsh
  aliases.zsh
  ctrlo-widgets.zsh
  misc-widgets.zsh
) {
  source $ZDOTDIR/config/$file
}
unset file

# Oh My Zsh
# Skip only aliases defined in the directories.zsh lib file
zstyle ':omz:lib:directories' aliases no

export ZSH="$XDG_STATE_HOME/ohmyzsh"
ZSH_THEME="robbyrussell"
plugins=(
  dotenv
  mise
  zoxide
)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# This needs to happen after omz to ensure our options are preserved
source $ZDOTDIR/config/options.zsh

# 1password completions
if type op &>/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

# Sets up GitHub CLI (gh) command to work with 1Password CLI (`op`)
if [[ -f $XDG_CONFIG_HOME/op/plugins.sh ]]; then
  source $XDG_CONFIG_HOME/op/plugins.sh
fi

# prompt. See $XDG_CONFIG_HOME/starship.toml for configuration.
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# fzf fuzzy finder shell integration <ctrl-r> <ctrl-t> <opt-c>
if type fzf &>/dev/null; then
  eval "$(fzf --zsh)"
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

# bun completions
[ -s "$XDG_DATA_HOME/bun/_bun" ] && source "$XDG_DATA_HOME/bun/_bun"

# zsh-abbr: must be sourced AFTER fzf and other tools that rebind keys
if command -v brew >/dev/null; then
  [ -f $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh ] && source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh
  load-abbreviations  # defined in aliases.zsh
fi
