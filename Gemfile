source "http://www.rubygems.org"

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
when "master"
  {github: "rails/rails"}
when "default"
  ">= 3.2.0"
else
  "~> #{rails_version}"
end

gem "rails", rails

gemspec

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'

  gem 'mocha', '~> 1.3.0', :require => false
  gem 'rspec-rails', '~> 3.7.2'
  gem 'factory_bot_rails', '~> 4.8.2'
end
