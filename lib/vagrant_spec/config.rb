# encoding: UTF-8

module VagrantSpec
  # Autoload
  module Config
    autoload :Base, 'vagrant_spec/config/base'

    DEFAULTS = {
      'directory'             => 'serverspec',
      'ansible_inventory'     => {},
      'test_plan'             => [],
      'generate_machine_data' => true
    }.freeze

    class << self
      def load(env)
        env.vagrantfile.config
      end
    end
  end
end
