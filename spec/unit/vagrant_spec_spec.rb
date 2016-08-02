# encoding: UTF-8

require_relative 'spec_helper'

describe VagrantSpec::Plugin do
  it 'has a command plugin: spec' do
    expect(get_commands(VagrantSpec::Plugin)).to include(:spec)
  end

  it 'has a config plugin: spec' do
    expect(get_configs(VagrantSpec::Plugin)).to include(:spec)
  end
end
