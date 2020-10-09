# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# Turn off greeting
set fish_greeting

set -x DISABLE_SPRING 1
# Use vim when creating/editing PRs using gh (GitHub CLI tool)
set -x EDITOR nvim
set -x NVM_DIR $HOME/.nvm
set -x JAVA_OPTS '-Xms2048m -Xmx2048m'

abbr --add bi bundle install
abbr --add gd git diff
abbr --add gst git status -sb
abbr --add rc rails console
abbr --add rs rails server
abbr --add rdbm rake db:migrate
abbr --add rdbms rake db:migrate:status

# GTL stuff
# set -x DB_PORT 3307
abbr --add db ./docker-build.sh
abbr --add drs ./docker-run.sh script/server -p

if type -q rvm
  rvm default
  __handle_rvmrc_stuff
end

set -gx PATH /usr/local/sbin /usr/local/bin $PATH
