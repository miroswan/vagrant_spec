# encoding: UTF-8

module VagrantSpec
  # Autoload
  module Command
    autoload :Base, 'vagrant_spec/command/base'
    autoload :Init, 'vagrant_spec/command/init'
  end
end
