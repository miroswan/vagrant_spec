#!/usr/bin/env bash

# This is purely for convenience. This has to be watched to verify that the
# plugin works in a live environment. Better testing to come...

set -e

rm -f serverspec/spec_helper.rb
bundle exec vagrant up
bundle exec vagrant spec init
bundle exec vagrant spec test || true
bundle exec vagrant destroy -f 
