# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/command/base'

describe VagrantSpec::Command::Base do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_opts)     { double(OptionParser) }
  let(:mock_registry) { double(Vagrant::Registry) }

  before do
    allow(Dir).to receive(:glob) { %w(base.rb foo.rb bar.rb bing.rb) }
    allow_any_instance_of(VagrantSpec::Command::Base)
      .to receive(:instance_variable_get).with('subcommands') { mock_registry }
  end

  subject { VagrantSpec::Command::Base.new([], iso_env) }

  it 'VagrantSpec::Command::Base is subclass of Vagrant::Plugin::V2:Command' do
    expect(VagrantSpec::Command::Base).to be < Vagrant::Plugin::V2::Command
  end

  it 'instance contains the correct valid commands' do
    expect(subject.valid_commands).to eq(%w(foo bar bing))
  end

  it '#register_subcommands results in the correct length' do
    subject.valid_commands.each do |cmd|
      allow(subject.subcommands).to  receive(:register).with(cmd.to_sym)
      expect(subject.subcommands).to receive(:register).with(cmd.to_sym)
    end
    subject.register_subcommands
  end

  context 'when -h is passed' do
    it '#parse_main_args returns help' do
      i = VagrantSpec::Command::Base.new(%w(-h), iso_env)
      allow(i).to receive(:help)
      expect(i).to receive(:help)
      i.parse_main_args
    end
  end

  context 'when --help is passed' do
    it '#parse_main_args returns help' do
      i = VagrantSpec::Command::Base.new(%w(--help), iso_env)
      allow(i).to receive(:help)
      expect(i).to receive(:help)
      i.parse_main_args
    end
  end

  it '#print_help prints help output' do
    i = VagrantSpec::Command::Base.new([], iso_env)
    allow(i).to receive(:instance_variable_get).with('opts') do
      mock_opts
    end

    allow(i).to         receive(:help)
    allow(i.env).to     receive(:ui) { mock_ui }
    allow(mock_ui).to   receive(:info)
    allow(mock_opts).to receive(:help)

    expect(i).to        receive(:help)
    expect(i.env).to    receive(:ui)
    expect(i.opts).to   receive(:help)

    i.print_help
  end

  context 'when no @sub_commands are nil' do
    it '#parse_subcommands prints help' do
      allow(subject).to receive(:instance_variable_get).with('sub_command') do
        nil
      end
      allow(subject.subcommands).to receive(:get) { nil }
      allow(subject).to  receive(:print_help)
      expect(subject).to receive(:print_help)
      subject.parse_subcommand
    end
  end

  context 'when @subcommands.get returns nil' do
    it '#parse_subcommands prints help' do
      allow(subject).to receive(:instance_variable_get).with('sub_command') do
        'mock_command'
      end
      allow(subject.subcommands).to receive(:get) { nil }
      allow(subject).to  receive(:print_help)
      expect(subject).to receive(:print_help)
      subject.parse_subcommand
    end
  end

  it '#execute registers subcommands and parses' do
    allow(subject).to receive(:register_subcommands)
    allow(subject).to receive(:parse_main_args)  { 'not_nil' }
    allow(subject).to receive(:parse_subcommand) { 'not_nil' }
    expect(subject).to receive(:register_subcommands)
    expect(subject).to receive(:parse_main_args)
    expect(subject).to receive(:parse_subcommand)
    subject.execute
  end
end
