# What?

Configurations for neovim, zsh, tmux, and macOS, with a focus on neovim.

## What You Get
- Neovim nightly
- LSP & tree-sitter integration
- FZF & Telescope integration 
- tmux

Common tasks should require a minimum of keystrokes. Fuzzy finding is preferred over tab completion. 

# Installation

```
> git clone git@github.com:jchilders/dotfiles.git
> cd dotfiles
> make install
```

`make` - List available targets without doing anything

`make install` - Install All The Things. Installs homebrew, rvm, default
homebrew formalae (including tmux), clones & builds neovim from source, and
links all configuration files (dotfiles). Typically used when bootstraping a
new development machine.

`make clean` - Uninstall All The Things

`make neovim` - Install neovim nightly from source, configuration files, and
plugins

`make neovim-clean` - Uninstall neovim nightly from source, configuration
files, and plugins

`make all-cfg` - Links configuration files (dotfiles) only, without installing
neovim or any homebrew formulae.

`make cfg-clean` - Unlink configuration files

`make neovim-cfg` - Install neovim configuration files

`make neovim-cfg-clean` - Uninstall neovim configuration files

Run `make` by itself to see other avalable targets.

## Why Make?

Q: lol why are you using Make?

A: Because I'd never written a Makefile before, and honestly? It works pretty well.

# ctrl-o

For both zsh and nvim commonly used functionality is provided via
<kbd>Ctrl-O</kbd> mappings. There are two basic types of <kbd>Ctrl-O</kbd>
mappings: git-related, and finding & editing files.

## ctrl-o find & edit file mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oc</kbd> | Fuzzy find Rails controller & edit |
| <kbd>^of</kbd> | Fuzzy find file & edit |
| <kbd>^oF</kbd> | Fuzzy find *any* file (ignores `.gitignore`) & edit |
| <kbd>^om</kbd> | Fuzzy find Rails model & edit |
| <kbd>^ov</kbd> | Fuzzy find Rails view & edit |

## ctrl-o git mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oga</kbd> | Fuzzy find uncommited change & add to staging area (`git add`) |
| <kbd>^ogb</kbd> | Switch branch |
| <kbd>^ogd</kbd> | Fuzzy find uncommited change & view diff (`git diff`) |
| <kbd>^ogs</kbd> | Fuzzy find uncommited change & edit (`git status`)|

# Neovim
## Mappings
### Additional Ctrl-O Mappings

Common mappings are given in the <kdb>Ctrl-O</kdb> section above.
Neovim-specific additions are shown here.

| mapping | description | provided by |
| :-----: | :---------- | :---------: |
| <kbd>^ob</kbd> | Fuzzy switch buffer by filename | telescope.nvim |
| <kbd>^or</kbd> | Fuzzy go to symbol (method name, etc.) for current buffer | telescope.nvim |
| <kbd>^oR</kbd> | Fuzzy go to symbol (method name, etc.) for current workspace | telescope.nvim |
| <kbd>^os</kbd> | Search directory for string under cursor | telescope.nvim |

### Other Neovim Mappings

| mapping | description | provided by |
| :-----: | :---------- | :---------: |
| <kbd>,,</kbd> | Switch between next/previous buffers |
| <kbd>,ccs</kbd> | Change (rename) current symbol | neovim LSP |
| <kbd>,fmt</kbd> | Format current buffer | neovim LSP |
| <kbd>,g</kbd> | Toggle gutter | g:ToggleGutter() |
| <kbd>gJ</kbd> | Join code block | splitjoin.vim |
| <kbd>gS</kbd> | Split code block | splitjoin.vim |
| <kbd>,]]</kbd> | Go to next error/warning | neovim LSP |
| <kbd>,[[</kbd> | Go to previous error/warning | neovim LSP |
| <kbd>,e</kbd> | Show error/warning for current line| lspsaga.nvim |
| <kbd>gcc<Space></kbd> | Comment/uncomment current line | kommentary |
| <kbd>gc3j<Space></kbd> | Comment/uncomment current line & 3 down | kommentary |
| <kbd>Enter</kbd> | Clear highlighted search | Native |

### Ruby- and Rails-specific Neovim Mappings
| mapping | description |
| :-----: | :---------- |
| <kbd>,bp</kbd> | Insert `binding.pry` below current line |
| <kbd>,bP</kbd> | Insert `binding.pry` above current line |
| <kbd>,rp</kbd> | Insert `puts` below current line |
| <kbd>,rP</kbd> | Insert `puts` above current line |
| <kbd>,rt</kbd> | Run most recently modified spec in tmux pane to the left |

# zsh

## Mappings
Additional mappings (widgets) available to zsh:

| mapping | description |
| :-----: | :---------- |
| <kbd>^t</kbd> | Fuzzy find file and append to current cursor position |
| <kbd>^r</kbd> | Fuzzy search command history (`^r<enter>` to run last command) |

## Aliases
Defined in `zsh/config/aliases.zsh`

| alias | description |
| :---: | :---------- |
| <kbd>bi</kbd> | `bundle install` |
| <kbd>gcb</kbd> | Copies current branch name to pasteboard (clipboard) |
| <kbd>gd</kbd> | `git diff` |
| <kbd>gst</kbd> |  `git status -sb` |
| <kbd>r</kbd> | Rerun previous command |
| <kbd>rc</kbd> | `rails console` |
| <kbd>rdbm</kbd> | `rake db:migrate` |
| <kbd>rdbms</kbd> | `rake db:migrate:status` |
| <kbd>rdbmt</kbd> | `rake db:migrate RAILS_ENV=test` |
| <kbd>rdbmst</kbd> | `rake db:migrate:status RAILS_ENV=test` |
| <kbd>rs</kbd> | `rails server` |

## Directory Navigation

Use `z`. For example:

```
➜ cd ~/workspace/myrailsproj
➜ pwd
/Users/jchilders/workspace/myrailsproj
➜ cd
➜ pwd
/Users/jchilders
➜ z myr # <-- easy!
➜ pwd
/Users/jchilders/workspace/myrailsproj
```
