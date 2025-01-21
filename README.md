# What?

My dotfiles. I am a developer who works primarily on macOS/Darwin. This
configuration will allow you to do common things with very few keystrokes.
After trying various combinations over the years I settled on
zsh/neovim/wezterm and have customized them to work with each other.

"UNIX is an IDE."

![term_screenshot_left_active](https://github.com/user-attachments/assets/82f6231c-dbbb-4577-aec1-50dcee05b549)

Left pane active. The results are from executing the alias `l`, which uses eza
under the hood. The third column shows when the file/directory was last
modified in the git repo.

Notes:

- Tabs by default are labeled with the git root directory, updating when you
  change directories
- Inactive panes are dimmed
- Changing panes is done with <kbd>Shift ⌘ &lt;direction&gt;</kbd>, where
  `<direction>` is a vim-style movement key, i.e.: hjkl. So after pressing
  <kbd>Shift ⌘ L</kbd> to switch to the pane to the right we get this:

![term_screenshot_right_active](https://github.com/user-attachments/assets/220c36f2-4eb3-4f66-8676-b5e05cdd18fc)

Right pane active. Here Neovim is loaded with a Typescript file. An error on
line 35 is being reported by the LSP.

This setup is fairly Zen: work is done primarily in the right pane, which means
that the code I'm working on is generally centered on the screen.

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

A: Because it works pretty well out of the box and is consistent. I tried nix,
and my experience was similar to
[this](https://www.dgt.is/blog/2025-01-10-nix-death-by-a-thousand-cuts/): too
many moving parts.

# ctrl-o

`ctrl-o` acts as an action key prefix for opening files/doing things with them,
similar to `cmd-p` in VSCode. Its primary purpose is to open files in $EDITOR
(hence the `o` prefix). The full list of `ctrl-o` commands are given below, but
these are a few of the most frequently used:

| mapping | description |
| :-----: | :---------- |
| <kbd>^oo</kbd> | Open file. Respects `.gitignore` |
| <kbd>^ogs</kbd> | Open uncommited changed file ("git status") |
| <kbd>^ob</kbd> | Open buffer (neovim only) |

# Working with REPLs/shells

Text in neovim can be sent to an adjacent pane for execution in the REPL or
shell you're currently working in. This allows for testing out either single
lines, or entire blocks. Try this:

1. Open `nvim` in the right pane. 
  - Hit <kbd>cmd t</kbd> to open a new tab if you need to
1. Insert the following into neovim: `echo hello`
1. Hit `esc` to exit insert mode
1. Press <kbd>&lt;space&gt;sh</kbd>. This will the current line to the pane to
   the left and execute it. 
- Multiple lines can similarly be sent by visually selecting them and hitting
  <kbd>&lt;space&gt;sh</kbd>.

# Neovim

The <kbd>&lt;leader&gt;</kbd> key is <kbd>&lt;space&gt;</kbd>.

## Look & feel


## Zen-ish Mode

Press <kbd>&lt;leader&gt;z</kbd> to hide the gutter (current and relative line
numbers, git indicators, etc.), indentation helpers, and any inline LSP
warnings or errors appearing inline.

[Toggling zenish mode with Leader z](https://github.com/user-attachments/assets/7146e4a3-7287-436e-b94a-a90d34dacc0a)

# Mappings

## Tabs & Panes

| mapping | description |
| :-----: | :---------- |
| <kbd>cmd-t</kbd> | New tab |
| <kbd>cmd-w</kbd> | Close tab |
| <kbd>shift-cmd-[</kbd> | Previous tab |
| <kbd>shift-cmd-]</kbd> | Next tab |
| <kbd>shift-cmd-f</kbd> | Toggle full screen |
| <kbd>shift-cmd-n</kbd> | Rotate panes |
| <kbd>shift-cmd-&lt;dir&gt;</kbd> | Go to pane in &lt;dir&gt; (hjkl) |
| <kbd>cmd-&lt;num&gt;</kbd> | Goto tab &lt;num&gt; |
| <kbd>^ar</kbd> | Rename tab |
| <kbd>^a%</kbd> | Horizontally split pane (left/right)|
| <kbd>^a-</kbd> | Vertically split pane (top/bottom) |
| <kbd>^az</kbd> | Zoom/unzoom pane. |
| <kbd>^a[</kbd> | Enter copy mode. Use hjkl to nav, then v to select, then y
to copy selected text to clipboard |

## ctrl-o

As mentioned above, `ctrl-o` acts as an action prefix similar to
`cmd-p`/`shift-cmd-p` in VSCode. It's original purpose is to open files (hence
the `o` prefix).

## ctrl-o file mappings

These work in both zsh and nvim.

| mapping | description |
| :-----: | :---------- |
| <kbd>^oo</kbd> | Open file. Respects `.gitignore` |
| <kbd>^oO</kbd> | Open *any* file. Ignores `.gitignore` |

## ctrl-o git mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>^ogb</kbd> | Switch git branch |
| <kbd>^ogs</kbd> | Open file ("git status") |
| <kbd>^ogd</kbd> | Show file diff (zsh only) |
| <kbd>^oga</kbd> | Add file to git staging area (zsh only) |

The last two allow you to diff/add files extremely quickly. Say you just did
`^gd` (git diff) for `README.md`. Pressing `^oga` after doing so will prompt
you:

```
Add README.md to the git staging area? [Y/n/d/c]
```

`Y` will add it, `n` will abort, `d` will let you do a diff, and `c` will check
it out, overwriting your changes. So if you do a `^ogd` and realize you want to
abandon the changes made to that file, just do `^oga` then `c` and voila.

The mappings are built to allow for quickly doing diff/add operations. You are
encouraged to try this until your muscle memory gets familiar with it. This
flow works particularly well when there are multiple files that need to be
reviewed and added to the commit (or reverted).

## Neovim specific ctrl-o mappings

| mapping | description |
| :-----: | :---------- |
| <kbd>^ob</kbd> | Switch buffer by filename |
| <kbd>^or</kbd> | go to symbol (method name, etc.) for current buffer |

### Other Noteworthy Neovim Mappings

The leader key is currently `<space>`.

| mapping | description |
| :-----: | :---------- |
| <kbd>Enter</kbd> | Clear highlighted search |
| <kbd>&lt;Leader&gt;&lt;Leader&gt;</kbd> | Switch between next/previous buffers |
| <kbd>&lt;Leader&gt;z</kbd> | Toggle Zen-ish mode |
| <kbd>&lt;Leader&gt;]]</kbd> | Go to next error/warning |
| <kbd>&lt;Leader&gt;[[</kbd> | Go to previous error/warning |

### Running Tests

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;rt</kbd> | Run most recently modified test in left pane |
| <kbd>&lt;Leader&gt;rT</kbd> | Run most recently modified test, current line/test case in left pane |

I use these two very frequently.

### Sending to panes

In my workflow I have wezterm open with two panes (left/right). The left pane
is for a terminal or repl, the right pane is neovim. Keep this in mind for the
below.

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;s[dir]</kbd> | Send current line/visual selection to the `dir` pane (hjkl) |

This lets you quickly test lines (or blocks) in an adjacent repl. Hitting
`<Leader>sh` sends the current line to the pane to the left (`h` direction).
This works with visual blocks as well.

# zsh

## Mappings
Additional zsh mappings:

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
| <kbd>^orc</kbd> | Find & edit Rails controller |
| <kbd>^orm</kbd> | Find & edit Rails model |
| <kbd>^orv</kbd> | Find & edit Rails view |

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
| <kbd>rs</kbd> | `rails server` |
| <kbd>rdbm</kbd> | `rake db:migrate` |
| <kbd>rdbms</kbd> | `rake db:migrate:status` |
| <kbd>rdbmt</kbd> | `rake db:migrate RAILS_ENV=test` |
| <kbd>rdbmst</kbd> | `rake db:migrate:status RAILS_ENV=test` |

## Directory Navigation

After using `cd` once you should be ablet to use `z` (zoxide) thereafter. `z`
lets you `cd` to directories given just a partial path. Example:

```
➜ cd ~/work/proj1
➜ cd
➜ z proj1 # takes you to ~/work/proj1
```
## Using a devcontainer

Work in progress.

```
devcontainer build --workspace-folder . --image-name jc_dotfiles:latest
docker ps -a
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . /bin/zsh
```

To stop/rebuild/restart the devcontainer:

```
docker ps -a
docker rm jc_dotfiles
devcontainer build --workspace-folder . --image-name jc_dotfiles:latest
devcontainer up --workspace-folder .
```

