These dotfiles are targeted at Ruby on Rails development.

Stack:

* zsh - tried Fish. Too slow.
* neovim

# Hotkeys
## zsh
### Widgets
zsh widgets and their key bindings are defined in `zsh/config/widgets.zsh`

`^oa` - Fuzzy find modified file & add to staging area (`git add`)
`^oc` - Fuzzy find Rails controller & edit
`^od` - Fuzzy find modified file & diff
`^of` - Fuzzy find *any* file (ignores `.gitignore`) & edit
`^om` - Fuzzy find Rails model & edit
`^ov` - Fuzzy find Rails view & edit

### Aliases
Defined in `zsh/config/aliases.zsh`

`bi` - `bundle install`
`gcb` - Copies current branch name to pasteboard
`gd` - `git diff`
`gst` -  `git status -sb`
`rc` - `rails console`
`rdbm` - `rake db:migrate`
`rdbms` - `rake db:migrate:status`
`rs` - `rails server`
