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
cnf_file=${secret_path}/root.cnf
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


# Create database
$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE DATABASE IF NOT EXISTS $MDB"
#$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "SET FOREIGN_KEY_CHECKS = 1;"
$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "ALTER DATABASE $MDB CHARACTER SET utf8 COLLATE utf8_bin;"
$MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB < function_distance_on_sky.sql


# Create SLED_ROOT user (can create, alter, delete tables)
cnf_file=${secret_path}/sled_root.cnf
if [ -f $cnf_file ]
then
    USER=$($AWK '/^user/{print $3}' $cnf_file)
    PASS=$($AWK '/^password/{print $3}' $cnf_file)
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE USER IF NOT EXISTS '$USER'@'localhost' IDENTIFIED BY '$PASS'";
    status1=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON ${MDB}.* TO '$USER'@'localhost';"
    status3=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "GRANT EXECUTE ON FUNCTION ${MDB}.distance_on_sky TO '$USER'@'localhost';"
    status2=$?
    if [ $status1 -eq 0 ] && [ $status2 -eq 0 ] && [ $status3 -eq 0 ]
    then
	echo "MySQL user $USER created successfully."
    else
	echo "Something went wrong whn creating $USER"
    fi
else
    echo "File $cnf_file not found!"    
fi


# Create SLED_RW user (read and write)
cnf_file=${secret_path}/sled_rw.cnf
if [ -f $cnf_file ]
then
    USER=$($AWK '/^user/{print $3}' $cnf_file)
    PASS=$($AWK '/^password/{print $3}' $cnf_file)
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE USER IF NOT EXISTS '$USER'@'localhost' IDENTIFIED BY '$PASS'";
    status1=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "GRANT SELECT,INSERT,UPDATE,DELETE ON $MDB.* TO '$USER'@'localhost';"
    status2=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "GRANT EXECUTE ON FUNCTION ${MDB}.distance_on_sky TO '$USER'@'localhost';"
    status3=$?
    if [ $status1 -eq 0 ] && [ $status2 -eq 0 ] && [ $status3 -eq 0 ]
    then
	echo "MySQL user $USER created successfully."
    else
	echo "Something went wrong whn creating $USER"
    fi
else
    echo "File $cnf_file not found!"    
fi


# Create SLED_RO user (read only)
cnf_file=${secret_path}/sled_ro.cnf
if [ -f $cnf_file ]
then
    USER=$($AWK '/^user/{print $3}' $cnf_file)
    PASS=$($AWK '/^password/{print $3}' $cnf_file)
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "CREATE USER IF NOT EXISTS '$USER'@'localhost' IDENTIFIED BY '$PASS'";
    status1=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS -e "GRANT SELECT ON $MDB.* TO '$USER'@'localhost';"
    status2=$?
    $MYSQL -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB -e "GRANT EXECUTE ON FUNCTION ${MDB}.distance_on_sky TO '$USER'@'localhost';"
    status3=$?
    if [ $status1 -eq 0 ] && [ $status2 -eq 0 ] && [ $status3 -eq 0 ]
    then
	echo "MySQL user $USER created successfully."
    else
	echo "Something went wrong whn creating $USER"
    fi
else
    echo "File $cnf_file not found!"    
fi

