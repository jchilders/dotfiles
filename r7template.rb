# rails new my_app -m path/to/r7template.rb

gem "dotenv-rails"

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

generate "rspec:install"

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

file '.rubocop.yml', <<~CODE
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
