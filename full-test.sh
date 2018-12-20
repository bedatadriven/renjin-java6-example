#!/bin/sh
set -e

# Build the JAR
mvn clean package

# Tear down existing VM if it exists...
vagrant destroy --force || true
vagrant up

# Load jar
vagrant ssh -c "/vagrant/shell/loadjava.sh"

# Run sql test script
vagrant ssh -c "/vagrant/shell/test.sh"

