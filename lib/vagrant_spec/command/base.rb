# encoding: UTF-8

module VagrantSpec
  module Command
    # This command plugin routes to the available subcommands
    class Base < Vagrant.plugin(2, :command)
      def self.synopsis
        'test deployments to clustered systems'
      end

      def initialize(argv, env)
        super
        @main_args,
        @sub_command,
        @sub_args       = split_main_and_subcommand(argv)
        @valid_commands = Dir.glob(File.join(File.dirname(__FILE__), '*'))
                             .collect { |f| File.basename(f).gsub(/\.rb$/, '') }
                             .select  { |f| f != 'base' }
        @subcommands    = Vagrant::Registry.new
        @env            = env
      end

      def execute
        register_subcommands
        return if !parse_main_args || !parse_subcommand
      end

      def register_subcommands
        @valid_commands.each do |cmd|
          @subcommands.register cmd.to_sym do
            cmd_str = cmd.to_s
            require "vagrant_spec/command/#{cmd_str}"
            Object.const_get "VagrantSpec::Command::#{cmd_str.capitalize}"
          end
        end
      end

      def help
        opts = OptionParser.new do |o|
          o.banner = 'Usage: vagrant spec <command> [<args>]'
          o.separator ''
          o.separator 'Available subcommands:'
          @valid_commands.sort.each { |cmd| o.separator "     #{cmd}" }
          o.separator ''
          o.separator 'For help on any individual command run `vagrant spec ' \
                      '<command> -h`'
        end
        parse_options(opts)
      end

      def parse_main_args
        if @main_args.include?('-h') || @main_args.include?('--help')
          return help
        end
        true
      end

      def parse_subcommand
        klass = @subcommands.get(@sub_command.to_sym) if @sub_command
        return help if klass.nil? || @sub_command.nil?
        klass.new(@sub_args, @env).execute
        true
      end
    end
  end
end
