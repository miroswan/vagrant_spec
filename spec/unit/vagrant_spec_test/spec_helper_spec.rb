# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/spec_helper'
require 'vagrant_spec/utils'

describe VagrantSpec::SpecHelper do

  include_context  'unit'
  include_examples 'shared_mocks'

  subject { VagrantSpec::SpecHelper.new(iso_env) }

  context 'when @directory does not exist' do
    it '#create_directory creates the directory' do
      allow(Dir).to  receive(:exist?) { false }
      allow(Dir).to  receive(:mkdir)
      expect(Dir).to receive(:mkdir)

      subject.create_directory
    end
  end

  context 'when @directory does exist' do
    it '#create_directory does not create the directory' do
      allow(Dir).to      receive(:exist?) { true }
      allow(Dir).to      receive(:mkdir)
      expect(Dir).not_to receive(:mkdir)

      subject.create_directory
    end
  end

  it '#spec_helper_path returns serverspec/spec_helper.rb' do
    expect(subject.spec_helper_path).to eq('serverspec/spec_helper.rb')
  end

  it '#spec_helper_template includes vagrant_spec/templates/spec_helper.erb' do
    result = subject.spec_helper_template
    expect(result).to match(%r{vagrant_spec/templates/spec_helper.erb})
  end


end