# encoding: UTF-8

require 'vagrant_spec/test_plan'
require 'vagrant_spec/utils'

module VagrantSpec
  module Command
    # This command instantiates serveral files for deployment and testing
    #
    # argv
    # env [Vagrant::Environment]
    class Test < Vagrant.plugin(2, :command)
      include VagrantSpec::Utils
      def initialize(argv, env)
        super
      end

      def execute
        return unless parse_opts
        VagrantSpec::TestPlan.new(@env).run
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = "\nTest: Run the tests configured in the Vagrantfile"
          o.separator ''
          o.separator 'Usage: vagrant spec test'
          o.separator ''
          o.separator IO.read(File.join(template_dir, 'test_help'))
        end
        parse_options(opts)
      end
    end
  end
end
