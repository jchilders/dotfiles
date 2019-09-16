set --universal fish_greeting ""

# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# https://github.com/michaeldfallen/git-radar#customise-your-prompt
set --universal --export GIT_RADAR_FORMAT "%{branch} %{changes}"
# set --local GIT_RADAR_FORMAT "-=> %{branch} %{(:local} %{changes:)}"

set -g fish_user_paths /usr/local/sbin $fish_user_paths
set -g fish_user_paths ~/.local/bin $fish_user_paths

# Qt5.5 and its qmake binary is required by capybara-webkit gem
# http://download.qt.io/archive/qt/5.5/5.5.1/
# https://stackoverflow.com/questions/33728905/qt-creator-project-error-xcode-not-set-up-properly-you-may-need-to-confirm-t/35098040#35098040
set -g fish_user_paths ~/Qt5.5.1/5.5/clang_64/bin $fish_user_paths

# MySQL Stuff
# set --universal --export DYLD_LIBRARY_PATH /usr/local/mysql/lib

# Agency Gateway stuff
set --universal --export UNICORN_WORKERS 1
# see: ~/.config/fish/fish_variables
# Port to run AG UI on
# set --universal --export PORT 4200

# PAM/Remora/PAM API stuff
set -x CLASSPATH ./lib/log4j-1.2.17.jar
# set --universal --export SMS_DEV_DB_PASS dbosms_11g_d426
set --universal --export REMORA_DB_USERNAME sms_user
set --global --export DYLD_LIBRARY_PATH /opt/oracle/instantclient_11_2

alias   bi='bundle install'
alias   cat='bat'
alias   l='ls -alGp'
alias   rc='rails console'
alias   rs='rails s'
alias   rdbm='rake db:migrate'
alias   rdbms='rake db:migrate:status'
alias   vi='nvim'
alias   vim='nvim'

# Switch to correct Ruby version
function __check_rvm --on-event fish_prompt --description 'Switch to appropriate Ruby version when .ruby-version is present'
  if test -e .ruby-version
    set expected_ruby_version (cat .ruby-version)
    set actual_ruby_version (rvm current | string split "@" --)[1]
    if [ "$expected_ruby_version" != "$actual_ruby_version" ]
      rvm use > /dev/null
    end
  end
end

# nvm stuff
test -s /Users/jchilders/.nvm-fish/nvm.fish; and source /Users/jchilders/.nvm-fish/nvm.fish
function __check_nvm --on-event fish_prompt --description 'Change Node version if .nvmrc is present'
  if test -e .nvmrc
    nvm use (nvm_ls) > /dev/null
  end
end
