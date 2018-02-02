# Set the current Ruby to the contents of `.ruby-version`, if it exists
function chrvm
  status --is-command-substitution; and return
  if test -e .ruby-version
    cat .ruby-version | rvm use > /dev/null
  end
end

