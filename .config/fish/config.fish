set --universal fish_greeting ""

# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

set --local paths ~/bin /usr/local/bin /usr/local/sbin
set PATH /usr/local/bin /usr/local/sbin /bin /usr/sbin $PATH

# Agency Gateway stuff
set --universal --export UNICORN_WORKERS 2
set --universal --export PORT 5000

# Remora (PAM Admin) stuff
set --universal --export REMORA_DB_USERNAME sms_user

# rvm stuff
rvm default
chrvm
function __check_rvm --on-variable PWD --description 'Do rvm stuff on directory change'
  chrvm
end

alias   l='ls -alGp'
alias   rc='rails console'
alias   rs='rails s webrick'
alias   rdbm='rake db:migrate ; say -r 300 DB migrate done'
alias   rdbms='rake db:migrate:status ; say -r 300 DB status done'
alias   vi='nvim'
alias   ff='mdfind -onlyin . -name $1'
# git pull rebase (or merge, if branch has been pushed) develop
alias   gprd='rvm use ruby-2.3.0; ruby ~/scripts/gprd; rvm use jruby-9.1.5.0'

set -x CLASSPATH ./lib/log4j-1.2.17.jar # For SMS
