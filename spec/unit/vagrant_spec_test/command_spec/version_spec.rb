# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/command/version'

describe VagrantSpec::Command::Version do
  include_context  'unit'
  include_examples 'shared_mocks'

  subject { VagrantSpec::Command::Version.new([], iso_env) }

  context 'when parse_opts returns data' do
    it '#execute calls env.ui.info' do
      allow(subject).to receive(:parse_opts) { 'not_nil' }
      expect(mock_ui).to receive(:info)
      subject.execute
    end
  end

  it '#parse_opts calls parse_options' do
    allow(subject).to receive(:parse_options)
    expect(subject).to receive(:parse_options)
    subject.parse_opts
  end
end
