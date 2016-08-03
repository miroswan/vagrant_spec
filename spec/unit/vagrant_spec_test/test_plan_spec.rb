# encoding: UTF-8

# Local
require 'spec_helper'
require 'vagrant_spec/test_plan'
require 'vagrant_spec/command/test'
require 'rspec/support/spec/in_sub_process'
require 'rspec/support/spec/stderr_splitter'

describe VagrantSpec::TestPlan do
  include RSpec::Support::InSubProcess
  include_context 'unit'

  ##############################################################################
  # mocks

  include_examples 'shared_mocks'

  let(:mock_plan) do
    [
      {
        'nodes' => /test1/,
        'flags' => '--format documentation --color --pattern serverspec/ssh*'
      },
      {
        'nodes' => %w(test2),
        'flags' => '--format documentation --color --pattern serverspec/fail*'
      }
    ]
  end

  let(:mock_ssh_info) do
    {
      host:             'test_host',
      port:             '2222',
      private_key_path: ['path_to_key'],
      username:         'vagrant'
    }
  end

  ##############################################################################
  # Stubs

  before do
    allow_any_instance_of(VagrantSpec::MachineFinder)
      .to receive(:match_nodes) { [double(Vagrant::Machine)] }
    allow_any_instance_of(VagrantSpec::MachineFinder)
      .to receive(:machine)     { double(Vagrant::Machine)   }

    allow(RSpec::Core::Runner).to receive(:run) { 0 }
    allow(iso_env).to             receive(:ui)
    allow(mock_node).to           receive(:name)

    allow(iso_env).to     receive(:ui)          { mock_ui       }
    allow(mock_ui).to     receive(:info)
    allow(mock_spec).to   receive(:test_plan)   { mock_plan     }
    allow(mock_node).to   receive(:ssh_info)    { mock_ssh_info }
  end

  subject { VagrantSpec::TestPlan.new(iso_env) }

  ##############################################################################
  # Testing #nodes

  context 'when passing a Regexp object' do
    it '#nodes calls match_nodes on a machine_finder instance' do
      expect(subject.m_finder).to receive(:match_nodes)
      subject.nodes(mock_plan[0])
    end
  end

  context 'when passing an Array object' do
    it "#nodes calls collect on a the plan's nodes" do
      expect(mock_plan[1]['nodes']).to receive(:collect)
      subject.nodes(mock_plan[1])
    end

    it '#nodes calls machine on the machine_finder instance' do
      expect(subject.m_finder).to receive(:machine)
      subject.nodes(mock_plan[1])
    end
  end

  ##############################################################################
  # Testing #execute_plan_tests
  #
  # These tests must be executed in a sub process because execute_plan_tests
  # executes clear_examples. clear_examples modifies global state, so we must
  # contain it.

  it '#execute_plan_tests runs the RSPec tests' do
    in_sub_process do
      expect(RSpec::Core::Runner).to receive(:run)
      subject.execute_plan_tests(mock_node, mock_plan[0])
    end
  end

  it '#execute adds the spec.directory to the load path' do
    in_sub_process do
      subject.execute_plan_tests(mock_node, mock_plan[0])
      expect(subject.test_plan[0]['flags']).to include('-I serverspec')
    end
  end
end
