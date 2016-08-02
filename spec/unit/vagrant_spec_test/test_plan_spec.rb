# encoding: UTF-8

# Local
require 'spec_helper'
require 'vagrant_spec/test_plan'
require 'vagrant_spec/command/test'


describe VagrantSpec::TestPlan do
  include_context 'unit'

  ##############################################################################
  # mocks

  let(:vagrant_file) do
    <<-EOF.gsub(/^ {4}/, '')
    Vagrant.configure(2) do |config|
      config.vm.box = 'test'
    end
    EOF
  end

  let(:mock_vf_obj) { double(Vagrant::Vagrantfile)      }
  let(:mock_ui)     { double(Vagrant::UI)               }
  let(:mock_config) { double(Vagrant::Config)           }
  let(:mock_spec)   { double(VagrantSpec::Config::Base) }
  let(:mock_node)   { double(Vagrant::Machine)          }

  let(:iso_env) do
    env = isolated_environment
    env.vagrantfile vagrant_file
    env.create_vagrant_env
    env
  end
  
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

  let(:spec_dir) { 'serverspec' }

  let(:mock_ssh_info) do
    {
      host:             'test_host',
      port:             '2222',
      private_key_path: [ 'path_to_key' ],
      username:         'vagrant'
    }
  end

 ###############################################################################
 # Stubs

  before do
    allow_any_instance_of(VagrantSpec::MachineFinder)
      .to receive(:match_nodes) { [double(Vagrant::Machine)] }
    allow_any_instance_of(VagrantSpec::MachineFinder)
      .to receive(:machine)     { double(Vagrnat::Machine)   }

    allow(RSpec::Core::Runner).to receive(:run) { 0 }
    allow(iso_env).to             receive(:ui)
    allow(mock_node).to           receive(:name)

    allow(iso_env).to     receive(:vagrantfile) { mock_vf_obj   }
    allow(iso_env).to     receive(:ui)          { mock_ui       }
    allow(mock_ui).to     receive(:info)         
    allow(mock_vf_obj).to receive(:config)      { mock_config   }
    allow(mock_config).to receive(:spec)        { mock_spec     }
    allow(mock_spec).to   receive(:test_plan)   { mock_plan     }
    allow(mock_spec).to   receive(:directory)   { spec_dir      }
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

  it '#execute_plan_tests runs the RSPec tests' do
    expect(RSpec::Core::Runner).to receive(:run)
    subject.execute_plan_tests(mock_node, mock_plan[0])
  end

  it '#execute adds the spec.directory to the load path' do
    subject.execute_plan_tests(mock_node, mock_plan[0])
    expect(subject.test_plan[0]['flags']).to include('-I serverspec')
  end
end
