# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# Turn off greeting
set fish_greeting

# Use vim when creating/editing PRs using gh (GitHub CLI tool)
set -x EDITOR nvim
set -x NVM_DIR $HOME/.nvm

set -x DISABLE_SPRING 1

# GTL stuff
# set -x DB_PORT 3307

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
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
