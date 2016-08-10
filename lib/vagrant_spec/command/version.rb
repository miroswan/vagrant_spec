# encoding: UTF-8

require 'vagrant_spec/version'

module VagrantSpec
  module Command
    # Provide CLI interface to retrieving version information
    class Version < Vagrant.plugin(2, :command)
      def intiialize(argv, env)
        @env  = env
        @argv = argv
      end

      def execute
        return unless parse_opts
        @env.ui.info("vagrant_spec: #{VagrantSpec::VERSION}")
      end

      def parse_opts
        opts = OptionParser.new do |o|
          o.banner = "\nVersion: Output the version of the plugin"
          o.separator ''
          o.separator 'Usage: vagrant spec version'
          o.separator ''
        end
        parse_options(opts)
      end
    end
  end
end
