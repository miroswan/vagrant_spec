# encoding: UTF-8

require 'vagrant_spec/test_plan'

module VagrantSpec
  module Command
    # This command instantiates serveral files for deployment and testing
    #
    # argv
    # env [Vagrant::Environment]
    class Test < Vagrant.plugin(2, :command)
      def initialize(argv, env)
        super
      end

      def execute
        return unless parse_opts
        VagrantSpec::TestPlan.new(@env).run
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = "\nRun the tests configured in the Vagrantfile"
          o.separator ''
          o.separator 'Usage: vagrant spec test'
          o.separator ''
        end
        parse_options(opts)
      end
    end
  end
end
