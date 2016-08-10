
Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.define 'test_ansible' do |b|
    b.vm.hostname = 'ansible'
  end

  config.vm.define 'test_pansible' do |b|
    b.vm.hostname = 'pansible'
  end

  # key: Ansible Group Name
  # value: Regexp matching your node names or an array of nodes
  config.spec.ansible_inventory = { 'ansi' => /_ansi/, 'pansi' => /_pansi/ }

  # nodes: Regexp matching the desired nodes or array of nodes
  # flags: Command line flags you would pass to rspec
  config.spec.test_plan = [
    {
      'nodes' => /test_ansi/,
      'flags' => '--format documentation --color --pattern serverspec/ansi*'
    },
    {
      'nodes' => /test_pansi/,
      'flags' => '--format documentation --color --pattern serverspec/pansi*'
    }
  ]
end
