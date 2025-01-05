FROM mcr.microsoft.com/devcontainers/base:ubuntu as asdf-install

# Avoid warnings by switching to noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# Create the dotfiles user
RUN useradd -m -s /bin/bash dotfiles \
    && echo "dotfiles ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dotfiles \
    && chmod 0440 /etc/sudoers.d/dotfiles

USER dotfiles

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1 \
    && echo 'source "$HOME/.asdf/asdf.sh"' >> ~/.zshrc \
    && mkdir -p ~/.config/zsh/completions \
    && echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> ~/.zshrc \
    && echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

# Set environment variables
ENV XDG_CACHE_HOME=/home/dotfiles/.cache \
    XDG_CONFIG_HOME=/home/dotfiles/.config \
    XDG_DATA_HOME=/home/dotfiles/.local/share

# Create XDG directories
RUN mkdir -p ${XDG_DATA_HOME} \
    && mkdir -p ${XDG_CACHE_HOME} \
    && mkdir -p ${XDG_CONFIG_HOME} \
    && chown -R dotfiles:dotfiles /home/dotfiles/.local \
    && chown -R dotfiles:dotfiles ${XDG_CONFIG_HOME} \
    && chown -R dotfiles:dotfiles ${XDG_CACHE_HOME}

# Install basic dependencies and development tools
RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    automake \
    ripgrep \
    fd-find \
    bat \
    curl \
    gpg \
    wget \
    git \
    tree \
    htop \
    jq \
    neovim \
    libffi-dev \
    libyaml-dev \
    unzip \
    fzf \
    pkg-config \
    && sudo ln -s $(which batcat) /usr/local/bin/bat \
    && sudo rm -rf /var/lib/apt/lists/*

# Install eza (ls replacement)
RUN sudo mkdir -p /etc/apt/keyrings \
  && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list \
  && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list \
  && sudo apt update \
  && sudo apt install -y eza

# Setup directories
RUN mkdir -p /home/dotfiles/.ssh \
    && chmod 700 /home/dotfiles/.ssh \
    && mkdir ${XDG_CACHE_HOME}/zsh \
    && touch ${XDG_CACHE_HOME}/zsh/.zsh_history

# Copy zshenv file
COPY .zshenv /home/dotfiles/.zshenv
RUN sudo chown dotfiles:dotfiles /home/dotfiles/.zshenv

# Since we use .zshenv instead of .rshrc, delete the .zshrc that comes from the base image
RUN rm /home/dotfiles/.zshrc

# Copy XDG config files
COPY xdg_config/ ${XDG_CONFIG_HOME}/
RUN sudo chown -R dotfiles:dotfiles ${XDG_CONFIG_HOME}

# Install starship prompt
RUN curl -sS https://starship.rs/install.sh --yes | sh
# Switch to the asdf-install image so that we can run asdf commands
FROM asdf-install AS dotfiles-install

# Ensure we use zsh for all RUN commands.
# `-lic` is used to use the interactive login shell, which ensures that zsh config files are loaded before subsequent RUN commands are executed.
SHELL ["/bin/zsh", "-lic"]

# RUN asdf plugin add ruby \
#     && asdf install ruby latest \
#     && asdf global ruby latest

FROM dotfiles-install

# RUN gem install bundler

# On Linux, the `fd` binary is called `fdfind`. Create a symlink to `fd` for easier usage.
RUN [[ $(uname) == "Linux" ]] && sudo ln -s $(which fdfind) /usr/local/bin/fd

# Setup bat with TokyoNight theme
RUN mkdir -p "$(bat --config-dir)/themes" \
    && curl -H "Accept: application/xml" \
    -o "$(bat --config-dir)/themes/tokyonight_night.tmTheme" \
    https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme \
    && bat cache --build

# WORKDIR /workspace
#
# # Switch back to dialog for any ad-hoc use of apt-get
# ENV DEBIAN_FRONTEND=dialog
