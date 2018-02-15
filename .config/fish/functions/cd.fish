function cd --wraps cd --description "Sets tmux session name to git root after changing directory"
  builtin cd $argv
  if test $TMUX ; and test (git rev-parse --is-inside-work-tree ^ /dev/null)
    git rev-parse --show-toplevel | sed 's!.*/!!' | xargs tmux rename-session
  end
end

