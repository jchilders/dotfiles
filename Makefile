.DEFAULT_GOAL:=help
SHELL:=/bin/zsh
XDG_CACHE_HOME := $(HOME)/.cache
XDG_CONFIG_HOME := $(HOME)/.config
XDG_DATA_HOME := $(HOME)/.local/share
XDG_STATE_HOME := $(HOME)/.local/state
XDG_RUNTIME_DIR ?= $(or $(TMPDIR),/tmp)
ZDOTDIR := $(XDG_CONFIG_HOME)/zsh
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_RUNTIME_DIR ZDOTDIR
BREW_PATHS := /opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin
export PATH := $(BREW_PATHS):$(PATH)
# Homebrew 6 prompts for confirmation before install/upgrade by default
export HOMEBREW_NO_ASK := 1
BREW = $(firstword $(wildcard /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew))

.PHONY: all

cwd := $(shell pwd)
UNAME_S := $(shell uname -s)
IS_DARWIN := $(if $(filter Darwin,$(UNAME_S)),1,0)

##@ Install
install: detect-os ## Install all the things

install-macos: macos cfg zsh homebrew-bundle neovim -toilet-font bat ## Install for macOS

install-linux: cfg zsh-linux homebrew-bundle neovim-plugins ## Install for Linux

clean: cfg-clean zsh-clean homebrew-clean ## Uninstall all the things

detect-os: ## Detect OS and run appropriate install
ifeq ($(IS_DARWIN), 1)
	@$(MAKE) install-macos
else
	@$(MAKE) install-linux
endif

cfg: ## Link configuration files
	@[ -e $$HOME/.config ] || ln -s $(cwd)/xdg_config $$HOME/.config
	@[ -e $$HOME/bin ] || ln -sf $(cwd)/bin $$HOME/bin

cfg-clean: ## Clean (rm) XDG directories
	rm -rf $(XDG_CONFIG_HOME) $(XDG_CACHE_HOME) $(XDG_DATA_HOME) $(XDG_STATE_HOME)
	rm $$HOME/bin

##@ Homebrew
homebrew: ## Install homebrew
	@if [ -n "$(BREW)" ]; then \
		echo "Homebrew already installed"; \
	else \
		echo "Installing Homebrew..."; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

homebrew-bundle: homebrew ## Install default homebrew formulae.(Slow in Docker!)
	@# Homebrew 6.0.0's parallel bundle install races the tap clone against
	@# installing formulae from that tap; pre-tap so the formula is readable.
	brew tap olets/tap || true
	brew bundle

homebrew-bundle-cleanup: ## Uninstall brew packages not listed in the Brewfile
	HOMEBREW_NO_ASK= brew bundle cleanup --force

homebrew-clean: ## Uninstall homebrew
	@prefix="$$(brew --prefix)"; \
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh | /bin/bash; \
	rm -rf "$$prefix/var/homebrew"

##@ Neovim

neovim: homebrew-bundle neovim-plugins ## Install Neovim (via Homebrew) and plugins

neovim-plugins: ## Install Neovim plugins
		@nvim --headless +Lazy! sync +qa

##@ Languages
mise: homebrew-bundle ## Install all languages configured for mise to handle
	mise install

##@ zsh
zsh: zsh-cfg ## Install zsh-related items

zsh-linux: zsh-cfg ## Install zsh for Linux

zsh-clean: zsh-cfg-clean ## Uninstall zsh-related items

zsh-cfg: ## Link ~/.zshenv
	ln -sf $(cwd)/.zshenv $$HOME/.zshenv
	ln -sf $(cwd)/.zshrc $$HOME/.zshrc

zsh-cfg-clean: ## Unlink ~/.zshenv
	rm $$HOME/.zshenv

##@ Misc

XCODE_INSTALLED := $(shell [ "$(IS_DARWIN)" = "1" ] && xcode-select -p 1>/dev/null; echo $$?)
macos: ## Set macOS defaults and install XCode command line developer tools
ifeq ($(IS_DARWIN), 1)
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

toilet-font: ## Install cosmic font for the toilet banner generator
	cp cosmic.flf "$$(brew --prefix toilet)/share/figlet"

ssh-cfg: ## Install ssh related files
	@[ -d $$HOME/.ssh ] || mkdir $$HOME/.ssh

ssh-add-key: -ssh ## Add key to SSH agent
	ssh-add -K ~/.ssh/id_ed25519

misc-cfg: ripgrep-cfg lazygit-cfg ## Miscellany
	@[ -e $$HISTFILE ] || touch $$HISTFILE

misc-cfg-clean: ripgrep-cfg-clean lazygit-cfg-clean ## Unlink misc configs

xdg-setup: ## Create standard XDG Base Directory Specification directories
	@[ -d $(XDG_CONFIG_HOME) ] || mkdir -p $(XDG_CONFIG_HOME)
	@[ -d $(XDG_CACHE_HOME) ] || mkdir -p $(XDG_CACHE_HOME)
	@[ -d $(XDG_DATA_HOME) ] || mkdir -p $(XDG_DATA_HOME)
	@[ -d $(XDG_STATE_HOME) ] || mkdir -p $(XDG_STATE_HOME)
	@if [ "$(IS_DARWIN)" != "1" ]; then \
		[ -d $(XDG_RUNTIME_DIR) ] || mkdir -p $(XDG_RUNTIME_DIR); \
	fi

##@ Helpers

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m\t%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

-%:
	-@$(MAKE) $*
