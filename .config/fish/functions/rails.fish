function rails --wraps rails --description "For Rails projects, run bundle install when required"
  set rails_actual (which rails)
  if test (git rev-parse --is-inside-work-tree ^ /dev/null)
    set top (git rev-parse --show-toplevel)
    if test -e "$top/Gemfile"
      bundle check > /dev/null
      if test ! $status -eq 0
        bundle config path vendor/cache
        bundle install --jobs 4 --retry 3
      end
    end
    bundle exec $rails_actual $argv
  else
    $rails_actual $argv
  end
end
