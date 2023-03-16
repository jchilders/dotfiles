# rails plugin new gems/my_gem --template=/path/to/this/file.rb

gem_group :development do
  # Help to kill N+1 queries and unused eager loading
  # (uncomment when it supports Rails 7.1)
  # gem "bullet"

  gem "dalli"         # needed (asked for...) by Sorbet

  # Memory profiler for ruby
  gem "memory_profiler"

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
