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
        parse_opts
        VagrantSpec::TestPlan.new(@env).run
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = 'Run the tests configured in Vagrantfile'
          o.separator ''
          o.separator 'Usage: vagrant spec test'
          o.separator ''
        end
        parse_options(opts)
      end
    end
  end
end
