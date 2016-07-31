# vagrant_spec

Vagrant Spec is a Vagrant plugin that makes integration testing for deployments
to clustered systems a breeze. It also seperates the build and deployment steps
to clearly delineate pipeline tasks. 

Here is a sample Vagrantfile:

```
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
      'nodes' => /test/,
      'flags' => '--format documentation --color serverspec'
    }
  ]
end
```

## Configuration

* config.spec.ansible_inventory: a hash that maps ansible groups to your nodes.
You can specify as many groups as you need. You can match nodes by regular 
expression or explicitly provide an array of node names. 

* config.spec.test_plan: an array of hashes. nodes can either be a regular 
expression object that matches your desired nodes or an explicit array of 
nodes. flags is a string that matches the desired flags you would pass to
rspec. The last argument is typically a pattern that maps to the tests you'd 
like to run. This allows you to split out what tests you'd like to run across
your cluster of nodes. 

## Sub Commands

* init: This will generate your spec_helper.rb for serverspec testing and your
ansible inventory file. You'll typically want to run this after a vagrant up,
and before your deployment and testing tasks. 

* test: This will run the tests specified in your Vagrantfile. Tests are
executed against each node in your fleet and the exit code is stored if an error
occurs. All tests will run. The exit code of the last failed run will return
to the shell. Otherwise, it will return zero. 

## Sample Output

```
> bundle exec vagrant spec test

*******************************************************
***************** ServerSpec Test Run *****************
*******************************************************

[test_ansible]

ssh
  ssh should be running
  thing fails (FAILED - 1)

Failures:

  1) ssh thing fails
     On host `127.0.0.1'
     Failure/Error: expect(service('dumb_service')).to be_running
       expected Service "dumb_service" to be running
       sudo -p 'Password: ' /bin/sh -c ps\ aux\ \|\ grep\ -w\ --\ dumb_service\ \|\ grep\ -qv\ grep

     # ./serverspec/ssh_spec.rb:11:in `block (2 levels) in <top (required)>'
     # ./lib/vagrant_spec/test_plan.rb:62:in `execute_plan_tests'
     # ./lib/vagrant_spec/test_plan.rb:31:in `block (2 levels) in run'
     # ./lib/vagrant_spec/test_plan.rb:31:in `each'
     # ./lib/vagrant_spec/test_plan.rb:31:in `block in run'
     # ./lib/vagrant_spec/test_plan.rb:26:in `each'
     # ./lib/vagrant_spec/test_plan.rb:26:in `run'
     # ./lib/vagrant_spec/command/test.rb:18:in `execute'
     # ./lib/vagrant_spec/command/base.rb:61:in `parse_subcommand'
     # ./lib/vagrant_spec/command/base.rb:25:in `execute'

Finished in 0.488 seconds (files took 1.6 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./serverspec/ssh_spec.rb:10 # ssh thing fails

[test_pansible]

ssh
  ssh should be running
  thing fails (FAILED - 2)

Failures:

  1) ssh thing fails
     On host `127.0.0.1'
     Failure/Error: expect(service('dumb_service')).to be_running
       expected Service "dumb_service" to be running
       sudo -p 'Password: ' /bin/sh -c ps\ aux\ \|\ grep\ -w\ --\ dumb_service\ \|\ grep\ -qv\ grep

     # ./serverspec/ssh_spec.rb:11:in `block (2 levels) in <top (required)>'
     # ./lib/vagrant_spec/test_plan.rb:62:in `execute_plan_tests'
     # ./lib/vagrant_spec/test_plan.rb:31:in `block (2 levels) in run'
     # ./lib/vagrant_spec/test_plan.rb:31:in `each'
     # ./lib/vagrant_spec/test_plan.rb:31:in `block in run'
     # ./lib/vagrant_spec/test_plan.rb:26:in `each'
     # ./lib/vagrant_spec/test_plan.rb:26:in `run'
     # ./lib/vagrant_spec/command/test.rb:18:in `execute'
     # ./lib/vagrant_spec/command/base.rb:61:in `parse_subcommand'
     # ./lib/vagrant_spec/command/base.rb:25:in `execute'

Finished in 0.06189 seconds (files took 0.58192 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./serverspec/ssh_spec.rb:10 # ssh thing fails

> echo $?
1
```

## Development

* Fork the development branch
* ```bundle install```
* bundle exec vagrant up
* bundle exec vagrant init
* bundle exec vagrant test

## Notes:

This plugin is not yet deployed to RubyGems. I still have some work to do before
I can release.

I'd like to entertain support for Fabric and Capistrano. 
