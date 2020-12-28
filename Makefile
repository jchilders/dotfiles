.DEFAULT_GOAL:=help
SHELL:=/bin/zsh

##@ Install

.PHONY: install

install: -macos -homebrew -default-formula -fish -nerd -ruby -stow -neovim ## Install all the things

macos: ## macOS-specific pieces
	-xcode-select --install
	./macos

homebrew: ## Install homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

default-formula: ## Install default homebrew formulae
	brew install git tmux gpg ag bat fzf stow tree exa git-delta starship fd

fish: -fish-install -fish-sh-add -fish-chsh -fish-fisher -fish-finalize ## Install fish & set default shell

fish-install: ## Install fish shell
	brew install fish

FISH = $(shell which fish)
FISH_IN_ETC = $(shell cat /etc/shells | grep -Fq '$(FISH)'; echo $$?)

fish-sh-add: ## Add fish to /etc/shells
ifneq (0,$(FISH_IN_ETC))
  $(shell which fish | sudo tee -a /etc/shells)
endif
	
fish-chsh: ## Change user's shell to fish
	$(info Changing shell to $(FISH))
	$(shell chsh -s $(FISH))

fish-fisher: ## Install fisher plugin manager
	curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
	fish --command 'fisher install jethrokuan/z'
	fish --command 'fisher install PatrickF1/fzf.fish'
	fish --command 'fisher install decors/fish-colored-man'

fish-finalize: ## Things to run after fish has been installed
	fish --command 'fish_update_completions'

nerd: ## Install nerd font (Needed for prompt)
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/AnonymousPro.zip
	unzip -n AnonymousPro.zip -x 'Anonymice Nerd Font Complete Windows Compatible.ttf' 'Anonymice Nerd Font Complete Mono Windows Compatible.ttf' -d $$HOME/Library/Fonts
	rm AnonymousPro.zip

neovim: -neovim-install -neovim-plugs ## Install NeoVim & plugins

NEOVIM_SRC_DIR = "$$HOME/workspace/neovim"

neovim-install: ## Compile, build, and install neovim from source
ifeq (, $(shell which cmake))
	$(shell brew install cmake)
endif
ifeq (, $(shell which automake))
	$(shell brew install automake)
endif
	@if [ -d $(NEOVIM_SRC_DIR) ]; then \
		git -C $(NEOVIM_SRC_DIR) pull; \
	else; \
	  git clone https://github.com/neovim/neovim.git $(NEOVIM_SRC_DIR); \
	fi; \
	$(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo; \
	sudo $(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_INSTALL_PREFIX=/usr/local install; \
	ln -s /usr/local/bin/nvim /usr/local/bin/vi; \

neovim-plugs: ## Install neovim plugins
	nvim --headless +PlugInstall +qa

ruby: -rvm-install -ruby-gems ## Install Ruby-related items

RVM_EXISTS = $(shell which -s rvm &>/dev/null; echo $$?)
rvm-install: ## Install Ruby Version Manager
	@if [[ `which rvm &>/dev/null && $?` != 0 ]]; then \
	  curl -sSL https://get.rvm.io | bash -s stable --rails; \
	else \
	  print 'RVM already installed. Doing nothing'; \
	fi

ruby-gems: ## Install default gems
	rvm gemset use global
	gem install solargraph neovim ripper-tags

stow: ## Link config files
	stow -v -R --target=$$HOME tmux
	stow -v -R --target=$$HOME fish
	stow -v -R --target=$$HOME nvim
	stow -v -R --target=$$HOME git
	stow -v -R --target=$$HOME ruby

##@ Clean

.PHONY: clean

clean: -homebrew-clean -nerd-clean -rvm-clean -neovim-clean -misc-clean -fish-clean ## Uninstall all the things

homebrew-clean: ## Uninstall homebrew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/zsh
	rm -r /usr/local/var/homebrew

rvm-clean: ## Uninstall rvm
	rvm implode
	rm -rf $HOME/.rvm

nerd-clean: ## Uninstall nerd fonts
	rm $$HOME/Library/Fonts/Anonymice*.ttf

neovim-clean: ## Uninstall neovim
	-sudo rm /usr/local/bin/nvim
	-sudo rm /usr/local/bin/vi
	-sudo rm -r /usr/local/lib/nvim
	-sudo rm -r /usr/local/share/nvim

misc-clean: ## Uninstall misc files
	-rm -rf ~/.gnupg
	-rm -rf ~/.config

zsh-chsh: ## Change user's shell to zsh
	chsh -s $(shell which zsh)

fish-sh-clean: ## Remove fish
	brew uninstall fish
	rm -rf ~/.local/share/fish
	sudo sed -i '' '/fish/d' /etc/shells

fisher-clean: ## Uninstall fisher plugin manager
	rm ~/.config/fish/functions/fisher.fish
	rm -rf ~/.config/fish/fisher_plugins

fish-clean: -fish-clean -fish-sh-clean -zsh-chsh -fisher-clean ## Remove fish & reset default shell

##@ Helpers

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
