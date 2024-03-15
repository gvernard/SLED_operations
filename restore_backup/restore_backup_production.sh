#!/bin/bash


current_path=`pwd`
secret_path=${current_path}/../../SLED_secrets



if [[ $# -eq 1 ]]
then
    readonly NAME=$1
else
    echo "You need to provide the backup name!"
    exit
fi


conf_file=${secret_path}/rclone.conf
if ! [ -f $conf_file ]
then
    echo "File $conf_file not found!"
    exit
fi
S3_BACKUP_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_backup.txt | cut -f2- -d: | tr -d ' '`



### Check if backup exists
filename=`rclone --config="${conf_file}" lsf sled_backup:${S3_BACKUP_BUCKET_NAME}/${NAME}/database/strong_lenses_database.sql`
if [ "${filename}" != "strong_lenses_database.sql" ]
then
    echo "Database backup .sql file not found!"
    exit
fi
Nobjects=`rclone --config="${conf_file}" size sled_backup:${S3_BACKUP_BUCKET_NAME}/${NAME}/files | head -1 | awk -F '[()]' '{print $2}'`
if (( Nobjects <= 0 ))
then
    echo "No backed-up files found!"
    exit
fi


### Empty remote storage
${current_path}/empty_storage.sh
if test $? != 0
then
    echo "Stopping backup restoration."
fi


### Restore files
S3_STORAGE_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
#rclone --config="${conf_file}" copy sled_backup:${S3_BACKUP_BUCKET_NAME}/${NAME}/files sled_storage:${S3_STORAGE_BUCKET_NAME}/files

### Restore database
cd ${current_path}/../setup_database
./drop_all_tables.sh
./create_db_users.sh
cd ${current_path}
MYSQL=$(which mysql)
AWK=$(which awk)
cnf_file=${secret_path}/sled_root.cnf
MHOST=$($AWK '/^host/{print $3}' $cnf_file)
MPORT=$($AWK '/^port/{print $3}' $cnf_file)
MDB=$($AWK '/^database/{print $3}' $cnf_file)
MUSER=$($AWK '/^user/{print $3}' $cnf_file)
MPASS=$($AWK '/^password/{print $3}' $cnf_file)
rclone --config="${conf_file}" cat sled_backup:${S3_BACKUP_BUCKET_NAME}/${NAME}/database/strong_lenses_database.sql | $MYSQL -h $MHOST -P $MPORT -u $MUSER –p$MPASS $MDB
