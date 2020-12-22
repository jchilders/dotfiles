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

# Docker
abbr --add dbld  docker build .
abbr --add dps   docker ps
abbr --add dimg  docker image
abbr --add dcom  docker-compose

if type -q rvm
  rvm default
  __handle_rvmrc_stuff
end

# https://github.com/jorgebucaran/fisher
set -g fisher_path $__fish_config_dir/fisher_plugins
set --prepend fish_function_path $fisher_path/functions
set --prepend fish_complete_path fish_complete_path[1] $fisher_path/completions
for file in $fisher_path/conf.d/*.fish
  builtin source $file 2>/dev/null
end

# Custom bindings
bind -M insert \cs __fzf_search_git_status

set --export FZF_DEFAULT_OPTS --layout=reverse --height=10% --no-clear

# brew install starship
starship init fish | source

set -g fish_user_paths "/usr/local/opt/mysql@5.6/bin" $fish_user_paths
