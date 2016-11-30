#!/usr/bin/env bash

# Show all command prior to executing them
set -x

# Exit if a command fails
set -e

source /etc/profile.d/rvm.sh 

export BUNDLE_APP_CONFIG=/tmp/src

cd /tmp/src

bundle install --path=/tmp/src/bundle-install

bundle exec jekyll build
