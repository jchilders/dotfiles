# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Install basic dependencies including Homebrew requirements
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zsh \
    make \
    build-essential \
    gcc \
    procps \
    file \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create user with sudo access for Homebrew
RUN useradd -m -s /bin/zsh dot && \
    echo "dot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to dot user and install Homebrew
USER dot
WORKDIR /home/dot
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

# Create dotfiles directory and copy Brewfile first for better caching
RUN mkdir -p /home/dot/dotfiles
COPY --chown=dot:dot Brewfile /home/dot/dotfiles/Brewfile
WORKDIR /home/dot/dotfiles
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && /home/linuxbrew/.linuxbrew/bin/brew bundle || true

# Copy rest of dotfiles
COPY --chown=dot:dot . /home/dot/dotfiles

# Install remaining dotfiles config
RUN make cfg zsh-linux neovim-linux

# Setup bat with TokyoNight theme
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && mkdir -p "$(bat --config-dir)/themes" \
    && curl -H "Accept: application/xml" \
    -o "$(bat --config-dir)/themes/tokyonight_night.tmTheme" \
    https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme \
    && bat cache --build

# Set zsh as default shell
CMD ["/bin/zsh"]
