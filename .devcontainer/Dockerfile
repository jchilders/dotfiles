# Linux demo of these dotfiles, for GitHub Codespaces or a local devcontainer.
# macOS-only bits (macos defaults, casks, wezterm pane integration) don't apply.
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG DEBIAN_FRONTEND=noninteractive

# zsh plugins come from apt here (Homebrew on macOS). build-essential is needed
# to compile treesitter parsers; ruby and file are used by the ctrl-o widgets.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    file \
    ruby \
    unzip \
    xclip \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
  && rm -rf /var/lib/apt/lists/*

# zsh-abbr isn't packaged by Ubuntu
RUN git clone --depth 1 --recurse-submodules --shallow-submodules \
    https://github.com/olets/zsh-abbr /usr/share/zsh-abbr

# CLI tools via mise: apt's neovim and fzf are too old for this config. This is
# the system-level mise config, so it survives xdg_config/mise being linked in.
COPY .devcontainer/mise-system.toml /etc/mise/config.toml

USER vscode
ENV PATH=/home/vscode/.local/bin:/home/vscode/.local/share/mise/shims:$PATH
RUN curl -fsSL https://mise.run | sh \
  && mise install --yes

