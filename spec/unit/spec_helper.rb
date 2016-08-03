# encoding: UTF-8

require 'rspec'

# Get path to vagrant's test directory so we can load that code. We'll want it
# for getting access to its convenient shared methods and contexts and such
VAGRANT_LIB_DIR  = Gem::Specification.find_by_name('vagrant').gem_dir.freeze
VAGRANT_TEST_DIR = File.join(VAGRANT_LIB_DIR, 'test').freeze

# Load code paths
$LOAD_PATH.unshift File.expand_path(File.join('..', '..', 'lib'), __FILE__)
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path(VAGRANT_TEST_DIR, __FILE__)

require 'vagrant'
require 'vagrant_spec'

require 'unit/support/shared/base_context'
require 'unit/support/shared/virtualbox_context'

# Build methods to retrieve plugins against VagrantSpec::Plugin.
#
# Example: get_commands(VagrantSpec::Plugin)
#
# The method call above will return an array of Command plugin names as symbols.
# Add support by extending the symbol arrays as needed
%i(command).each do |plugin|
  plural = "#{plugin}s"
  plural_symbol = plural.to_sym
  method_name = "get_#{plural}"
  define_method(method_name) do |plugin_obj|
    plugin_obj.components.send(plural_symbol).keys
  end
end

%i(config).each do |plugin|
  plural = "#{plugin}s"
  plural_symbol = plural.to_sym
  method_name = "get_#{plural}"
  define_method(method_name) do |plugin_obj|
    plugin_obj.components.send(plural_symbol)[:top].keys
  end
end

RSpec.shared_examples 'shared_mocks' do
  let(:vagrant_file) do
    <<-EOF.gsub(/^ {4}/, '')
    Vagrant.configure(2) do |config|
      config.vm.box = 'test'
    end
    EOF
  end

  let(:mock_vf_obj) { double(Vagrant::Vagrantfile)      }
  let(:mock_ui)     { double(Vagrant::UI)               }
  let(:mock_config) { double(Vagrant::Config)           }
  let(:mock_spec)   { double(VagrantSpec::Config::Base) }
  let(:mock_node)   { double(Vagrant::Machine)          }

  let(:spec_dir)    { 'serverspec'                      }

  let(:iso_env) do
    env = isolated_environment
    env.vagrantfile vagrant_file
    env.create_vagrant_env
    env
  end

  before do
    allow(iso_env).to     receive(:ui)
    allow(mock_node).to   receive(:name)
    allow(mock_ui).to     receive(:info)

    allow(iso_env).to     receive(:vagrantfile) { mock_vf_obj   }
    allow(iso_env).to     receive(:ui)          { mock_ui       }
    allow(mock_vf_obj).to receive(:config)      { mock_config   }
    allow(mock_config).to receive(:spec)        { mock_spec     }
    allow(mock_spec).to   receive(:directory)   { spec_dir      }
  end
end
