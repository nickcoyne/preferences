begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run specs for Preferences"
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

task :default => :spec

require 'rdoc/task'
desc "Generate documentation for preferences."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'preferences'
  rdoc.options << '--line-numbers' << '--inline-source' << '--main=README.md'
  rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'LICENSE', 'lib/**/*.rb', 'app/**/*.rb')
end
