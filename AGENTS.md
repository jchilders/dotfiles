# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS-focused dotfiles repository implementing the "UNIX is an IDE" philosophy. It integrates zsh, neovim, and wezterm with seamless workflows between terminal, editor, and git operations.

## Key Commands

### Installation
```bash
make install        # Full install (detects OS automatically)
make clean          # Uninstall everything
```

### Individual Targets
```bash
make cfg            # Link xdg_config to ~/.config and bin to ~/bin
make homebrew-bundle # Install Homebrew packages from Brewfile
make neovim         # Build neovim from source (macOS)
make zsh            # Set up zsh with Oh My Zsh
make macos          # Apply macOS system defaults
```

### Neovim Plugins
```bash
nvim --headless +Lazy! sync +qa  # Sync plugins headlessly
:Lazy sync                       # From within neovim
```

## Architecture

### Directory Structure
- `xdg_config/` - Links to `~/.config`, contains all tool configurations
- `bin/` - Links to `~/bin`, custom scripts and utilities
- `.zshenv` - Entry point for zsh, links to `~/.zshenv`
- `Makefile` - Primary installation/management interface
- `Brewfile` - Homebrew package definitions
- `macos` - macOS system defaults script

### Neovim Configuration (`xdg_config/nvim/`)
- `init.lua` - Entry point, bootstraps lazy.nvim
- `lua/core/` - Core settings (options, keymaps, autocmds)
- `lua/plugins/` - Plugin specifications for lazy.nvim
- `lua/jc/` - Custom modules and utilities
- `lua/utils/` - Shared utility functions

### Zsh Configuration (`xdg_config/zsh/`)
- `.zshrc` - Main shell config
- `config/aliases.zsh` - Shell aliases
- `config/ctrlo-widgets.zsh` - `ctrl-o` prefix keybindings (file opening, git operations)
- `config/exports.zsh` - Environment variables
- `config/options.zsh` - Shell options and completions

### Key Integration Points
- `ctrl-o` prefix works in both zsh and neovim for consistent file/git operations
- Wezterm pane integration allows sending text from neovim to adjacent terminal panes
- `<leader>s[dir]` sends current line/selection to adjacent pane in direction (hjkl) for REPL execution

## Style Notes

- Neovim uses lazy.nvim for plugin management
- Lua code follows stylua formatting (see `stylua.toml`)
- Leader key is `<space>` in neovim
