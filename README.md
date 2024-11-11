# What?

Configurations for neovim, zsh, wezterm, and macOS, with a focus on neovim.

## What You Get
- Neovim nightly
- LSP & tree-sitter integration
- FZF & Telescope integration 
- sane wezterm config

Common tasks should require a minimum of keystrokes. Fuzzy finding is preferred
over tab completion. File trees are for the weak.

# Installation

```
> git clone git@github.com:jchilders/dotfiles.git
> cd dotfiles
> make install
```

`make` - List available targets without doing anything

`make install` - Install All The Things. Installs homebrew, default
homebrew formalae (including tmux), clones & builds neovim from source, and
links all configuration files (dotfiles). Typically used when bootstraping a
new development machine.

`make clean` - Uninstall All The Things

`make cfg` - Links configuration files (dotfiles) only, without installing
neovim or any homebrew formulae.

`make cfg-clean` - Unlink configuration files

`make neovim` - Install neovim nightly from source, configuration files, and
plugins

`make neovim-clean` - Uninstall neovim nightly from source, configuration
files, and plugins

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

## ctrl-o file mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oo</kbd> | Find file & edit |
| <kbd>^oO</kbd> | Find *any* file (ignores `.gitignore`) & edit |
| <kbd>^orc</kbd> | Find Rails controller & edit |
| <kbd>^orm</kbd> | Find Rails model & edit |
| <kbd>^orv</kbd> | Find Rails view & edit |

## ctrl-o git mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oga</kbd> | Find uncommited changed file & add to staging area (`git add`) |
| <kbd>^ogb</kbd> | Switch branch |
| <kbd>^ogd</kbd> | Find uncommited changed file & show diff (`git diff`) |
| <kbd>^ogs</kbd> | Find uncommited changed file & edit (`git status`)|

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

### Other Noteworthy Neovim Mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>Enter</kbd> | Clear highlighted search |
| <kbd>,,</kbd> | Switch between next/previous buffers |
| <kbd>,ccs</kbd> | Change (rename) current symbol |
| <kbd>,g</kbd> | Toggle gutter | g:ToggleGutter() |
| <kbd>,]]</kbd> | Go to next error/warning |
| <kbd>,[[</kbd> | Go to previous error/warning |
| <kbd>,e</kbd> | Show error/warning for current line|
| <kbd>gc.</kbd> | Comment/uncomment code block (treesitter based)|
| <kbd>gc<motion></kbd> | Comment/uncomment <motion> |
| <kbd>gcc</kbd> | Comment/uncomment current line |

### Ruby- and Rails-specific Neovim Mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>,bp</kbd> | Insert `binding.pry` below current line |
| <kbd>,bP</kbd> | Insert `binding.pry` above current line |
| <kbd>,rp</kbd> | Insert `puts` below current line |
| <kbd>,rP</kbd> | Insert `puts` above current line |
| <kbd>,rr</kbd> | Restart console running in tmux pane to the left |
| <kbd>,rt</kbd> | Run most recently modified spec in tmux pane to the left |

### Sending to Tmux

| mapping | description |
| :-----: | :---------- |
| <kbd>,sl</kbd> | Send current line to tmux pane to the left |
| <kbd>,sl</kbd> | Send current selection to tmux pane to the left |

# zsh

## Mappings
Additional mappings (widgets) available to zsh:

| mapping | description |
| :-----: | :---------- |
| <kbd>^t</kbd> | Find file and append to current cursor position |
| <kbd>^r</kbd> | Search command history (`^r<enter>` to run last command) |

## Aliases

| alias | description |
| :---: | :---------- |
| <kbd>bi</kbd> | `bundle install` |
| <kbd>fc</kbd> | Edit last command in $EDITOR
| <kbd>gcb</kbd> | Copies current branch name to pasteboard (clipboard) |
| <kbd>gd</kbd> | `git diff` |
| <kbd>gst</kbd> |  `git status -sb` |
| <kbd>r</kbd> | Rerun previous command |
| <kbd>rc</kbd> | `bin/rails console`, or `bin/console` if in a Gem directory |
| <kbd>rdbm</kbd> | `rake db:migrate` |
| <kbd>rdbms</kbd> | `rake db:migrate:status` |
| <kbd>rdbmt</kbd> | `rake db:migrate RAILS_ENV=test` |
| <kbd>rdbmst</kbd> | `rake db:migrate:status RAILS_ENV=test` |
| <kbd>rs</kbd> | `rails server` |

## Directory Navigation

Uses `zoxide`. For example:

```
➜ cd ~/work/myrailsproj
➜ pwd
/Users/jchilders/work/myrailsproj
➜ cd
➜ pwd
/Users/jchilders
➜ z myr
➜ pwd
/Users/jchilders/work/myrailsproj
```
