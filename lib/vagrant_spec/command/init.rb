# encoding: UTF-8

require 'vagrant_spec/ansible_inventory'
require 'vagrant_spec/spec_helper'
require 'vagrant_spec/machine_data'
require 'vagrant_spec/config'

module VagrantSpec
  module Command
    # This command instantiates serveral files for deployment and testing
    #
    # argv
    # env [Vagrant::Environment]
    class Init < Vagrant.plugin(2, :command)
      include VagrantSpec::Utils

      DEFAULTS = VagrantSpec::Config::DEFAULTS

      attr_accessor :config
      attr_accessor :directory
      attr_accessor :ansible_inventory
      attr_accessor :generate_machine_data

      def initialize(argv, env)
        super
        @config                = VagrantSpec::Config.load env
        @directory             = @config.spec.directory
        @ansible_inventory     = @config.spec.ansible_inventory
        @generate_machine_data = @config.spec.generate_machine_data
      end

      def execute
        return unless parse_opts
        VagrantSpec::SpecHelper.new(@env).generate
        unless @ansible_inventory == DEFAULTS['ansible_inventory']
          VagrantSpec::AnsibleInventory.new(@env).generate
        end
        if @generate_machine_data == DEFAULTS['generate_machine_data']
          VagrantSpec::MachineData.new(@env).generate
        end
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = "\nInit: Initializes state configuration"
          o.separator ''
          o.separator 'Usage: vagrant spec init'
          o.separator ''
          o.separator IO.read(File.join(template_dir, 'init_help'))
        end
        parse_options(opts)
      end
    end
  end
end
