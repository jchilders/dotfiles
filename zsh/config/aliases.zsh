alias ..='cd ..'
alias l='exa -a --long --git'
alias gcb="git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy"

source /usr/local/share/zsh-abbr/zsh-abbr.zsh

abbr add bi='bundle install' > /dev/null 2>&1
abbr add dcom='docker-compose' > /dev/null 2>&1
abbr add gd='git diff' > /dev/null 2>&1
abbr add gst='git status -sb' --force > /dev/null 2>&1

abbr add muxi='tmuxinator' > /dev/null 2>&1

abbr add rc='rails console' --force> /dev/null 2>&1
abbr add rdbm='rake db:migrate' > /dev/null 2>&1
abbr add rdbmt='rake db:migrate RAILS_ENV=test' > /dev/null 2>&1
abbr add rdbmst='rake db:migrate:status RAILS_ENV=test'> /dev/null 2>&1
abbr add rs='rails server' --force> /dev/null 2>&1
