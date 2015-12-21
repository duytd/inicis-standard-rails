require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
spec = Gem::Specification.find_by_name 'inicis-standard-rails'
load "#{spec.gem_dir}/lib/tasks/inicis.rake"
