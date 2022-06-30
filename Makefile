.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CONFIG_HOME := $(HOME)/.config
XDG_DATA_HOME := $(HOME)/.local/share

.PHONY: all

cwd := $(shell pwd)

##@ Install
install: macos cfg homebrew homebrew-bundle alacritty -fonts ruby tmux zsh ## Install all the things

clean: fonts-clean ruby-clean cfg-clean tmux-clean neovim-clean zsh-clean homebrew-clean ## Uninstall all the things

cfg: xdg-setup ## Link configuration files
	ln -s $(cwd)/xdg_config $$HOME/.config
	ln -sf $(cwd)/bin $$HOME/bin

cfg-clean:
	rm $$HOME/.config
	rm $$HOME/bin

##@ Homebrew
homebrew: ## Install homebrew
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

homebrew-bundle: ## Install default homebrew formulae
	eval "$(/opt/homebrew/bin/brew shellenv)"
	brew bundle # see Brewfile

homebrew-clean: ## Uninstall homebrew
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/bash
	rm -r /usr/local/var/homebrew

##@ Neovim

NEOVIM_CFG_DIR := "$(XDG_CONFIG_HOME)/nvim"

neovim: neovim-plugins ## Install Neovim, configurations, & plugins

neovim-plugins: ## Install Neovim plugins
	sh -c 'curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	nvim --headless -u $(NEOVIM_CFG_DIR)/config/plugins.vim +PlugInstall +UpdateRemotePlugins +qa

##@ Terminal Emulator

alacritty: ## Install Alacritty terminal emulator
	brew install --cask alacritty
	@# Need to unquarantine it for macOS Catalina & above
	@if xattr -p com.apple.quarantine /Applications/Alacritty.app &> /dev/null ; then \
	  xattr -d com.apple.quarantine /Applications/Alacritty.app; \
	fi

alacritty-clean: ## Uninstall Alacritty terminal emulator
	brew uninstall --cask alacritty

##@ Languages
ruby: ruby-cfg rvm ## Install Ruby
	$$HOME/.rvm/bin/rvm install --no-docs ruby-3
	$$HOME/.rvm/bin/rvm alias create default ruby-3

ruby-clean: -rvm-clean ## Uninstall Ruby

ruby-cfg: ## Link Ruby configuration files
	ln -sf $(PWD)/ruby/ruby/.irbrc $$HOME
	ln -sf $(PWD)/ruby/gem/.gemrc $$HOME

ruby-cfg-clean: ## Unlink Ruby configuration files
	rm $$HOME/.irbrc
	rm $$HOME/.gemrc

rvm: rvm-receive-keys ## Install Ruby Version Manager
	@if ! which rvm &> /dev/null ; then \
	  curl -sSL https://get.rvm.io | bash -s stable --with-default-gems="bundler rails neovim ripper-tags gemsmith" --ignore-dotfiles; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

rvm-clean: -rvm-delete-keys ## Uninstall Ruby Version Manager
	[ -f $$HOME/.rvmrc ] && rm $$HOME/.rvmrc
	@if which rvm &> /dev/null ; then \
	  rvm implode --force; \
	fi

# This is needed by the rvm target: RVM signs their releases with GPG, so we
# need to import their PKs. Note that this process can be buggy due to the
# keyservers being slow or inoperational.
rvm-receive-keys:
	@if ! gpg --list-keys 409B6B1796C275462A1703113804BB82D39DC0E3 &> /dev/null; then \
		gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 ; \
	fi
	@if ! gpg --list-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB &> /dev/null; then \
		gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; \
	fi

rvm-delete-keys:
	gpg --batch --delete-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

python: -python-packages ## Install Python

# The pynvim package is needed by the vim-ultest plugin
python-packages: ## Install Python packages
	-python3 -m pip install --user --upgrade pynvim
	-python3 -m pip install --user --upgrade black # py code formatter

##@ tmux

tmux_plugins_dir := $(XDG_DATA_HOME)/tmux/tpm

tmux: tmux-plugins ## Link tmux configuration files & install plugins

tmux-clean: tmux-plugins-clean ## Unlink tmux configuration files & uninstall plugins

tmux-plugins: ## Install tmux plugin manager and plugins
	if [ ! -d $(tmux_plugins_dir) ] ; then \
	  git clone https://github.com/tmux-plugins/tpm $(tmux_plugins_dir); \
	fi
	tmux start-server \; source-file $$XDG_CONFIG_HOME/tmux/tmux.conf 

	$(tmux_plugins_dir)/bin/install_plugins

tmux-plugins-clean: ## Uninstall tmux plugins
	-rm -rf $(tmux_plugins_dir)

##@ zsh
zsh: zsh-cfg-env ## Install zsh-related items

zsh-clean: zsh-cfg-env-clean ## Uninstall zsh-related items

zsh-cfg-env: ## Link ~/.zshenv
	ln -sf $(cwd)/.zshenv $$HOME/.zshenv

zsh-cfg-env-clean: ## Unlink ~/.zshenv
	rm $$HOME/.zshenv

##@ Misc

XCODE_INSTALLED := $(shell xcode-select -p 1>/dev/null; echo $$?)
macos: ## Set macOS defaults and install XCode command line developer tools
ifeq ($(shell uname -s), Darwin)
ifeq ($(XCODE_INSTALLED), 1)
	xcode-select --install
endif
	softwareupdate --install --recommended
	./macos
	killall Dock
endif

fonts: ## Install fonts
	## Font used with toilet banner generator
	cp cosmic.flf $$HOMEBREW_CELLAR/toilet/0.3/share/figlet
	brew bundle install --file Brewfile.fonts

fonts-clean: ## Uninstall fonts
	rm $$HOME/Library/Fonts/*
	rm $$HOMEBREW_CELLAR/toilet/0.3/share/figlet/cosmic.flf

ssh-cfg: ## Install ssh related files
	@[ -d $$HOME/.ssh ] || mkdir $$HOME/.ssh

ssh-cfg-clean: ## Install ssh related files

ssh-add-key: -ssh ## Add key to SSH agent
	ssh-add -K ~/.ssh/id_ed25519

misc-cfg: ripgrep-cfg lazygit-cfg ## Miscellany
	@[ -e $$HISTFILE ] || touch $$HISTFILE

misc-cfg-clean: ripgrep-cfg-clean lazygit-cfg-clean ## Unlink misc configs

xdg-setup: ## Create XDG dirs (XDG_CONFIG_HOME, etc.)
	@[ -d $(XDG_DATA_HOME) ] || mkdir -p $(XDG_DATA_HOME)

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
