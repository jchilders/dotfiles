# https://fishshell.com/docs/current/index.html#editor
set -g fish_key_bindings fish_vi_key_bindings

# Turn off greeting
set fish_greeting

# set -x DISABLE_SPRING 1
# Use vim when creating/editing PRs using gh (GitHub CLI tool)
set -x EDITOR nvim
set -x NVM_DIR $HOME/.nvm
set -x JAVA_OPTS '-Xms2048m -Xmx2048m'

set -gx XDG_CONFIG_HOME ~/.config/

# Git
abbr --add ga git add
abbr --add gd git diff
abbr --add gst git status -sb
bind -M insert \cs __fzf_search_git_status
complete -c git -a diff -n '__fzf_search_git_status' -d '`git diff <tab>` to complete via git status'
complete -c git -a add -n '__fzf_search_git_status' -d '`git add <tab>` to complete via git status'

# Ruby/Rails
abbr --add bi bundle install
abbr --add rc rails console
abbr --add rs rails server
abbr --add rdbm rake db:migrate
abbr --add rdbms rake db:migrate:status

# Necessary because sometimes switching directories does not cause rvm to trigger.
if type -q rvm
  rvm default
  __handle_rvmrc_stuff
end

# Docker
abbr --add dbld  docker build .
abbr --add dps   docker ps
abbr --add dimg  docker image
abbr --add dcom  docker-compose

# https://github.com/jorgebucaran/fisher
set -g fisher_path $__fish_config_dir/fisher_plugins
set --prepend fish_function_path $fisher_path/functions
set --prepend fish_complete_path fish_complete_path[1] $fisher_path/completions
for file in $fisher_path/conf.d/*.fish
  builtin source $file 2>/dev/null
end

set --export FZF_DEFAULT_OPTS --layout=reverse --height=15% --no-clear -i

# brew install starship
starship init fish | source

set -g fish_user_paths "/usr/local/opt/mysql@5.6/bin" $fish_user_paths
