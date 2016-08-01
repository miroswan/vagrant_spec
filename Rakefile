# encoding: UTF-8

require 'rspec/core/rake_task'

task default: %i(unit)

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = 'spec/unit/**/*test.rb'
end
