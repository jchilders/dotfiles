Things to test in neovim after making changes:

- `def`/`end` are highlighted when cursor is on respective line
- For the above, the status line is not updated when the match occurs offscreen
	(vim-matchup does this by default)
- `<current class> > <current function>` shows in status line
- `%` - matching works for `if`/`elsif`/`else`/`end`
- `,gb` - shows git blame for current line
- Does tab completion work with the `:` command?
