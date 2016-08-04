# encoding: UTF-8

require 'vagrant_spec/ansible_inventory'
require 'vagrant_spec/spec_helper'
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

      attr_accessor :config, :directory, :ansible_inventory
      def initialize(argv, env)
        super
        @config            = VagrantSpec::Config.load env
        @directory         = @config.spec.directory
        @ansible_inventory = @config.spec.ansible_inventory
      end

      def execute
        return unless parse_opts
        VagrantSpec::SpecHelper.new(@env).generate
        unless @ansible_inventory == DEFAULTS['ansible_inventory']
          VagrantSpec::AnsibleInventory.new(@env).generate
        end
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = 'Creates the spec/spec_helper.rb file for testing'
          o.separator ''
          o.separator 'Usage: vagrant spec init'
          o.separator ''
        end
        parse_options(opts)
      end
    end
  end
end
