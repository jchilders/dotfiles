# Test image for `make install` on a fresh Ubuntu machine.
# Homebrew refuses to run as root, so create a passwordless-sudo user.
# Used by .github/workflows/install-test.yml; run locally with:
#   docker build -t dotfiles-test .github/ubuntu-install-test
#   docker run --rm -v "$PWD":/src:ro dotfiles-test \
#     zsh -c 'cp -r /src ~/dotfiles && cd ~/dotfiles && make install'
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential procps curl file git zsh sudo make ca-certificates unzip \
    && rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/zsh tester \
    && echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester
USER tester
ENV HOME=/home/tester
WORKDIR /home/tester
