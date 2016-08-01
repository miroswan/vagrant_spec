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
