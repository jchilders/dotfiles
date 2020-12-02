#!/bin/zsh

# To install:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jchilders/dotfiles/master/bootstrap.sh)"

# homebrew
#if ! command -v brew &> /dev/null
#then
#  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#fi
#
## The basics
#brew install --quiet git tmux gpg ag bat fzf stow tree exa git-delta
#
#brew install --quiet fish        # fish shell
#if ! grep -Fq "/usr/local/bin/fish" /etc/shells
#then
#  echo "Adding $(which fish) to /etc/shells and changing default"
#  which fish | sudo tee -a /etc/shells
#  chsh -s $(which fish)
#fi
#
#brew install --quiet starship    # prompt
#
## rvm
# fix public key errors when installing rvm
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable

source ~/.bashrc
rvm install 2.7
rvm default 2.7
rvm use 2.7

if [ ! -d "$HOME/workspace/neovim" ]
then
  git clone https://github.com/neovim/neovim.git $HOME/workspace/neovim
fi

if ! command -v neovim &> /dev/null
then
  brew install cmake automake
  cd $HOME/workspace/neovim
  make distclean
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make CMAKE_INSTALL_PREFIX=/usr/local install
fi

# clone my dotfiles git repo
if [ ! -d "$HOME/workspace/dotfiles" ]
then
  git clone https://github.com/jchilders/dotfiles.git $HOME/workspace/dotfiles
fi
cd $HOME/workspace/dotfiles

# gnu stow to create links to ~/.config
stow --target=$HOME tmux
stow --target=$HOME fish
stow --target=$HOME nvim
stow --target=$HOME git

nvim --headless +PlugInstall +qa

gem install solargraph  # Solargraph Ruby LSP server
gem install neovim      # Ruby plugin for neovim

## fisher plugin manager - https://github.com/jorgebucaran/fisher
#curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
#
#fish --command 'fisher install jethrokuan/z'
#fish --command 'fisher install jethrokuan/fzf'
#fish --command `fisher install decors/fish-colored-man' # colored man pages
#
## Set macOS defaults
##./macos

