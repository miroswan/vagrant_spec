# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/command/test'

describe VagrantSpec::Command::Test do
  include_context  'unit'
  include_examples 'shared_mocks'

  let(:mock_test) { double(VagrantSpec::TestPlan) }

  subject { VagrantSpec::Command::Test.new([], iso_env) }

  context 'when parse_opts returns nil' do
    it '#execute should do nothing' do
      allow(VagrantSpec::TestPlan).to receive(:new) { mock_test }

      allow(subject).to               receive(:parse_opts) { nil }
      allow(mock_test).to             receive(:new)
      allow(mock_test).to             receive(:run)

      expect(mock_test).not_to        receive(:new)
      subject.execute
    end
  end

  context 'when parse_opts returns data' do
    it '#execute should test' do
      allow(subject).to               receive(:parse_opts) { 'not_nil' }

      allow(VagrantSpec::TestPlan).to receive(:new) { mock_test }
      allow(mock_test).to             receive(:new)
      allow(mock_test).to             receive(:run)

      expect(mock_test).to receive(:run)
      subject.execute
    end
  end

  it '#parse_opts calls parse_options' do
    allow(subject).to  receive(:parse_options)
    expect(subject).to receive(:parse_options)
    subject.parse_opts
  end
end
