hello:
	@echo "Hello ${XDG_CONFIG_HOME}"

# Link configuration files
cfg: xdg-setup
	@ln -sf {{invocation_directory()}}/bin $HOME/bin

# Clean XDG dirs (& bin)
cfg-clean:
	@rm $XDG_CONFIG_HOME
	@rm $HOME/bin

# Install homebrew
homebrew:
	sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash

# Setup XDG dirs
xdg-setup:
	@ln -s {{invocation_directory()}}/xdg_config $HOME/.config
	@[ -d ${XDG_DATA_HOME} ] || mkdir -p ${XDG_DATA_HOME}
	@[ -d ${XDG_CACHE_HOME} ] || mkdir -p ${XDG_CACHE_HOME}
