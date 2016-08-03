# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/config/base'
require 'vagrant/plugin'

describe VagrantSpec::Config::Base do
  include_context  'unit'
  include_examples 'shared_mocks'

  subject { VagrantSpec::Config::Base.new }

  it 'VagrantSpec::Config::Base is a subclass of Vagrant::Plugin::V2::Config' do
    expect(VagrantSpec::Config::Base).to be < Vagrant::Plugin::V2::Config
  end

  %i(directory ansible_inventory test_plan).each do |a|
    it "VagrantSpec::Config::Base has the attr_accessor: #{a}" do
      expect(subject).to have_attr_accessor(a)
    end
  end

  let(:methods) do
    %w(final_directory final_ansible_inventory final_test_plan)
  end

  %w(final_directory final_ansible_inventory final_test_plan).each do |method|
    it "#finalize! calls #{method}" do
      methods.each { |m| allow(subject).to receive(m.to_sym) }
      expect(subject).to receive(method.to_sym)
      subject.finalize!
    end
  end
end
