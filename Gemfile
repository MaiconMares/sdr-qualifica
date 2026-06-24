source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "image_processing", "~> 1.2"

# Auth & Authorization
gem "devise"
gem "pundit"

# Background jobs (SolidQueue — bundled with Rails 8)
gem "solid_queue"

# File imports
gem "roo", "~> 2.10"
gem "roo-xls", "~> 2.0"

# ViewComponent
gem "view_component"

# Pagination
gem "pagy", "~> 9.0"

# State machine
gem "statesman", "~> 12.0"

# Serialization / CSV
gem "csv"

# Rate limiting
gem "rack-attack"

# Solid adapters (Rails 8 defaults — no Redis required)
gem "solid_cache"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers", "~> 6.0"
end

group :development do
  gem "web-console"
  gem "bullet"
  gem "annotaterb"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
  gem "simplecov", require: false
end
