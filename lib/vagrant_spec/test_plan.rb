# encoding: UTF-8

require 'rspec'

require 'vagrant_spec/config'
require 'vagrant_spec/machine_finder'

module VagrantSpec
  # Run serverspec tests
  #
  # env [Vagrant::Environment]
  class TestPlan
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
      @env.ui.info('*******************************************************')
      @env.ui.info('***************** ServerSpec Test Run *****************')
      @env.ui.info('*******************************************************')
      @env.ui.info('')
      @test_plan.each do |plan|
        nodes(plan).each { |node| execute_plan_tests(node, plan) }
      end
      exit @ret_code
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

    # Execute a test_suite and return the code
    #
    # node [Vagrant::Machine]
    # plan [Hash] item in the @config.spec.test_plan
    #
    # return [@ret_code]
    def execute_plan_tests(node, plan)
      @env.ui.info("[#{node.name}]")
      ENV['VAGRANT_HOST'] = node.ssh_info[:host].to_s
      ENV['VAGRANT_PORT'] = node.ssh_info[:port].to_s
      ENV['VAGRANT_KEY']  = node.ssh_info[:private_key_path][0].to_s
      ENV['VAGRANT_USER'] = node.ssh_info[:username].to_s
      plan['flags'].prepend "-I #{@config.spec.directory} "
      ret_code = RSpec::Core::Runner.run(plan['flags'].split, $stderr, $stdout)
      RSpec.clear_examples
      @ret_code = ret_code unless ret_code.zero?
    end
  end
end
