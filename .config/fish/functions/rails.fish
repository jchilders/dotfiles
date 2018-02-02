function rails
  set rails_actual (which rails)
  bundle check > /dev/null
  if test ! $status -eq 0
    bundle install
  end
  eval $rails_actual $argv
end
