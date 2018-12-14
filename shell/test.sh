#!/bin/sh
set -e
sqlplus /nolog  @/vagrant/shell/test.sql

echo "Tests completed SUCCESSFULLY!"