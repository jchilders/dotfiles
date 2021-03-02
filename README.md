This repo was originally created to help me get new laptops spun up. I was doing many of the same steps over and over again, and [grew tired of it](https://m.xkcd.com/1205/). It is targeted towards Ruby on Rails development.

The core stack is tmux, zsh, and neovim.

# Installation

```
> make install
```

Or to see a list of individual targets:

```
> make

Usage:
  make

Install
  install          Install all the things
  macos            macOS-specific pieces
  homebrew         Install homebrew
  default-formula  Install default homebrew formulae
  nerd             Install nerd font (Needed for prompt)
  neovim           Install NeoVim & plugins
  neovim-install   Install neovim
  neovim-plugs     Install neovim plugins
  ruby             Install Ruby-related items
  rvm-install      Install Ruby Version Manager
  ruby-gems        Install default gems
  stow             Link config files
  zinit            Install plugin manager for zsh

Clean
  clean            Uninstall all the things
  homebrew-clean   Uninstall homebrew
  rvm-clean        Uninstall rvm
  nerd-clean       Uninstall nerd fonts
  neovim-clean     Uninstall neovim
  misc-clean       Uninstall misc files
  zsh-clean        Uninstall zsh-related items

Helpers
  help             Display this help
```

# Hotkeys
## zsh
### Widgets
These widgets are available at the prompt.

| mapping | description |
| :-----: | :---------- |
|`^oa` | Fuzzy find modified file & add to staging area (`git add`) |
|`^oc` | Fuzzy find Rails controller & edit |
|`^od` | Fuzzy find modified file & diff |
|`^of` | Fuzzy find *any* file (ignores `.gitignore`) & edit |
|`^om` | Fuzzy find Rails model & edit |
|`^ov` | Fuzzy find Rails view & edit |
|`^t` | Fuzzy find file and append to current cursor position |
|`^r` | Fuzzy search command history (`^r<enter>` to run last command) |

### Aliases
Defined in `zsh/config/aliases.zsh`

| alias | description |
| :-----: | :---------- |
|`bi` | `bundle install` |
|`gcb` | Copies current branch name to pasteboard (clipboard) |
|`gd` | `git diff` |
|`gst` |  `git status -sb` |
|`rc` | `rails console` |
|`rdbm` | `rake db:migrate` |
|`rdbms` | `rake db:migrate:status` |
|`rs` | `rails server` |

## Neovim

Leader key is `,`.

### Mappings
See `nvim/config/mappings.vim` for complete list.

| mapping | description | provided by |
| :-----: | :---------- | :---------: |
| `^ob` | Fuzzy switch buffer by filename | telescope.nvim |
| `^of` | Fuzzy find file & edit | telescope.nvim |
| `^or` | Find referencess to current symbol | telescope.nvim |
| `^os` | Go to symbol (method, global, etc.) | telescope.nvim |
| `,ccs` | Change (rename) current symbol | neovim LSP |
| `gJ` | Join code block | splitjoin.vim |
| `gS` | Split code block | splitjoin.vim |

