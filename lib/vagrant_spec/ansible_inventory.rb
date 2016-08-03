# encoding: UTF-8

require 'erb'

require 'vagrant_spec/utils'
require 'vagrant_spec/machine_finder'

module VagrantSpec
  # Generate ansible ansible_inventory file
  #
  # env [Vagrant::Environment]
  class AnsibleInventory
    include VagrantSpec::Utils
    attr_accessor :env, :config, :ansible_inventory, :inventory, :m_finder
    def initialize(env)
      @env               = env
      @config            = env.vagrantfile.config
      @ansible_inventory = @config.spec.ansible_inventory
      @inventory         = {}
      @m_finder          = VagrantSpec::MachineFinder.new(env)
    end

    def generate
      load_ansible_inventory
      template_path = File.join(template_dir, 'vagrantspec_inventory.erb')
      template      = IO.read(template_path)
      f             = ERB.new(template, 0, '<>').result(binding)
      IO.write('vagrantspec_inventory', f)
    end

    def load_ansible_inventory
      @ansible_inventory.each do |group, nodes|
        if nodes.is_a?(Array)
          handle_array(group, nodes)
        elsif nodes.is_a?(Regexp)
          handle_regexp(group, nodes)
        end
      end
    end

    # group [String]
    # nodes [Array<String>]
    def handle_array(group, nodes)
      @inventory[group] = nodes.collect do |name|
        generate_machine_config(name)
      end
    end

    # group [String]
    # nodes [Array<String>]
    def handle_regexp(group, nodes)
      machines = @m_finder.match_nodes(nodes)
      if machines
        @inventory[group] = machines.collect do |name|
          generate_machine_config(name.name)
        end
      end
    end

    # name [String]
    def generate_machine_config(name)
      node = @m_finder.machine(name.to_sym)
      return nil unless node
      ssh_config = machine_ssh_config(node)
      { name => ssh_config }
    end

    # machine [Vagrant::Machine]
    def machine_ssh_config(machine)
      ssh_config = machine.ssh_info
      key = ssh_config[:private_key_path][0]
      config = {}
      config['ansible_host']                 = ssh_config[:host]
      config['ansible_port']                 = ssh_config[:port]
      config['ansible_user']                 = ssh_config[:username]
      config['ansible_ssh_private_key_file'] = key
      config
    end
  end
end
