# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/machine_data'

describe VagrantSpec::MachineData do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_machine_ssh_config) do
    {
      host:             '127.0.0.1',
      port:             '2222',
      username:         'vagrant',
      private_key_path: %w(mock_key)
    }
  end

  let(:mock_data) do
    {
      name:        'default',
      host:        '127.0.0.1',
      port:        '2222',
      username:    'vagrant',
      private_key: 'mock_key'
    }
  end

  before do
    allow(mock_node).to receive(:name) { 'default' }
    allow(mock_node).to receive(:ssh_info) { mock_machine_ssh_config }
  end

  subject { VagrantSpec::MachineData.new(iso_env) }

  it '#generate create the .vagrantspec_machine_data file' do
    allow(subject).to receive(:populate_data)
    allow(IO).to receive(:write)
      .with('.vagrantspec_machine_data', JSON.pretty_generate(subject.data))
    expect(IO).to receive(:write)
      .with('.vagrantspec_machine_data', JSON.pretty_generate(subject.data))
    subject.generate
  end

  it '#populate_data stores json data' do
    allow(subject.m_finder).to receive(:machines).and_yield(mock_node)
    allow(mock_node).to receive(:ssh_info) { mock_machine_ssh_config }
    expect(subject.data).to receive(:<<).with(mock_data)
    subject.populate_data
  end
end
