FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Avoid warnings by switching to noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# Create the dot user
RUN useradd -m -s /bin/bash dot \
    && echo "dot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dot \
    && chmod 0440 /etc/sudoers.d/dot

USER dot

# Set environment variables
ENV XDG_CACHE_HOME=/home/dot/.cache \
    XDG_CONFIG_HOME=/home/dot/.config \
    XDG_DATA_HOME=/home/dot/.local/share

# Create XDG directories
RUN mkdir -p ${XDG_DATA_HOME} \
    && mkdir -p ${XDG_CACHE_HOME} \
    && mkdir -p ${XDG_CONFIG_HOME} \
    && chown -R dot:dot /home/dot/.local \
    && chown -R dot:dot ${XDG_CONFIG_HOME} \
    && chown -R dot:dot ${XDG_CACHE_HOME}

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
    xclip \
    && sudo ln -s $(which batcat) /usr/local/bin/bat \
    && sudo rm -rf /var/lib/apt/lists/*

# Install git-delta
RUN cd /tmp \
    && ARCH=$(dpkg --print-architecture) \
    && wget https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_${ARCH}.deb \
    && sudo dpkg -i git-delta_0.17.0_${ARCH}.deb \
    && rm git-delta_0.17.0_${ARCH}.deb

# Install gotop
RUN cd /tmp \
    && ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then GOTOP_ARCH="amd64"; else GOTOP_ARCH="arm64"; fi \
    && wget https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_${GOTOP_ARCH}.deb \
    && sudo dpkg -i gotop_v4.2.0_linux_${GOTOP_ARCH}.deb \
    && rm gotop_v4.2.0_linux_${GOTOP_ARCH}.deb

# Skip gping and lazygit for now - they don't have consistent ARM64 releases
# Users can install these manually if needed

# Install zoxide
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Note: Skipping atuin, tealdeer, yank, mise due to ARM64 compatibility issues
RUN curl https://mise.run | sh

# Install eza (ls replacement)
RUN sudo mkdir -p /etc/apt/keyrings \
  && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list \
  && sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list \
  && sudo apt update \
  && sudo apt install -y eza

# Setup directories
RUN mkdir -p /home/dot/.ssh \
    && chmod 700 /home/dot/.ssh \
    && mkdir ${XDG_CACHE_HOME}/zsh \
    && touch ${XDG_CACHE_HOME}/zsh/.zsh_history

# Create pbcopy/pbpaste aliases for Linux
RUN echo 'alias pbcopy="xclip -selection clipboard"' >> /home/dot/.bashrc \
    && echo 'alias pbpaste="xclip -selection clipboard -o"' >> /home/dot/.bashrc

# Copy zshenv file
COPY .zshenv /home/dot/.zshenv
RUN sudo chown dot:dot /home/dot/.zshenv

# Since we use .zshenv instead of .rshrc, delete the .zshrc that comes from the base image
# RUN rm /home/dot/.zshrc

# Copy XDG config files
COPY xdg_config/ ${XDG_CONFIG_HOME}/
RUN sudo chown -R dot:dot ${XDG_CONFIG_HOME}

# Install starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null

# On Linux, the `fd` binary is called `fdfind`. Create a symlink to `fd` for easier usage.
RUN if [ "$(uname)" = "Linux" ]; then sudo ln -s $(which fdfind) /usr/local/bin/fd; fi

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
