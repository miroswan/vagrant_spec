# encoding: UTF-8

module VagrantSpec
  # Convenience methods for discovering machines
  #
  # env [Vagrant::Environment]
  class MachineFinder
    def initialize(env)
      @env = env
    end

    # name [Symbol]
    #
    # return [Vagrant::Machine]
    def machine(name)
      @env.active_machines.each do |m|
        node = @env.machine(*m)
        return node if node.name == name
      end
      nil
    end

    # reg [Regexp]
    #
    # return [Array<Vagrant::Machine>]
    def match_nodes(reg)
      @env.active_machines.collect { |m| machine(m[0]) }
          .select { |m| m if reg.match(m.name.to_s) }
    end
  end
end
