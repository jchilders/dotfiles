set --universal fish_greeting ""

# https://github.com/mnacamura/z-fish
source /Users/jchilders/workspace/z-fish/z.fish

# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# https://github.com/michaeldfallen/git-radar#customise-your-prompt
set --universal --export GIT_RADAR_FORMAT "%{branch} %{changes}"
set --local GIT_RADAR_FORMAT "-=> %{branch} %{(:local} %{changes:)}"

set --local paths ~/bin /usr/local/bin /usr/local/sbin
set PATH /usr/local/bin /usr/local/sbin /bin /usr/sbin $PATH

# Agency Gateway stuff
set --universal --export UNICORN_WORKERS 1
set --universal --export PORT 5000

# Remora (PAM Admin) stuff
set --universal --export REMORA_DB_USERNAME sms_user

# rvm stuff
rvm default
chrvm
function __check_rvm --on-variable PWD --description 'Do rvm stuff on directory change'
  chrvm
end

alias   bi='bundle install'
alias   cat='bat'
alias   l='ls -alGp'
alias   rc='rails console'
alias   rs='rails s'
alias   rdbm='rake db:migrate'
alias   rdbms='rake db:migrate:status'
alias   vi='nvim'
alias   vim='nvim'

set -x CLASSPATH ./lib/log4j-1.2.17.jar # For SMS
set -g fish_user_paths "/usr/local/opt/mongodb@3.4/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/qt@5.5/bin" $fish_user_paths
