# If you type "ls" then hit up arrow, will only match history entries that
# begin with that. (Default is to match entries that *contain* "ls".)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
bindkey '^[OB'  down-line-or-beginning-search

# Lets you rename multiple files w/ regexes, including group capturing
# man zmv
# Replace all spaces in filenames with underscores:
#   zmv '* *' '$f:gs/ /_'
# Use -n flag for dry-run
autoload -U zmv
