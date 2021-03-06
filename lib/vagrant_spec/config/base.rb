# encoding: UTF-8

require 'vagrant_spec/config'

module VagrantSpec
  module Config
    # This class handles the configuration options in the Vagrantfile
    class Base < Vagrant.plugin(2, :config)
      DEFAULTS = VagrantSpec::Config::DEFAULTS

      attr_accessor :directory
      attr_accessor :ansible_inventory
      attr_accessor :test_plan
      attr_accessor :generate_machine_data

      def initialize
        @directory             = UNSET_VALUE
        @ansible_inventory     = UNSET_VALUE
        @test_plan             = UNSET_VALUE
        @generate_machine_data = UNSET_VALUE
      end

      def final_directory
        @directory = DEFAULTS['directory'] if @directory == UNSET_VALUE
      end

      def final_ansible_inventory
        if @ansible_inventory == UNSET_VALUE
          @ansible_inventory = DEFAULTS['ansible_inventory']
        end
      end

      def final_test_plan
        @test_plan = DEFAULTS['test_plan'] if @test_plan == UNSET_VALUE
      end

      def final_generate_machine_data
        if @generate_machine_data == UNSET_VALUE
          @generate_machine_data = DEFAULTS['generate_machine_data']
        end
      end

      def finalize!
        final_directory
        final_ansible_inventory
        final_test_plan
        final_generate_machine_data
      end
    end
  end
end
