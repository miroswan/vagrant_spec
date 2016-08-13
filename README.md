# vagrant_spec

[![Gem Version](https://badge.fury.io/rb/vagrant_spec.svg)](https://badge.fury.io/rb/vagrant_spec)
[![Build Status](https://travis-ci.org/miroswan/vagrant_spec.svg?branch=master)](https://travis-ci.org/miroswan/vagrant_spec) 
[![Coverage Status](https://coveralls.io/repos/github/miroswan/vagrant_spec/badge.svg?branch=master)](https://coveralls.io/github/miroswan/vagrant_spec?branch=master)


Vagrant Spec is a Vagrant plugin that makes integration testing for deployments
to clustered systems a breeze. It also separates the build and deployment steps
to clearly separate pipeline tasks. 

For a complete tutorial, reference [Welcome to VagrantSpec](https://github.com/miroswan/vagrant_spec/wiki/Welcome-to-VagrantSpec)

## Installation

```vagrant plugin install vagrant_spec```

## Why not use TestKitchen or vagrant-serverspec?

* Test Kitchen is an excellent integration testing system developed by Chef.
However, it is designed to provision, test, and destroy each system one at a
time. The directory structure it expects makes sharing tests across nodes 
difficult to manage. This is undesireable for testing clustered or 
distributed systems. vagrant-serverspec has similar pitfalls. 

* vagrant_spec allows you to leverage your deployment tools just like you would
in staging and production. It generates an ansible inventory file after all
nodes are brought up. This allows you to run the same ansible_playbook commands
against the Vagrant node set as you would elsewhere. 

* routing tests to nodes is flexible and simple. 

* vagrant_spec allows you to provision your nodes with configuration management
and leverage ansible for orchestration and deployment. TestKitchen currently
does not support this scenario without much trouble. 

Here is a sample Vagrantfile:

```
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
```

## Configuration

* config.spec.directory: relative path to your serverspec test files. This 
defaults to serverspec. 

* config.spec.ansible_inventory: a hash that maps ansible groups to your nodes.
You can specify as many groups as you need. You can match nodes by regular 
expression or explicitly provide an array of node names. This will generate 
an vagrantspec_inventory based on your active nodes. You use this file for 
running ansible playbooks against your Vagrant instances. Use this configuration
directive if you use ansible for orchestration. 

* config.spec.generate_machine_data: a boolean. If true, the init sub-command
will generate a json file at .vagrantspec_machine_data containing relevant
ssh information for each of your nodes. This can be helpful when leveraging
orchestration tooling aside from ansible. You can use this data to direct your
orchestration to your local instances. The default is set to true. 

* config.spec.test_plan: an array of hashes. nodes can either be a regular 
expression object that matches your desired nodes or an explicit array of 
nodes. flags is a string that matches the desired flags you would pass to
rspec. The last argument is typically a pattern that maps to the tests you'd 
like to run. This allows you to split out what tests you'd like to run across
your cluster of nodes. 

## Sub Commands

* version: Print the current version of vagrant_spec

* init: This will generate your ansible inventory file if you've configured your
config.spec.ansible_inventory directive. Additionally, it'll generate your
.vagrantspec_machine_data file if set to enabled via 
config.spec.generate_machine_data. You'll typically want to run this after a 
vagrant up and before your deployment and testing tasks. 

* test: This will run the tests specified in your Vagrantfile. Tests are
executed against each node in your fleet and the exit code is stored if an error
occurs. All tests will run. The exit code of the last failed run will return
to the shell. Otherwise, it will return zero. 

## Sample Output

```
> vagrant spec init

> vagrant spec test

*******************************************************
***************** ServerSpec Test Run *****************
*******************************************************

[test_ansible]

Test Hostname
  hostname is test_ansible

Finished in 0.43356 seconds (files took 1.61 seconds to load)
1 example, 0 failures

[test_pansible]

Test Hostname
  hostname is test_pansible

Finished in 0.22762 seconds (files took 0.59837 seconds to load)
1 example, 0 failures

> echo $?
0
```

## Testing Resources

* [ServerSpec](http://serverspec.org/)
* [RSpec](http://rspec.info/)
* [RSpec Best Practices](http://betterspecs.org/)

## Development

* Fork the development branch
* ```pip install ansible```
* ```bundle install```
* ```bundle exec rake test```
