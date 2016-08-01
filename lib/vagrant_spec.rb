# encoding: UTF-8

begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant plugin vagrant_spec must be run within Vagrant'
end

module VagrantSpec
  # Plugin definitions
  class Plugin < Vagrant.plugin(2)
    name 'spec'
    description <<-DESC
    This plugin eases rspec and serverspec testing
    DESC

    command :spec do
      require 'vagrant_spec/command/base'
      VagrantSpec::Command::Base
    end

    config :spec do
      require 'vagrant_spec/config/base'
      VagrantSpec::Config::Base
    end
  end
end
