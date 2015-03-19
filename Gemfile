source "https://rubygems.org"

gem 'rails', (ENV['RAILS_VERSION'] || '~> 3.2.19')

# Declare your gem's dependencies in archiving.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

group :development, :test do
  gem 'rake' # for travis
  gem "pry", "0.9.10"
  gem "pry-nav", "0.2.2"
end
