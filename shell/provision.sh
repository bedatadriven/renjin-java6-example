#!/bin/bash

echo 'Import environment variables'
export ORACLE_SID=tests
export ORACLE_HOME=/home/oracledb/product/OracleHome/
export PATH=$PATH:$ORACLE_HOME/bin
export ORADATA=/home/oracledb/oradata


echo 'Setup ssh login for oracledb user'
cp -pr /home/vagrant/.ssh /home/oracledb/
chown -R oracledb:oinstall /home/oracledb/.ssh
echo "export ORACLE_HOME=/home/oracledb/product/OracleHome/" >> /home/oracledb/.bash_profile
echo "export ORACLE_SID=tests" >>  /home/oracledb/.bash_profile
echo "export PATH=\$PATH:\$ORACLE_HOME/bin" >>  /home/oracledb/.bash_profile

echo 'Create database Tests'
if [ ! -d $ORADATA/tests ] ; then
	 su -c "dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName tests -sysPassword dbpass -systemPassword dbpass -scriptDest /home/oracledb/oradata/tests -characterSet WE8ISO8859P1" -s /bin/sh oracledb
fi

echo 'Start listener'
su -c "lsnrctl start" -s /bin/sh oracledb

echo 'Startup database'
su -c "sqlplus /nolog <<EOF
	conn dbpass/sys as sysdba
	shutdown immediate;
	startup
	exit
EOF" -s /bin/sh oracledb