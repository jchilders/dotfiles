#!/bin/bash

# This is a WIP; not fully tested

# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install fish        # shell
brew install starship    # prompt

# The basics
brew install tmux gpg nvim ag bat fzf stow tree diff-so-fancy exa

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
