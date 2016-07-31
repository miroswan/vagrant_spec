
# encoding: UTF-8

require 'spec_helper'

describe 'ssh' do
  it 'ssh should be running' do
    expect(service('ssh')).to be_running
  end
end