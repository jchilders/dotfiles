function rspec --wraps rspec --description "Sets RAILS_ENV=test & runs rspec"
  set -l rspec_actual (which rspec)
  env RAILS_ENV=test $rspec_actual $argv
end

