# commented out for now b/c it is slow under jruby
# function rails
  # set rails_actual (which rails)
  # bundle check > /dev/null
  # if test ! $status -eq 0
    # bundle install
  # else
    # printf 'gems are up to date\n'
  # end
  # # TODO: fix. rails runner doesn't work with this
  # eval $rails_actual $argv
# end
