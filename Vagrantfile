
Vagrant.configure(2) do |config|
  config.vm.define 'test_ansible' do |b|
    b.vm.box = 'ubuntu/trusty64'
  end

  config.vm.define 'test_pansible' do |b|
    b.vm.box = 'ubuntu/trusty64'
  end

  # key: Ansible Group Name
  # value: Regexp matching your node names or an array of nodes
  config.spec.ansible_inventory = { 'all' => /test/ }

  # nodes: Regexp matching the desired nodes or array of nodes
  # flags: Command line flags you would pass to rspec 
  config.spec.test_plan = [
    {
      'nodes' => /test_ansi/,
      'flags' => '--format documentation --color --pattern serverspec/ssh*'
    },
    {
      'nodes' => /test_pansi/,
      'flags' => '--format documentation --color --pattern serverspec/fail*'
    }
  ]
end
