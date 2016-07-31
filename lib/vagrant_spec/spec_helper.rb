# encoding: UTF-8

require 'vagrant_spec/config'

module VagrantSpec
  # Generates a spec_helper.rb for integration testing
  #
  # env [Vagrant::Environment]
  class SpecHelper
    include VagrantSpec::Utils
    def initialize(env)
      @env = env
      @directory = VagrantSpec::Config.load(env).spec.directory
    end

    # Generate the spec_helper.rb
    def generate
      create_directory
      return if File.exist? spec_helper_path
      sh = ERB.new(IO.read(spec_helper_template), 0, '<>').result binding
      IO.write(spec_helper_path, sh)
    end

    # return [String]
    def create_directory
      Dir.mkdir @directory unless Dir.exist? @directory
    end

    # return [String]
    def spec_helper_path
      File.join(@directory, 'spec_helper.rb')
    end

    # return [String]
    def spec_helper_template
      File.join(template_dir, 'spec_helper.erb')
    end
  end
end
