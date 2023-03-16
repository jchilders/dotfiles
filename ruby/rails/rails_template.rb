# gem "ahoy_matey"    # Analytics for Rails
gem "dotenv-rails"
gem "geocoder"      # Complete geocoding solution for Ruby
gem "pagy"          # pagination. faster than others.

# This is here to track interesting admin gems BESIDES ActiveAdmin
# gem_group :admin do
#   gem "madmin"      # Hotwire-ready admin interface for Rails
# end

gem_group :development do
  # Help to kill N+1 queries and unused eager loading
  # (uncomment when it supports Rails 7.1)
  # gem "bullet"

  gem "dalli"         # needed (asked for...) by Sorbet

  # Memory profiler for ruby
  gem "memory_profiler"

  # Oink adds memory and active record instantiation information to rails log
  # during runtime and provides an executable to help digest the enhanced logs.
  gem "oink"

  # Middleware that displays speed badge for every html page. 
  gem "rack-mini-profiler"

  gem "sorbet"
  gem "sorbet-runtime"
  gem "tapioca", require: false
end

gem_group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-expectations"
  gem "rspec-rails"
end

gem_group :rubocop do
  gem "rubocop-packaging"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-shopify"
end

append_to_file "Gemfile" do <<~'RUBY'

  if ENV["ENGINE"].nil?
    if Dir.pwd.split("/")[-2] == "engines"
      ENV["ENGINE"] = Dir.pwd.split("/").last
    end
  end

  Dir.glob(File.expand_path("../engines/*", __FILE__)).each do |path|
    engine = File.basename(path)
    gem engine, path: "engines/#{engine}", require: (ENV["ENGINE"].nil? || ENV["ENGINE"] == engine)
  end
RUBY
end

initializer "generators.rb" do
<<~RUBY
  # frozen_string_literal: true

  Rails.application.config.generators do |g|
    g.helper(false)
    g.test_framework :rspec, fixture: false

    g.controller_specs(false)
    g.helper_specs(false)
    g.system_specs(false)
    g.view_specs(false)
  end
RUBY
end

file ".rubocop.yml", <<~CODE
  inherit_gem:
    rubocop-shopify: rubocop.yml

  require:
    - rubocop-capybara
    - rubocop-performance
    - rubocop-rails
    - rubocop-rspec

  RSpec/NestedGroups:
    Enabled: true
    Max: 4
CODE

file "Brewfile", <<~CODE
  # Code security scanner
  tap "bearer/tap"
  brew "bearer"
CODE

file "sorbet/tapioca/config.yml", <<~YAML
  ---
  dsl:
    workers: 10
  gem:
    doc: true
    workers: 10
  check_shims:
    workers: 10
YAML

after_bundle do
  generate "rspec:install"
  # generate "ahoy:install"

  # Fix style errors that rubocop can't auotmatically correct
  gsub_file("config/environments/development.rb", "Rails.root.join\('tmp', 'caching-dev.txt'\).exist\?", 'Rails.root.join("tmp/caching-dev.txt").exist?')

  # run "tapioca init"

  rails_command "db:create"
  rails_command "db:migrate"

  # Autocorrect, but only fail on fatal errors. rubocop returns a non-zero
  # value otherwise, causing processing of this template to stop.
  run "rubocop -A --disable-pending-cops --fail-level F"

  git add: "-A ."
  git commit: "-a -m 'Initial commit.'"
end
