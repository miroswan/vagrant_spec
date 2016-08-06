#!/usr/bin/env bash

# This is purely for convenience. This has to be watched to verify that the
# plugin works in a live environment. Better testing to come...

set -e

bundle exec vagrant spec
bundle exec vagrant spec -h
bundle exec vagrant spec init -h
bundle exec vagrant spec test -h
bundle exec vagrant spec no_command -h
rm -f serverspec/spec_helper.rb
bundle exec vagrant up
bundle exec vagrant spec init
bundle exec vagrant spec test || true
bundle exec vagrant destroy -f 
