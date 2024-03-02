#!/bin/bash

root_path=`pwd`/../.. 
cnf_file=${root_path}/SLED_secrets/root.cnf

# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

# Get database connection parameters
MHOST=$($AWK '/^host/{print $3}' $cnf_file)
MPORT=$($AWK '/^port/{print $3}' $cnf_file)
MDB=$($AWK '/^database/{print $3}' $cnf_file)
MUSER=$($AWK '/^user/{print $3}' $cnf_file)
MPASS=$($AWK '/^password/{print $3}' $cnf_file)

# Create database
$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE DATABASE $MDB"


# Create SLED_ROOT user
$cnf_file=${root_path}/SLED_secrets/sled_root.cnf
USER=$($AWK '/^user/{print $3}' $cnf_file)
PASS=$($AWK '/^password/{print $3}' $cnf_file)
$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE USER 'sled_root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASS'";
