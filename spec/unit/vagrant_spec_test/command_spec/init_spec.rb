# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/command/init'

describe VagrantSpec::Command::Init do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_spec_helper) do
    double(VagrantSpec::SpecHelper)
  end

  let(:mock_ansible_inventory) do
    double(VagrantSpec::AnsibleInventory)
  end

  before do
    allow(mock_spec).to receive(:ansible_inventory) { { 'all' => /node/ } }
  end

  subject { VagrantSpec::Command::Init.new([], iso_env) }

  it 'VagrantSpec::Command::Init is subclass of Vagrant::Plugin::V2:Command' do
    expect(VagrantSpec::Command::Init).to be < Vagrant::Plugin::V2::Command
  end

  def execute_proc
    proc do
      allow_any_instance_of(VagrantSpec::SpecHelper).to       receive(:generate)
      allow_any_instance_of(VagrantSpec::AnsibleInventory).to receive(:generate)
      allow(mock_spec_helper).to receive(:generate)
      allow(mock_ansible_inventory).to receive(:generate)
    end
  end

  context 'when parse_opts returns nil' do
    it '#execute does nothing' do
      allow(subject).to receive(:parse_opts) { nil }
      execute_proc.call
      expect(subject.execute).to be_nil
    end
  end

  context 'when parse_opts does not return nil' do
    def execute_protection_proc
      proc do
        allow(subject).to receive(:parse_opts) { 'not_nil' }
        allow(VagrantSpec::SpecHelper).to receive(:new) do
          mock_spec_helper
        end
        allow(VagrantSpec::AnsibleInventory).to receive(:new) do
          mock_ansible_inventory
        end
        execute_proc.call
      end
    end

    context 'and when @ansible_inventory eq empty hash,' do
      it '#execute creates an instance of VagrantSpec::SpecHelper' do
        execute_protection_proc.call
        subject.ansible_inventory = {}

        expect(mock_spec_helper).to           receive(:generate)
        expect(mock_ansible_inventory).to_not receive(:generate)
        subject.execute
      end
    end

    context 'and when @ansible_inventory has data' do
      it '#execute creates instances of SpecHelper and AnsibleInventory' do
        execute_protection_proc.call
        subject.ansible_inventory = { 'all' => /node/ }

        expect(mock_spec_helper).to       receive(:generate)
        expect(mock_ansible_inventory).to receive(:generate)
        subject.execute
      end
    end
  end

  it '#parse_opts calls parse_options' do
    allow(subject).to  receive(:parse_options)
    expect(subject).to receive(:parse_options)
    subject.parse_opts
  end
end
