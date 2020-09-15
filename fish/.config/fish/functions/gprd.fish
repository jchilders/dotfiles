# git pull rebase (or merge, if branch has been pushed) develop
function gprd 
  git diff-files --quiet
  if test $status -ne 0
    printf 'You have uncommitted changes. Doing nothing'
    return $status
  end

  set -l curr_branch (git rev-parse --abbrev-ref HEAD)
  if [ $curr_branch = 'develop' ]
    printf 'Already on \'develop\' branch (%s) Doing nothing\n' $curr_branch
    return $status
  end

  git checkout -q develop
  git pull -q
  git checkout -q $curr_branch

  # Check to see if it's been pushed to remote. If not, rebase. If so, merge.
  git branch -q -a | ag 'remotes/origin/'$curr_branch
  if test $status -eq 0
    set -g verb 'merging'
    git merge develop
  else
    set -g verb 'rebasing'
    git rebase develop
  end

  printf 'Done %s develop into %s\n' $verb $curr_branch
  git status -sb
end
