source 'https://rubygems.org'

ruby '3.3.1'

gem 'sassc-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

gem 'octokit', '~> 4.0'

gem 'faraday-retry', '~> 2.2', '>= 2.2.1'

gem 'ollama-ai', '~> 1.3.0'

gem 'jwt', '~> 2.8', '>= 2.8.2'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'dotenv-rails', '~> 3.1'
gem 'draper', '~> 4.0', '>= 4.0.2'
gem 'activeadmin', '>= 3.2.2'
gem 'activeadmin-searchable_select', '~> 1.8'
gem 'activeadmin_reorderable', '~> 0.3.3'
gem 'activeadmin_addons', '~> 1.10', '>= 1.10.1'
gem 'acts_as_list', '~> 1.2', '>= 1.2.2'
gem 'active_model_serializers', '~> 0.10.2'
gem 'carrierwave', '~> 3.0', '>= 3.0.7'
gem 'chartkick', '~> 5.0', '>= 5.0.6'
gem 'csv', '~> 3.3'
gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'dry-validation', '~> 1.10'
gem 'gemoji', '~> 4.1'
gem 'groupdate', '~> 6.4'
gem 'pundit', '~> 2.3', '>= 2.3.1'
gem 'rolify', '~> 6.0', '>= 6.0.1'
gem 'rswag-api', '~> 2.13'
gem 'rswag-ui', '~> 2.13'
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri windows ]
  gem 'better_errors', '~> 2.10', '>= 2.10.1'
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'
  gem 'binding_of_caller', '~> 1.0', '>= 1.0.1'
  gem 'bullet', '~> 7.1', '>= 7.1.6'
  gem 'rack-mini-profiler', '~> 3.3', '>= 3.3.1'

  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
  # rSwag API Documentation
  gem 'rswag-specs', '~> 2.13'

  # Needed for test data at development and test environments
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker', '~> 3.3', '>= 3.3.1'
  gem 'ffaker', '~> 2.23'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'

  gem 'rubocop-rails', '~> 2.24', '>= 2.24.1'

  gem 'rspec-collection_matchers'
  gem 'rspec-retry', '~> 0.6.2'
  gem 'shoulda-matchers', '~> 6.2'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'timecop', '~> 0.9.8'
  gem 'webmock', '~> 3.23'
end

