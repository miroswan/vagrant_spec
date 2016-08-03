# encoding: UTF-8

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i(unit)

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:unit)

desc 'Run rubocop'
RuboCop::RakeTask.new(:cop)

desc 'Run smoke test'
task :smoke_test do
  system('scripts/poor_mans_smoke_test.sh')
end

desc 'Run rubocop and unit tests'
task travis: %i(cop unit)

desc 'Run all tests'
task test: %i(cop unit smoke_test)
