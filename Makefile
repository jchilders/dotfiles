.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CACHE_HOME := $(HOME)/.cache
XDG_CONFIG_HOME := $(HOME)/.config
XDG_DATA_HOME := $(HOME)/.local/share
XDG_STATE_HOME := $(HOME)/.local/state
ZDOTDIR := $(XDG_CONFIG_HOME)/zsh

.PHONY: all

cwd := $(shell pwd)

##@ Install
install: macos cfg zsh homebrew-bundle neovim -fonts bat ## Install all the things

clean: ruby-clean cfg-clean neovim-clean zsh-clean homebrew-clean ## Uninstall all the things

cfg: xdg-setup ## Link configuration files
	@[ -e $(XDG_CONFIG_HOME) ] || ln -s $(cwd)/xdg_config $$HOME/.config
	@[ -e $$HOME/bin ] || ln -sf $(cwd)/bin $$HOME/bin

cfg-clean: ## Clean (rm) config $XDG_CONFIG_HOME
	rm $(XDG_CONFIG_HOME)
	rm $$HOME/bin

##@ Homebrew
homebrew: ## Install homebrew
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

homebrew-bundle: homebrew ## Install default homebrew formulae
	eval "$(/opt/homebrew/bin/brew shellenv)"
	eval "$(/opt/homebrew/bin/brew bundle)"

homebrew-clean: ## Uninstall homebrew
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/bash
	rm -r /usr/local/var/homebrew

##@ Neovim

neovim: neovim-clone-or-pull neovim-build-from-source ## Install Neovim

NEOVIM_SRC_DIR := "$$HOME/work/neovim/neovim"
NEOVIM_CFG_DIR := "$(XDG_CONFIG_HOME)/nvim"

neovim-clone-or-pull: ## Clone neovim, or pull the latest
		@mkdir -p $$(dirname $(NEOVIM_SRC_DIR))
		@if [ -d $(NEOVIM_SRC_DIR) ]; then \
				git -C $(NEOVIM_SRC_DIR) pull; \
		else \
				git clone https://github.com/neovim/neovim.git $(NEOVIM_SRC_DIR); \
		fi; \

neovim-build-from-source: ## Install neovim from source
		@for pkg in cmake automake ninja; do \
				if ! which $$pkg >/dev/null; then \
						brew install $$pkg; \
				fi; \
		done; \
		$(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo; \
		sudo $(MAKE) -C $(NEOVIM_SRC_DIR) CMAKE_INSTALL_PREFIX=/usr/local install

neovim-clean: ## Uninstall neovim
		-sudo rm /usr/local/bin/nvim
		-sudo rm /usr/local/bin/vi
		-sudo rm -r /usr/local/lib/nvim
		-sudo rm -r /usr/local/share/nvim
		-brew unlink neovim
		bin/clean_neovim

##@ Languages
asdf-plugins: ## Install plugins needed for asdf to install the given languages
	@if which asdf &> /dev/null ; then \
		asdf plugin add nodejs; \
		asdf plugin add python; \
		asdf plugin add ruby; \
		asdf plugin add rust; \
	fi

ruby: asdf-plugins ruby-cfg ## Install Ruby
	@if which asdf &> /dev/null ; then \
		asdf install ruby latest; \
	fi

ruby-clean: ## Uninstall Ruby
	asdf uninstall ruby latest; \

ruby-cfg: ## Link Ruby configuration files
	ln -sf $(PWD)/ruby/ruby/.irbrc $$HOME

ruby-cfg-clean: ## Unlink Ruby configuration files
	rm $$HOME/.irbrc

##@ zsh
zsh: zsh-cfg ohmyzsh ## Install zsh-related items

zsh-clean: zsh-cfg-env-clean ## Uninstall zsh-related items

zsh-cfg: ## Link ~/.zshenv
	ln -sf $(cwd)/.zshenv $$HOME/.zshenv

ohmyzsh: ## Install Oh My Zsh
	 ZSH=$$XDG_STATE_HOME/ohmyzsh sh -c "$$(http -b GET https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --keep-zshrc

ohmyzsh-clean: ## Uninstall Oh My Zsh
	@if [ -d "$(XDG_STATE_HOME)/ohmyzsh" ]; then \
		rm -rf $(XDG_STATE_HOME)/ohmyzsh; \
	else \
		echo "Oh My Zsh not found in $(XDG_STATE_HOME)"; \
	fi

zsh-cfg-clean: ## Unlink ~/.zshenv
	rm $$HOME/.zshenv

##@ Misc

XCODE_INSTALLED := $(shell uname -s | grep Darwin >/dev/null && xcode-select -p 1>/dev/null; echo $$?)
macos: ## Set macOS defaults and install XCode command line developer tools
ifeq ($(shell uname -s), Darwin)
ifeq ($(XCODE_INSTALLED), 1)
	xcode-select --install
endif
	softwareupdate --install --recommended
	./macos
	killall Dock
endif

bat: ## Get TokyoNight theme for bat
	mkdir -p "$$(bat --config-dir)/themes"
	# Replace _night in the lines below with _day, _moon, or _storm if needed.
	curl -H "Accept: application/xml" -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme --output-dir "$$(bat --config-dir)/themes"
	bat cache --build

fonts: ## Install fonts
	## Font used with toilet banner generator
	cp cosmic.flf $$HOMEBREW_CELLAR/toilet/0.3/share/figlet
	brew install font-blex-mono-nerd-font
	brew install font-source-code-pro-for-powerline

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
	@[ -d $(XDG_CACHE_HOME) ] || mkdir -p $(XDG_CACHE_HOME)
	@[ -d $(XDG_STATE_HOME) ] || mkdir -p $(XDG_STATE_HOME)

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
