alias ..='cd ..'
alias l='exa -al'
alias gcb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

abbr add bi='bundle install' > /dev/null 2>&1

abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' --force > /dev/null 2>&1

abbr add rc='rails console' --force> /dev/null 2>&1
abbr add rdbm='rake db:migrate' > /dev/null 2>&1
abbr add rdbms='rake db:migrate:status'> /dev/null 2>&1
abbr add rs='rails server' --force> /dev/null 2>&1
