# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/config'

describe VagrantSpec::Config do
  include_examples 'unit'
  include_examples 'shared_mocks'

  it '#self.load should return the config for the working vagrantfile' do
    expect(iso_env).to     receive(:vagrantfile) { mock_vf_obj }
    expect(mock_vf_obj).to receive(:config)      { mock_config }
    VagrantSpec::Config.load(iso_env)
  end
end
