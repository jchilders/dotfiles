# Table of Contents
- [What?](#what)
- [Installation](#installation)
- [Basics](#basics)
- [wezterm](#wezterm)
- [ctrl-o](#ctrl-o)
  - [File Mappings](#ctrl-o-file-mappings)
  - [zsh Specific Mappings](#zsh-specific-ctrl-o-mappings)
  - [Neovim Specific Mappings](#neovim-specific-ctrl-o-mappings)
- [Neovim](#other-noteworthy-neovim-mappings)
- [zsh](#zsh)
  - [Mappings](#mappings)
  - [Aliases](#aliases)
- [Ruby/Rails](#rubyrails)

# What?

My dotfiles. I am a developer. This configuration will allow you to do common things with very few keystrokes.

"UNIX is an IDE."

# Installation

```
> git clone git@github.com:jchilders/dotfiles.git
> cd dotfiles
> make install
```

The `install` target will:

1. Set up macOS defalts
2. Link the `xdg_config` directory to `$HOME/.config`
3. Install the default Homebrew packages, including Neovim

To undo the above:

```
> make clean
```

Q: lol why are you using Make?

A: Because I'd never written a Makefile before, and honestly it works pretty well.

# Basics

After running the install script above do the following.

1. Open wezterm
1. Press `<ctrl-a>%` to open up a split pane
1. Run `nvim`
1. Insert the following into neovim: `echo hello`
1. Hit `esc` to exit insert mode
1. Press `<space>sh`. This sends the current line to the pane to the left

If everything works correctly then "echo hello" should be executed in the left pane.

This gives you an idea of my (opinionated) setup: a horizontal split, where the left is a console or repl, and the right is neovim. I edit code in the right pane, and various mappings are used to quickly interact with the left, either to execute code in a repl/shell, or to run tests.

## wezterm

The leader key for wezterm mappings is `ctrl-a`.

| mapping | description |
| :-----: | :---------- |
| <kbd>cmd-t</kbd> | New tab |
| <kbd>cmd-w</kbd> | Close tab |
| <kbd>shift-cmd-[</kbd> | Previous tab |
| <kbd>shift-cmd-]</kbd> | Next tab |
| <kbd>shift-cmd-f</kbd> | Toggle full screen |
| <kbd>cmd-&lt;num&gt;</kbd> | Goto tab &lt;num&gt; |
| <kbd>^ar</kbd> | Rename tab |
| <kbd>^a%</kbd> | Horizontally split window (left/right)|
| <kbd>^a-</kbd> | Vertically split pane (top/bottom) |
| <kbd>^az</kbd> | Zoom pane. Press again to undo. |
| <kbd>shift-cmd-&lt;dir&gt;</kbd> | Go to pane in &lt;dir&gt; (hjkl) |
| <kbd>^a[</kbd> | Enter copy mode. Use hjkl to nav, then v to select, then y to copy selected text to clipboard |

## ctrl-o

`ctrl-o` acts as a action prefix similar to `shift-cmd-p` in VS Code. It is available in both zsh and neovim. It's original purpose is to open files (hence the `o` prefix).

## ctrl-o file mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oo</kbd> | Find & edit file in $EDITOR. Respects `.gitignore` |
| <kbd>^oO</kbd> | Find & edit *any* file in $EDITOR. Ignores `.gitignore` |
| <kbd>^ogb</kbd> | Switch branch |

## zsh specific ctrl-o mappings

These are all around git funtionality, primarily around reviewing changes and adding files to the commit (or reverting changes).

| mapping | description |
| :-----: | :---------- |
| <kbd>^ogd</kbd> | Find uncommited changed file & show diff (`git diff`) |
| <kbd>^oga</kbd> | Find uncommited changed file & add to staging area (`git add`) |
| <kbd>^ogs</kbd> | Find uncommited changed file & edit (`git status`) |

Doing `^ogd` followed by `^oga` allows you to diff/add files very quickly. `^oga` will prompt you with what you want to do. Say you just did `^gd` (git diff) for `README.md`. Pressing `^oga` now will give you:

```
Add README.md to the git staging area? [Y/n/d/c]
```

`Y` will add it, `n` will abort, `d` will let you do a diff, and `c` will check it out, overwriting your changes. So if you do a `^ogd` and realize you want to abandon the changes made to that file, just do `^oga` then `c` and voila.

The diff/add mappings are built to allow for quickly doing diff/add operations with git and have some intelligence built into them. I encourage you to try this until your muscle memory gets familiar with it. This flow works particularly well when there are several files that need to be reviewed and added to the commit (or reverted).

## Neovim specific ctrl-o mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>^ob</kbd> | Switch buffer by filename |
| <kbd>^or</kbd> | go to symbol (method name, etc.) for current buffer |

The last one here isn't that useful; use `gd` (goto definition) instead. Leaving it for historical purposes.

### Other Noteworthy Neovim Mappings

The leader key is currently `<space>`.

| mapping | description |
| :-----: | :---------- |
| <kbd>Enter</kbd> | Clear highlighted search |
| <kbd>&lt;Leader&gt;&lt;Leader&gt;</kbd> | Switch between next/previous buffers |
| <kbd>&lt;Leader&gt;g</kbd> | Toggle gutter |
| <kbd>&lt;Leader&gt;]]</kbd> | Go to next error/warning |
| <kbd>&lt;Leader&gt;[[</kbd> | Go to previous error/warning |
| <kbd>gc<motion>lt;motion<motion>gt;</kbd> | Comment/uncomment <motion>lt;motion<motion>gt; |
| <kbd>gcc</kbd> | Comment/uncomment current line |

### Misc mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;rt</kbd> | Run most recently modified test in left pane |
| <kbd>&lt;Leader&gt;rT</kbd> | Run most recently modified test, current line/test case in left pane |

I use the latter two very frequently.

### Sending to panes

In my workflow I have wezterm open with two panes (left/right). The left pane is for a terminal or repl, the right pane is neovim. Keep this in mind for the below.

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;s[dir]</kbd> | Send current line/visual selection to the `dir` pane (hjkl) |

The purpose of this mapping is to allow you to edit code and quickly test lines or blocks in a repl. Simply select the code you want to execute using neovim's visual selection, then hit `<Leader>sh` to send it to the pane to the left.

# zsh

## Mappings
Additional mappings (widgets) available to zsh:

| mapping | description |
| :-----: | :---------- |
| <kbd>^t</kbd> | Find file and append to current cursor position |
| <kbd>^r</kbd> | Search command history |

## Aliases

| alias | description |
| :---: | :---------- |
| <kbd>gcb</kbd> | Copies current branch name to pasteboard (clipboard) |
| <kbd>gd</kbd> | `git diff` |
| <kbd>gst</kbd> |  `git status -sb` |
| <kbd>r</kbd> | Rerun previous command |

## Ruby/Rails

### ruby/rails zsh/neovim

These are available in both zsh and neovim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^orc</kbd> | Find & edit & edit Rails controller & edit |
| <kbd>^orm</kbd> | Find & edit & edit Rails model & edit |
| <kbd>^orv</kbd> | Find & edit & edit Rails view & edit |

### ruby/rails neovim 

These are available in neovim.

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;bp</kbd> | Insert `binding.pry` below current line |
| <kbd>&lt;Leader&gt;bP</kbd> | Insert `binding.pry` above current line |
| <kbd>&lt;Leader&gt;rp</kbd> | Insert `puts` below current line |
| <kbd>&lt;Leader&gt;rP</kbd> | Insert `puts` above current line |

### ruby/rails zsh

These are available in zsh.

| alias | description |
| :---: | :---------- |
| <kbd>bi</kbd> | `bundle install` |
| <kbd>cdgem &lt;gem&gt;</kbd> | cd to the directory for the given gem |
| <kbd>rc</kbd> | `bin/rails console`, or `bin/console` if in a Gem directory |
| <kbd>rdbm</kbd> | `rake db:migrate` |
| <kbd>rdbms</kbd> | `rake db:migrate:status` |
| <kbd>rdbmt</kbd> | `rake db:migrate RAILS_ENV=test` |
| <kbd>rdbmst</kbd> | `rake db:migrate:status RAILS_ENV=test` |
| <kbd>rs</kbd> | `rails server` |

## Directory Navigation

Use `z` (zoxide). For example:

```
➜ cd ~/work/myrailsproj
➜ pwd
/Users/jchilders/work/myproj
➜ cd
➜ pwd
/Users/jchilders
➜ z myp
➜ pwd
/Users/jchilders/work/myproj # tada
```
