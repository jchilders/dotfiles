# What?

My dotfiles. I am a developer who works primarily on macOS/Darwin. This
configuration will allow you to do common things with very few keystrokes.
After trying various combinations over the years I settled on
zsh/neovim/wezterm and have customized them to work with each other.

**Philosophy: "UNIX is an IDE."** This setup prioritizes efficiency through minimal keystrokes and seamless integration between terminal, editor, and git workflows.

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

# Prerequisites

- **macOS** (primary target platform)
- **Git** (for cloning the repository)
- **Make** (usually pre-installed on macOS)
- **Internet connection** (for downloading Homebrew packages)

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

## Try it out without installing

### Docker Container

Build and run a containerized version to test the dotfiles:

```bash
docker build -t dotfiles-demo .
docker run -it dotfiles-demo
```

This creates a full Linux environment with most tools installed via Homebrew.

### VS Code Devcontainer

Open the project in VS Code and use the devcontainer:

1. Install the "Dev Containers" extension in VS Code
2. Open this repository in VS Code
3. Press `Cmd+Shift+P` and select "Dev Containers: Reopen in Container"
4. VS Code will build and open the devcontainer

Or use the devcontainer CLI:

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Build and run
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . /bin/zsh
```

The devcontainer includes most tools and provides a consistent development environment.

Q: lol why are you using Make?

A: Because it works pretty well out of the box and is consistent. I tried nix,
and my experience was similar to
[this](https://www.dgt.is/blog/2025-01-10-nix-death-by-a-thousand-cuts/): too
many moving parts.

# Quick Demo

After installation, try these key features:

- **`ctrl-o` + `o`** - Open any file with fuzzy search and preview
- **`ctrl-o` + `gs`** - Open files from git status (modified/staged files)
- **`l`** - Enhanced directory listing with git info and icons
- **`ctrl-o` + `gb`** - Switch git branches with fuzzy search
- **`<leader>z`** in Neovim - Toggle zen mode (leader = space)

The `ctrl-o` prefix acts like `cmd-p` in VS Code - it's your gateway to quickly opening and navigating files.

# zsh/neovim: ctrl-o

Once you get everything installed and get a zsh prompt, hit `ctrl-o`.

`ctrl-o` acts as an action key prefix for opening files/doing things with them,
similar to `cmd-p` in VSCode. Its primary purpose is to `o`pen files in $EDITOR.
The full list of `ctrl-o` commands are given below, but these are a few of the
most frequently used:

| mapping | description |
| :-----: | :---------- |
| <kbd>^oo</kbd> | Open file. Respects `.gitignore` |
| <kbd>^ogs</kbd> | Open uncommited changed file ("git status") |
| <kbd>^ob</kbd> | Open buffer (neovim only) |

# Neovim: Working with REPLs/shells

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

## Neovim: Zen-ish Mode

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

### Editing and Running Tests

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;et</kbd> | Edit the recently modified test |
| <kbd>&lt;Leader&gt;rt</kbd> | Run most recently modified test in left pane |
| <kbd>&lt;Leader&gt;rT</kbd> | Run most recently modified test for current line/test case in left pane |

I use these very frequently.

### Sending to panes

In my workflow I have wezterm open with two panes (left/right). The left pane
is for a terminal or repl, the right pane is neovim. Keep this in mind for the
below.

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;s[dir]</kbd> | Send current line/visual selection to the `dir` pane (hjkl) |

This lets you quickly run individual lines (or blocks) in an adjacent repl.
Hitting `<Leader>sh` sends the current line to the pane to the left (`h`
direction). This works with visual blocks as well.

### Opening localhost in browser (neovim)

| mapping | description |
| :-----: | :---------- |
| <kbd>&lt;Leader&gt;ol</kbd> | Switches to browser, then to the tab w/ localhost, & reloads |

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
➜ z pro # takes you to ~/work/proj1
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

# Troubleshooting

## Common Issues

**Homebrew installation fails**
- Ensure you have Xcode command line tools: `xcode-select --install`
- Check internet connection and try again
- On Apple Silicon, ensure Rosetta 2 is installed if needed

**Permission denied errors**
- Make sure you have write access to your home directory
- Try running with `sudo` if needed for system-level installations
- Check that `/usr/local` is writable or use Homebrew's recommended permissions

**Shell doesn't switch to zsh**
- Manually change shell: `chsh -s $(which zsh)`
- Restart your terminal application
- Check that zsh is in `/etc/shells`

**Tools not found after installation**
- Restart your terminal to reload PATH
- Source your shell config: `source ~/.zshenv`
- Check Homebrew PATH: `echo $PATH | grep brew`

**Neovim plugins not working**
- Run `:Lazy sync` inside Neovim to update plugins
- Check for LSP errors with `:LspInfo`
- Ensure required language servers are installed via Mason

