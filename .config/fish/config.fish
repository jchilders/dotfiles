# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# https://github.com/michaeldfallen/git-radar#customise-your-prompt
# set --universal --export GIT_RADAR_FORMAT "%{branch} %{changes}"
# set --local GIT_RADAR_FORMAT "-=> %{branch} %{(:local} %{changes:)}"

# gem install mysql2 -v '0.5.3' -- --with-mysql-config=/usr/local/Cellar/mysql/8.0.18_1/bin/mysql_config
# gem install mysql2 -v '0.5.3' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include

# Agency Gateway stuff
# set --universal --export UNICORN_WORKERS 1
# see: ~/.config/fish/fish_variables

# PAM/SMS/Remora/PAM API stuff
set -x CLASSPATH ./lib/log4j-1.2.17.jar
set --universal --export REMORA_DB_USERNAME sms_user
set --global --export DYLD_LIBRARY_PATH /opt/oracle/instantclient_11_2
set --global REMORA_TEST_USERNAME pam_client_test

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

# https://asdf-vm.com/#/ - rvm/rbenv/nvm replacement
source /usr/local/opt/asdf/asdf.fish
