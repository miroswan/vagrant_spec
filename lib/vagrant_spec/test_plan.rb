# encoding: UTF-8

require 'rspec'
require 'serverspec'
require 'specinfra'
require 'specinfra/backend'

require 'vagrant_spec/config'
require 'vagrant_spec/machine_finder'

module VagrantSpec
  # Run serverspec tests
  #
  # env [Vagrant::Environment]
  class TestPlan
    attr_reader :env, :config, :test_plan, :m_finder
    def initialize(env)
      @env       = env
      @config    = VagrantSpec::Config.load(env)
      @test_plan = @config.spec.test_plan
      @m_finder  = VagrantSpec::MachineFinder.new(env)
      @ret_code  = 0
    end

    # Run the test suite and exit based on the return codes of the tests
    #
    # This will fail if any of the tests fail, but it will allow all tests to
    # run
    def run
      print_banner
      @test_plan.each do |plan|
        found_nodes = nodes(plan)
        if found_nodes
          found_nodes.each { |node| execute_plan_tests(node, plan) }
        end
      end
      exit @ret_code
    end

    def print_banner
      @env.ui.info('*******************************************************')
      @env.ui.info('***************** ServerSpec Test Run *****************')
      @env.ui.info('*******************************************************')
      @env.ui.info('')
    end

    # Return array of active Vagrant machines
    #
    # plan   [Hash] item in the @config.spec.test_plan
    #
    # return [Array<Vagrant::Machine>]
    def nodes(plan)
      if plan['nodes'].is_a?(Regexp)
        @m_finder.match_nodes(plan['nodes'])
      elsif plan['nodes'].is_a?(Array)
        plan['nodes'].collect { |n| @m_finder.machine(n.to_sym) }
      end
    end

    # Close existing SSH
    def close_ssh
      if ::Specinfra::Backend::Ssh.instance.get_config(:ssh)
        ::Specinfra::Backend::Ssh.instance.get_config(:ssh).close
        ::Specinfra::Backend::Ssh.instance.set_config(:ssh, nil)
      end
    end

    # Configures ServerSpec
    #
    # node [Vagrant::Machine]
    def configure_serverspec(node)
      set :backend, :ssh
      host           = node.ssh_info[:host].to_s
      options        = Net::SSH::Config.for(host)
      options[:user] = node.ssh_info[:username].to_s
      options[:keys] = node.ssh_info[:private_key_path][0].to_s
      options[:port] = node.ssh_info[:port].to_s

      set :host,        host
      set :ssh_options, options
    end

    # Execute a test_suite and return the code
    #
    # node [Vagrant::Machine]
    # plan [Hash] item in the @config.spec.test_plan
    def execute_plan_tests(node, plan)
      @env.ui.info("[#{node.name}]")
      close_ssh
      configure_serverspec(node)
      plan['flags'].prepend "-I #{@config.spec.directory} "
      ret_code = RSpec::Core::Runner.run(plan['flags'].split, $stderr, $stdout)
      RSpec.clear_examples
      @ret_code = ret_code unless ret_code.zero?
    end
  end
end
