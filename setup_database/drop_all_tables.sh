#!/bin/bash


# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)
current_path=`pwd`
secret_path=${current_path}/../../SLED_secrets
if ! [ -d ${secret_path} ]
then
    echo "Directory ${secret_path} not found!"
    exit
fi


# Get database connection parameters
cnf_file=${secret_path}/sled_root.cnf
if ! [ -f $cnf_file ]
then
    echo "File $cnf_file not found!"    
    exit
fi
MHOST=$($AWK '/^host/{print $3}' $cnf_file)
MPORT=$($AWK '/^port/{print $3}' $cnf_file)
MDB=$($AWK '/^database/{print $3}' $cnf_file)
MUSER=$($AWK '/^user/{print $3}' $cnf_file)
MPASS=$($AWK '/^password/{print $3}' $cnf_file)


# Delete all tables
TABLES=$($MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )
for t in $TABLES
do
    echo "Deleting table: $t"
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "SET FOREIGN_KEY_CHECKS=0; DROP TABLE $t;" # The FOREIGN_KEY_CHECKS applies per connection.
done

