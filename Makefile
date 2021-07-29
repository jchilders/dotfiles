.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CONFIG_HOME := $$HOME/.config
XDG_DATA_HOME := $$HOME/.local/share

cwd := $(shell pwd)

##@ Install
install: macos xdg-setup -homebrew -homebrew-defaults -fonts -ruby -python -cfg -neovim -tmux -zsh -kitty ## Install all the things

clean: -homebrew-clean -fonts-clean -rvm-clean -neovim-clean -misc-cfg-clean -tmux-clean -zsh-cfg-clean ## Uninstall all the things

cfg: xdg-setup -git-cfg -zsh-cfg -neovim-cfg -tmux-cfg -kitty-cfg misc-cfg ## Link configuration files
	stow --restow --target=$(XDG_CONFIG_HOME)/ starship

cfg-clean: -git-cfg-clean -misc-cfg-clean -neovim-cfg-clean -tmux-cfg-clean -zsh-cfg-clean -kitty-cfg-clean ## Unlink all configuration files

##@ Homebrew
homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

homebrew-defaults: ## Install default homebrew formulae
	brew bundle # see Brewfile

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
	nvim --headless -u $(NEOVIM_CFG_DIR)/config/plugs.vim +PlugInstall +UpdateRemotePlugins +qa

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
ruby: -ruby-cfg -rvm ## Install Ruby-related items

ruby-cfg: ## Link Ruby configuration files
	stow --dir=ruby --target=$$HOME gem
	@[ -d $(XDG_CONFIG_HOME)/pry ] || mkdir $(XDG_CONFIG_HOME)/pry
	stow --dir=ruby --target=$(XDG_CONFIG_HOME)/pry pry

ruby-cfg-clean: ## Unlink Ruby configuration files
	stow --dir=ruby --target=$$HOME --delete gem
	stow --dir=ruby --target=$(XDG_CONFIG_HOME)/pry --delete pry

rvm: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails ; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi
	if [[ ! -f $$HOME/.rvm/gemsets/default.gems ]]; then \
	  cp $(cwd)/default.gems $$HOME/.rvm/gemsets/default.gems; \
	else; \
	  cat $(cwd)/default.gems >> $$HOME/.rvm/gemsets/default.gems; \
	fi; \

rvm-clean: ## Uninstall Ruby Version Manager
	rvm implode

python: -python-packages ## Install Python-related items

# The pynvim package is needed by the vim-ultest plugin
python-packages: ## Install Python packages
	-python3 -m pip install --user --upgrade pynvim

##@ tmux
tmux: -tmux-cfg -tmux-plugins ## Install & configure tmux

tmux-clean: -tmux-cfg-clean ## Uninstall tmux & configuration files
	-rm -rf ~/.tmux

tmux-cfg: ## Link tmux configuration files
	@[ -d $(XDG_CONFIG_HOME)/tmux ] || mkdir -p $(XDG_CONFIG_HOME)/tmux
	stow --restow --target=$(XDG_CONFIG_HOME)/tmux tmux

tmux-cfg-clean: ## Unlink tmux configuration files
	stow --target=$(XDG_CONFIG_HOME)/tmux --delete tmux

tmux-plugins: ## Install plugin manager and other related items
	@[ -d $$HOME/.tmux ] || mkdir $$HOME/.tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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
macos: ## Set macOS defaults and install command line developer tools
ifeq ($(shell uname -s), Darwin)
ifeq ($(XCODE_INSTALLED), 1)
	xcode-select --install
endif
	./macos
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

xdg-setup: ## Create XDG dirs (XDG_CONFIG_HOME, etc.)
	@[ -d $(XDG_CONFIG_HOME) ] || mkdir -p $(XDG_CONFIG_HOME)
	@[ -d $(XDG_DATA_HOME) ] || mkdir -p $(XDG_DATA_HOME)

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
