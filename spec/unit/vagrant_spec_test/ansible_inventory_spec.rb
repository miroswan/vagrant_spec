# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/ansible_inventory'

describe VagrantSpec::AnsibleInventory do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_ansible_inventory_regexp) { { 'all' => /node/ } }
  let(:mock_ansible_inventory_array) { { 'all' => %w(node1) } }

  let(:mock_machine_ssh_config) do
    {
      'ansible_host'                  => 'node1',
      'ansible_port'                  => '2222',
      'ansible_user'                  => 'vagrant',
      'ansible_ssh_private_key_file'  => 'mock_key'
    }
  end

  subject { VagrantSpec::AnsibleInventory.new(iso_env) }

  def load_ansible_inventory_proc
    proc do
      allow(subject).to  receive(:handle_array)
      allow(subject).to  receive(:handle_regexp)
    end
  end

  context 'when ansible_inventory is a Regexp' do
    it '#load_ansible_inventory calls handle_array' do
      allow(mock_spec).to receive(:ansible_inventory) do
        mock_ansible_inventory_regexp
      end
      load_ansible_inventory_proc.call
      expect(subject).to receive(:handle_regexp)
      subject.load_ansible_inventory
    end
  end

  context 'when ansibe_inventory is an Array' do
    it '#load_ansible_inventory calls handle_regexp' do
      allow(mock_spec).to receive(:ansible_inventory) do
        mock_ansible_inventory_array
      end

      load_ansible_inventory_proc.call
      expect(subject).to receive(:handle_array)
      subject.load_ansible_inventory
    end
  end

  it '#handle_array calls generate_machine_config on each node name' do
    group = mock_ansible_inventory_array.keys[0]
    nodes = mock_ansible_inventory_array.values[0]

    allow(mock_spec).to receive(:ansible_inventory) do
      mock_ansible_inventory_array
    end

    allow(subject).to  receive(:generate_machine_config)
    expect(subject).to receive(:generate_machine_config).with(nodes[0])

    subject.handle_array(group, nodes)
  end

  # Inject code into handle_regexp tests
  def handle_regexp_proc
    proc do
      allow(mock_spec).to receive(:ansible_inventory) do
        mock_ansible_inventory_regexp
      end

      allow(mock_node).to receive(:name) { 'node1' }
      allow(subject).to   receive(:generate_machine_config)
    end
  end

  context 'when nodes are matched' do
    it '#handle_regexp calls generate_machine_config' do
      handle_regexp_proc.call

      allow(subject.m_finder).to receive(:match_nodes) { [mock_node] }
      expect(subject).to receive(:generate_machine_config).with('node1')

      subject.handle_regexp('all', /node/)
    end
  end

  context 'when nodes are not matched' do
    it '#handle_regexp does nothing' do
      handle_regexp_proc.call

      allow(subject.m_finder).to receive(:match_nodes) {}
      expect(subject).to_not     receive(:generate_machine_config)

      subject.handle_regexp('all', /node/)
    end
  end

  def generate_machine_config_proc(_name)
    proc do
      allow(mock_spec).to receive(:ansible_inventory) do
        mock_ansible_inventory_regexp
      end

      allow(subject).to receive(:machine_ssh_config) { mock_machine_ssh_config }
    end
  end

  context 'when a node is found' do
    it '#generate_machine_config calls machine_ssh_config' do
      name = 'node1'
      generate_machine_config_proc(name).call

      allow(subject.m_finder).to receive(:machine).with(name.to_sym) do
        mock_node
      end

      expect(subject).to receive(:machine_ssh_config) do
        { 'name' => mock_machine_ssh_config }
      end

      subject.generate_machine_config(name)
    end
  end

  context 'when a node is not found' do
    it '#generate_machine_config does nothing' do
      name = 'node1'
      generate_machine_config_proc(name).call

      allow(subject.m_finder).to receive(:machine).with(name.to_sym) {}

      expect(subject).not_to receive(:machine_ssh_config) do
        { 'name' => mock_machine_ssh_config }
      end

      subject.generate_machine_config(name)
    end
  end
end
