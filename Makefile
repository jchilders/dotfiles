.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CONFIG_HOME := $$HOME/.config
XDG_DATA_HOME := $$HOME/.local/share

cwd := $(shell pwd)

##@ Install
install: macos xdg-setup homebrew homebrew-bundle -fonts -ruby -python -cfg -neovim -tmux -ssh -zsh -kitty ## Install all the things

clean: -homebrew-clean -fonts-clean -rvm-clean -neovim-clean -misc-cfg-clean -tmux-clean -zsh-cfg-clean ## Uninstall all the things

cfg: xdg-setup -git-cfg -zsh-cfg -neovim-cfg -tmux-cfg -kitty-cfg misc-cfg ## Link configuration files
	stow --restow --target=$(XDG_CONFIG_HOME)/ starship

cfg-clean: -git-cfg-clean -misc-cfg-clean -neovim-cfg-clean -tmux-cfg-clean -zsh-cfg-clean -kitty-cfg-clean ## Unlink all configuration files

# This is needed by the rvm target: they sign their releases with GPG, so we
# need to import their PKs.  This process can be buggy due to the keyservers
# being slow or inoperational.
gpg-receive-keys:
	@if ! gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3 &> /dev/null; then \
		gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 ; \
	fi
	@if ! gpg --list-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &> /dev/null; then \
		gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; \
	fi

gpg-delete-keys:
	gpg --batch --delete-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

##@ Homebrew
homebrew: ## Install homebrew
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

homebrew-bundle: ## Install default homebrew formulae
	brew bundle # see Brewfile

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/bash
	rm -r /usr/local/var/homebrew

##@ Neovim

NEOVIM_SRC_DIR := "$$HOME/workspace/neovim"
NEOVIM_CFG_DIR := "$(XDG_CONFIG_HOME)/nvim"

neovim: -neovim-build -neovim-cfg -neovim-plugins ## Install Neovim, configurations, & plugins

neovim-clean: -neovim-cfg-clean ## Uninstall Neovim, configurations, & plugins
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim
	-brew unlink neovim

# Have to build from source rather than just doing 'brew install neovim --HEAD`
# because of an issue with upstream luajit. See:
# https://github.com/neovim/neovim/issues/13529#issuecomment-744375133
neovim-build: ## Build and install neovim nightly from source
	@if [ -d $(NEOVIM_SRC_DIR) ]; then \
		git -C $(NEOVIM_SRC_DIR) pull; \
	else; \
	  git clone https://github.com/neovim/neovim.git $(NEOVIM_SRC_DIR); \
	fi; \
	sudo $(MAKE) -C $(NEOVIM_SRC_DIR) distclean
	$(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo; \
	sudo $(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_INSTALL_PREFIX=/usr/local install; \

neovim-cfg: ## Link neovim configuration files
	@[ -d $(NEOVIM_CFG_DIR) ] || mkdir $(NEOVIM_CFG_DIR)
	stow --restow --target=$(NEOVIM_CFG_DIR) nvim

neovim-cfg-clean: ## Unlink neovim configuration files
	stow --target=$(NEOVIM_CFG_DIR) --delete nvim

neovim-plugins: neovim-cfg ## Install neovim plugins
	sh -c 'curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim --headless -u $(NEOVIM_CFG_DIR)/config/plugins.vim +PlugInstall +UpdateRemotePlugins +qa

##@ Kitty

KITTY_CFG_DIR := "$(XDG_CONFIG_HOME)/kitty"

kitty: kitty-cfg ## Install Kitty terminal emulator

kitty-clean: kitty-cfg-clean ## Remove Kitty terminal emulator

kitty-cfg: ## Link Kitty configuration files
	@[ -d $(KITTY_CFG_DIR) ] || mkdir $(KITTY_CFG_DIR)
	stow --target=$(KITTY_CFG_DIR) kitty

kitty-cfg-clean: ## Unlink Kitty configuration files
	stow --target=$(KITTY_CFG_DIR) --delete kitty

##@ Languages
ruby: ruby-cfg rvm ## Install Ruby
	rvm install ruby-3
	rvm alias create default ruby-3

ruby-clean: ruby-cfg-clean rvm-clean ## Uninstall Ruby

ruby-cfg: ## Link Ruby configuration files
	stow --dir=ruby --target=$$HOME ruby
	stow --dir=ruby --target=$$HOME gem
	@[ -d $(XDG_CONFIG_HOME)/pry ] || mkdir $(XDG_CONFIG_HOME)/pry
	stow --dir=ruby --target=$(XDG_CONFIG_HOME)/pry pry

ruby-cfg-clean: ## Unlink Ruby configuration files
	stow --dir=ruby --target=$$HOME --delete gem
	stow --dir=ruby --target=$(XDG_CONFIG_HOME)/pry --delete pry

rvm: gpg-receive-keys ## Install Ruby Version Manager
	@if ! which rvm &> /dev/null ; then \
	  curl -sSL https://get.rvm.io | bash -s stable --with-default-gems="bundler rails solargraph neovim ripper-tags" --ignore-dotfiles; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

rvm-clean: -gpg-delete-keys ## Uninstall Ruby Version Manager
	rvm implode --force

python: -python-packages ## Install Python

# The pynvim package is needed by the vim-ultest plugin
python-packages: ## Install Python packages
	-python3 -m pip install --user --upgrade pynvim

tmux: tmux-cfg tmux-plugins ## Install & configure tmux

tmux-clean: -tmux-cfg-clean ## Uninstall tmux & configuration files
	-rm -rf ~/.tmux

tmux-cfg: ## Link tmux configuration files
	@[ -d $(XDG_CONFIG_HOME)/tmux ] || mkdir -p $(XDG_CONFIG_HOME)/tmux
	stow --restow --target=$(XDG_CONFIG_HOME)/tmux tmux

tmux-cfg-clean: ## Unlink tmux configuration files
	stow --target=$(XDG_CONFIG_HOME)/tmux --delete tmux

tmux-plugins: ## Install plugin manager and other related items
	@[ -d $$HOME/.tmux ] || mkdir $$HOME/.tmux
	git clone https://github.com/tmux-plugins/tpm $$HOME/.tmux/plugins/tpm

##@ WezTerm
wezterm: -wezterm-cfg ## Install WezTerm terminal emulator
	brew install --cask wezterm-nightly --no-quarantine

wezterm-cfg: ## Link WezTerm configuration files
	@[ -d $(XDG_CONFIG_HOME)/wezterm ] || mkdir $(XDG_CONFIG_HOME)/wezterm
	stow --target=$(XDG_CONFIG_HOME)/wezterm wezterm

##@ zsh
zsh: -zsh-cfg ## Install zsh-related items

.PHONY : zsh-cfg
zsh-cfg: ## Link zsh configuration files
	ln -sf $(cwd)/.zshenv $$HOME/.zshenv
	@[ -d $(XDG_CONFIG_HOME)/zsh ] || mkdir $(XDG_CONFIG_HOME)/zsh
	stow --restow --target=$(XDG_CONFIG_HOME)/zsh zsh
	@[ -d $(XDG_DATA_HOME)/zsh ] || mkdir $(XDG_DATA_HOME)/zsh

zsh-cfg-clean: ## Unlink zsh configuration files
	stow --target=$(XDG_CONFIG_HOME)/zsh --delete zsh
	-rm $$HOME/.zshenv

##@ Misc

.PHONY : macos
XCODE_INSTALLED := $(shell xcode-select -p 1>/dev/null; echo $$?)
macos: ## Set macOS defaults and install XCode command line developer tools
ifeq ($(shell uname -s), Darwin)
ifeq ($(XCODE_INSTALLED), 1)
	xcode-select --install
endif
	./macos
	killall Dock
endif

fonts: ## Install fonts
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip
	## We are using this font with toilet banner generator tool
	cp cosmic.flf /usr/local/Cellar/toilet/0.3/share/figlet

fonts-clean: ## Uninstall fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf
	rm /usr/local/Cellar/toilet/0.3/share/figlet/cosmic.flf

git-cfg: ## Link git configuration files
	stow --target=$$HOME git

git-cfg-clean: ## Unlink git configuration files
	-stow --target=$$HOME --delete git

misc-cfg: ## Miscellany
	@[ -e $$HISTFILE ] || touch $$HISTFILE

misc-cfg-clean: ## Unlink misc configs
	stow --target=$(XDG_CONFIG_HOME) --delete starship
	stow --target=$(XDG_CONFIG_HOME)/kitty --delete kitty

ssh: ## Install ssh related files
	@[ -d $$HOME/.ssh ] || mkdir $$HOME/.ssh
	stow --target=$$HOME/.ssh .ssh

ssh-add-key: -ssh ## Add key to SSH agent
	ssh-add -K ~/.ssh/id_ed25519

##@ tmux

xdg-setup: ## Create XDG dirs (XDG_CONFIG_HOME, etc.)
	@[ -d $(XDG_CONFIG_HOME) ] || mkdir -p $(XDG_CONFIG_HOME)
	@[ -d $(XDG_DATA_HOME) ] || mkdir -p $(XDG_DATA_HOME)

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
