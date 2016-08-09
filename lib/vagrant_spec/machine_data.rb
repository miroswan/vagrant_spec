# encoding: UTF-8

require 'json'
require 'vagrant_spec/machine_finder'

module VagrantSpec
  # Handle machine data generation
  class MachineData
    attr_accessor :env, :m_finder, :data
    def initialize(env)
      @env      = env
      @m_finder = VagrantSpec::MachineFinder.new(@env)
      @data     = []
    end

    def generate
      populate_data
      IO.write('.vagrantspec_machine_data', JSON.pretty_generate(@data))
    end

    def populate_data
      @m_finder.machines do |m|
        private_key = m.ssh_info[:private_key_path][0]
        @data << {
          name:        m.name,
          host:        m.ssh_info[:host],
          port:        m.ssh_info[:port],
          username:    m.ssh_info[:username],
          private_key: private_key
        }
      end
    end
  end
end
