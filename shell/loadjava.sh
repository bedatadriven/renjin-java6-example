#!/bin/bash

echo 'Loading jar...'

rm -f /vagrant/shell/loadjava.log
rm -f /vagrant/shell/missing.jar

loadjava -force \
         -resolve \
         -genmissingjar /vagrant/shell/missing.jar \
         -fileout /vagrant/shell/loadjava.log \
         -verbose  \
         /vagrant/target/renjin-oracle11g-example-1.0-SNAPSHOT-jar-with-dependencies.jar
