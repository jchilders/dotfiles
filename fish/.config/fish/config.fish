# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# Use vim when creating/editing PRs using gh (GitHub CLI tool)
set -x EDITOR nvim
set -x NVM_DIR $HOME/.nvm

set -x DISABLE_SPRING 1

# set -x APP_ENV test
# set -x RACK_ENV test
# set -x RAILS_ENV test

alias   bcon='bin/console'
alias   bi='bundle install'
alias   cat='bat'
alias   l='ls -alGp'
alias   rc='rails console'
alias   rs='rails s'
alias   rdbm='rake db:migrate'
alias   rdbms='rake db:migrate:status'
alias   vi='nvim'
alias   vim='nvim'

if type -q rvm
  rvm default
  __handle_rvmrc_stuff
end
