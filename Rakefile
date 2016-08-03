# encoding: UTF-8

require 'rspec/core/rake_task'

task default: %i(unit)

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:unit)

desc 'Run smoke test'
task smoke_test:
  system('scripts/poor_mans_smoke_test.sh')

desc 'Run all tests'
task test: %i(unit smoke_test)
