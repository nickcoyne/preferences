$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'preferences/version'

Gem::Specification.new do |s|
  s.name              = "dm_preferences"
  s.version           = Preferences::VERSION
  s.authors           = ['Brett Walker', 'Aaron Pfeifer']
  s.email             = 'github@digitalmoksha.com'
  s.description       = "Adds support for easily creating custom preferences for ActiveRecord models"
  s.summary           = "Custom preferences for ActiveRecord models"
  s.homepage          = 'https://github.com/digitalmoksha/preferences'
  s.licenses          = ['MIT']

  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  s.test_files        = Dir["spec/**/*"]
  s.rdoc_options      = %w(--line-numbers --inline-source --title preferences --main README.rdoc)
  s.extra_rdoc_files  = %w(README.md CHANGELOG.md LICENSE)
  
  s.add_development_dependency "rails", "~> 4.2"
  s.add_development_dependency "sqlite3", '~> 0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
 end
