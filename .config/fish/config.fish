# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# PAM/SMS/Remora/PAM API stuff
set -x CLASSPATH ./lib/log4j-1.2.17.jar
set --universal --export REMORA_DB_USERNAME sms_user
# set --global --export DYLD_LIBRARY_PATH /opt/oracle/instantclient_11_2
set --global REMORA_TEST_USERNAME pam_client_test

# Use vim when creating/editing PRs using gh (GitHub CLI tool)
set -x EDITOR nvim

set -x NVM_DIR $HOME/.nvm

alias   bcon='bin/console'
alias   bi='bundle install'
alias   cat='bat'
alias   l='ls -alGp'
alias   rc='rails console'
alias   rs='rails s'
alias   rdbm='rake db:migrate'
alias   rdbms='rake db:migrate:status'
alias   vi='nvim'
# alias   vim='nvim'

# nvm stuff
#test -s /Users/jchilders/.nvm-fish/nvm.fish; and source /Users/jchilders/.nvm-fish/nvm.fish
#function __check_nvm --on-event fish_prompt --description 'Change Node version if .nvmrc is present'
#  if test -e .nvmrc
#    set expected_node_version (cat .nvmrc)
#    set actual_node_version (nvm current)
#    if [ "v$expected_node_version" != "$actual_node_version" ]
#      nvm use "v$expected_node_version"
#    end
#  end
#end

rvm default
__handle_rvmrc_stuff
