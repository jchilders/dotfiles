Zsh/Neovim/Tmux configurations targeted towards Rails development under macOS. A design goal is to be able to do as much work as possible without your hands ever needing to leave the home row.

The core toolchain is tmux, zsh, neovim, and fzf.

# Installation

'make install` - Installs homebrew, Ruby, default homebrew formalae (including tmux),
builds Neovim from source, and links all config files. Typically used when
spinning up a new laptop.
`make stow` - Link config files (dotfiles) only
`make` - See all avaialable targets

# zsh
## Mappings
These mappings (zsh calls them "widgets") are available:

| mapping | description |
| :-----: | :---------- |
| `^oa` | Fuzzy find modified file & add to staging area (`git add`) |
| `^oc` | Fuzzy find Rails controller & edit |
| `^od` | Fuzzy find modified file & diff |
| `^of` | Fuzzy find *any* file (ignores `.gitignore`) & edit |
| `^om` | Fuzzy find Rails model & edit |
| `^os` | Fuzzy find modified file & edit
| `^ov` | Fuzzy find Rails view & edit |
| `^t` | Fuzzy find file and append to current cursor position |
| `^r` | Fuzzy search command history (`^r<enter>` to run last command) |

## Aliases
Defined in `zsh/config/aliases.zsh`

| alias | description |
| :---: | :---------- |
| `bi` | `bundle install` |
| `gcb` | Copies current branch name to pasteboard (clipboard) |
| `gd` | `git diff` |
| `gst` |  `git status -sb` |
| `rc` | `rails console` |
| `rdbm` | `rake db:migrate` |
| `rdbms` | `rake db:migrate:status` |
| `rdbmt` | `rake db:migrate RAILS_ENV=test` |
| `rdbmst` | `rake db:migrate:status RAILS_ENV=test` |
| `rs` | `rails server` |

# Neovim

Leader key is `,`.

## Mappings
See `nvim/config/mappings.vim` for a more complete list. Ruby-specific mappings are kept in `nvim/after/ftplugin/ruby.vim`.

| mapping | description | provided by |
| :-----: | :---------- | :---------: |
| `^ob` | Fuzzy switch buffer by filename | telescope.nvim |
| `^oc` | Fuzzy find Rails controller & edit | telescope.nvim |
| `^of` | Fuzzy find file & edit | telescope.nvim |
| `^om` | Fuzzy find Rails model & edit | telescope.nvim |
| `^or` | Fuzzy go to symbol (method name, etc.) | telescope.nvim |
| `^os` | Fuzzy find modified file & edit | telescope.nvim |
| `^ov` | Fuzzy find Rails view & edit | telescope.nvim |
| `,ccs` | Change (rename) current symbol | neovim LSP |
| `,fmt` | Format current buffer | neovim LSP |
| `gJ` | Join code block | splitjoin.vim |
| `gS` | Split code block | splitjoin.vim |
| `,]]` | Go to next error/warning | neovim LSP |
| `,[[` | Go to previous error/warning | neovim LSP |

## Ruby- and Rails-specific Mappings
| mapping | description |
| :-----: | :---------- |
| `,rp` | Insert `puts` statement on line below |
| `,rP` | Insert `puts` statement on line above |
| `,bp` | Insert `binding.pry` statement on line below |
| `,bP` | Insert `binding.pry` statement on line above |
| `^oc` | Fuzzy find Rails controller & edit | telescope.nvim |
| `^om` | Fuzzy find Rails model & edit | telescope.nvim |
| `^ov` | Fuzzy find Rails view & edit | telescope.nvim |
