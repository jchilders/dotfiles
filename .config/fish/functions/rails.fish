function rails
  set rails_actual (which rails)
  bundle check > /dev/null
  if test ! $status -eq 0
    bundle config path vendor/cache
    bundle install --jobs 4 --retry 3
  end
  bundle exec $rails_actual $argv
end
