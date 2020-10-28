#!/bin/bash

# This is a WIP; not fully tested

# homebrew
if ! command -v brew &> /dev/null
then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
fi

brew install fish        # shell
brew install starship    # prompt

# The basics
brew install git tmux gpg nvim ag bat fzf stow tree exa
brew install git-delta

# If installing neovim from source:
#  make distclean
#  make CMAKE_BUILD_TYPE=RelWithDebInfo
#  sudo make CMAKE_INSTALL_PREFIX=/usr/local install

nvim +PlugInstall

# fisher plugin manager - https://github.com/jorgebucaran/fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fisher add jethrokuan/z
fisher add jethrokuan/fzf
fisher add decors/fish-colored-man # colored man pages

gem install solargraph  # solargraph Ruby LSP server
gem install neovim      # neovim plugin for Ruby

# rvm
curl -sSL https://get.rvm.io | bash -s stable

# dotfiles git repo
if [ ! -d "$HOME/workspace" ]
then
  mkdir $HOME/workspace
fi

cd $HOME/workspace
if [ ! -d "$HOME/workspace/dotfiles" ]
then
  git clone https://github.com/jchilders/dotfiles.git
fi
cd dotfiles

# gnu stow to create links to ~/.config
stow --target=$HOME tmux
stow --target=$HOME fish
stow --target=$HOME nvim
stow --target=$HOME git
