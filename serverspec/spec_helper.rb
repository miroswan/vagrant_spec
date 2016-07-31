# encoding: UTF-8

require 'serverspec'
require 'net/ssh'
require 'rspec'

###################
# Serverspec Config

set :backend, :ssh

host               = ENV['VAGRANT_HOST']
options            = Net::SSH::Config.for(host)
options[:user]     = ENV['VAGRANT_USER']
options[:keys]     = ENV['VAGRANT_KEY']
options[:port]     = ENV['VAGRANT_PORT']

set :host,        host
set :ssh_options, options
