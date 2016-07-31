
require 'spec_helper'

describe 'Thing that fails' do
  it 'dumb_service totally fails' do
    expect(service('dumb_service')).to be_running
  end
end