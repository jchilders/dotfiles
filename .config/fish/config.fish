set --universal fish_greeting ""
set --global fish_key_bindings fish_vi_key_bindings

set --local paths ~/bin /usr/local/bin /usr/local/sbin
set PATH /usr/local/bin /usr/local/sbin /bin /usr/sbin $PATH

# Agency Gateway stuff
set --universal --export UNICORN_WORKERS 2
set --universal --export PORT 5000

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
alias   vi nvim

set -x CLASSPATH ./lib/log4j-1.2.17.jar # For SMS
