# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/machine_finder'

describe VagrantSpec::MachineFinder do
  include_context  'unit'
  include_examples 'shared_mocks'

  before do
    allow(iso_env).to   receive(:active_machines) { [['node1', :virtualbox]] }
    allow(mock_node).to receive(:name)            { 'node1' }

    allow(iso_env).to receive(:machine).with('node1', :virtualbox) { mock_node }
  end

  subject { VagrantSpec::MachineFinder.new(iso_env) }

  it '#machine returns the node if found' do
    expect(subject.machine('node1')).to eq(mock_node)
  end

  it '#match_nodes returns an array of found Vagrant::Machine objects' do
    allow(subject).to receive(:machine) { mock_node }
    expect(subject.match_nodes(/node/)).to eq([mock_node])
  end
end
