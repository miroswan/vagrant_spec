# encoding: UTF-8

require 'spec_helper'
require 'vagrant_spec/utils'

describe VagrantSpec::Utils do
  let(:klass) do 
    Class.new { include VagrantSpec::Utils }.new
  end

  it '#project_root dirname is vagrant_spec' do
    expect(File.basename(klass.project_root)).to eq('vagrant_spec')
  end

  it '#lib_root contains vagrant_spec/lib' do
    expect(klass.lib_root).to match(/.*vagrant_spec\/lib/)
  end

  it '#template_dir contains vagrant_spec/lib/vagrant_spec/templates' do
    expect(klass.template_dir).to match(
      /.*vagrant_spec\/lib\/vagrant_spec\/templates/
    )
  end
end