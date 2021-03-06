# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/command/init'

describe VagrantSpec::Command::Init do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_ansible_inventory) do
    double(VagrantSpec::AnsibleInventory)
  end

  let(:mock_machine_data) do
    double(VagrantSpec::MachineData)
  end

  before do
    allow(mock_spec).to receive(:ansible_inventory) { { 'all' => /node/ } }
    allow(mock_spec).to receive(:generate_machine_data)
  end

  subject { VagrantSpec::Command::Init.new([], iso_env) }

  it 'VagrantSpec::Command::Init is subclass of Vagrant::Plugin::V2:Command' do
    expect(VagrantSpec::Command::Init).to be < Vagrant::Plugin::V2::Command
  end

  def execute_proc
    proc do
      allow_any_instance_of(VagrantSpec::AnsibleInventory).to receive(:generate)
      allow_any_instance_of(VagrantSpec::MachineData).to      receive(:generate)
      allow(mock_ansible_inventory).to receive(:generate)
      allow(mock_machine_data).to      receive(:generate)
      allow(Dir).to                    receive(:exist?) { false }
      allow(FileUtils).to              receive(:mkdir)
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
        allow(VagrantSpec::AnsibleInventory).to receive(:new) do
          mock_ansible_inventory
        end
        allow(VagrantSpec::MachineData).to receive(:new) { mock_machine_data }
        execute_proc.call
      end
    end

    context 'when the @directory does not exist' do
      it '#execute creates the @directory' do
        execute_protection_proc.call
        expect(FileUtils).to receive(:mkdir).with(subject.directory)
        subject.execute
      end
    end

    context 'and when @ansible_inventory eq empty hash,' do
      it '#execute creates an instance of VagrantSpec::SpecHelper' do
        execute_protection_proc.call
        subject.ansible_inventory = {}
        expect(mock_ansible_inventory).to_not receive(:generate)
        subject.execute
      end
    end

    context 'and when @ansible_inventory has data' do
      it '#execute creates instances of SpecHelper and AnsibleInventory' do
        execute_protection_proc.call
        subject.ansible_inventory = { 'all' => /node/ }

        expect(mock_ansible_inventory).to receive(:generate)
        subject.execute
      end
    end

    context 'and when @generate_machine_data is true' do
      it '#execute generates a .vagrantspec_machine_data file' do
        execute_protection_proc.call
        subject.generate_machine_data = true
        expect(mock_machine_data).to receive(:generate)
        subject.execute
      end
    end

    context 'and when @generate_machine_data is false' do
      it '#execute does not generate a .vagrantspec_machine_data file' do
        execute_protection_proc.call
        subject.generate_machine_data = false
        expect(mock_machine_data).not_to receive(:generate)
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
