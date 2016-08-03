# encoding: UTF-8

require File.expand_path('../lib/vagrant_spec/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'vagrant_spec'
  s.version     = VagrantSpec::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w(Demitri Swan)
  s.email       = %w(demitriswan@gmail.com)
  s.homepage    = 'http://github.com/miroswan/vagrant_spec'
  s.summary     = 'ServerSpec testing with Vagrant for clustered systems'
  s.description = <<-EOF.gsub(/^{4} /, '')
    This plugin supports ServerSpec testing against clustered systems by
    allowing Vagrant to build and provision all instances before
    running Serverspec and/or RSpec tests.
  EOF

  s.add_dependency 'rspec'
  s.add_dependency 'serverspec'
  s.add_dependency 'ruby_dep', '~> 1.3.1'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = s.files.grep(/^(test|spec|features)/)
  s.require_path = 'lib'
end
