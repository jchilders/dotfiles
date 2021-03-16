Zsh/Neovim/Tmux configurations targeted towards Ruby on Rails development under macOS.
There are two design goals:

1. Be able to do as much work as possible without your hands ever needing to
   leave the home row
2. Be able to open files in as few keystrokes as possible

The core toolchain is tmux, zsh, neovim, and fzf.

# Installation

`make install` - Installs homebrew, Ruby, default homebrew formalae (including tmux),
builds Neovim from source, and links all configuation files (dotfiles). Typically used when
needing to bootstrap up a new laptop used in development.

`make dotfiles` - Links configuation files (dotfiles) only, without installing anything

`make` - List all available targets

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

## Directory Navigation

Use `z`. For example:

```
~ ➜ cd ~/workspace/myrailsproj
myrailsproj on  master ➜ cd
~ ➜ z proj
myrailsproj on  master ➜ 
```

# Neovim

Leader key is `,`.

## Mappings

An attempt was made to avoid collision with native mappings. See `nvim/config/mappings*.vim` for the complete list. Ruby-specific mappings are kept in `nvim/after/ftplugin/ruby.vim`.

| mapping | description | provided by |
| :-----: | :---------- | :---------: |
| `^ob` | Fuzzy switch buffer by filename | telescope.nvim |
| `^oc` | Fuzzy find Rails controller & edit | telescope.nvim |
| `^of` | Fuzzy find file & edit | telescope.nvim |
| `^om` | Fuzzy find Rails model & edit | telescope.nvim |
| `^or` | Fuzzy go to symbol (method name, etc.) | telescope.nvim |
| `^os` | Fuzzy find modified file & edit | telescope.nvim |
| `^ov` | Fuzzy find Rails view & edit | telescope.nvim |
| `,,` | Switch between next/previous buffers |
| `,ccs` | Change (rename) current symbol | neovim LSP |
| `,fmt` | Format current buffer | neovim LSP |
| `gJ` | Join code block | splitjoin.vim |
| `gS` | Split code block | splitjoin.vim |
| `,]]` | Go to next error/warning | neovim LSP |
| `,[[` | Go to previous error/warning | neovim LSP |
| `,g` | Toggle gutter | Native |
| `,c<Space>` | Comment/uncomment current line | nerd-commenter |
| `3,c<Space>` | Comment/uncomment 3 lines | nerd-commenter |
| `<Enter>` | Clear highlighted search | Native |

## Ruby- and Rails-specific Mappings
| mapping | description |
| :-----: | :---------- |
| `^oc` | Fuzzy find Rails controller & edit | telescope.nvim |
| `^om` | Fuzzy find Rails model & edit | telescope.nvim |
| `^ov` | Fuzzy find Rails view & edit | telescope.nvim |
| `,bp` | Insert `binding.pry` statement below current line |
| `,bP` | Insert `binding.pry` statement above current line |
| `,rp` | Insert `puts` statement below current line |
| `,rP` | Insert `puts` statement above current line |
