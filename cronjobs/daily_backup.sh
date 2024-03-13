#!/bin/bash
# This script is run daily but AFTER the monthly backup script
MYSQLDUMP=$(which mysqldump)
AWK=$(which awk)
current_path=`pwd`
secret_path=${current_path}/../../SLED_secrets



########## SETUP TARGET DIRECTORY ##########
if [[ $# -eq 1 ]]
then
    readonly NAME=$1
else
    readonly NAME="latest"
fi
readonly BACKUP_DIR="/var/tmp/SLED_tmp_backups/"${NAME}
if [ -d $BACKUP_DIR ]
then
    echo "A directory with the name - $NAME - already exists."
    while true; do
	read -p " Proceeding will overwrite it. Are you sure you want to proceed (y/n)? " yn
	case $yn in
            [Yy]* ) mkdir -p ${BACKUP_DIR}; mkdir -p ${BACKUP_DIR}/database; mkdir -p ${BACKUP_DIR}/files; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes (y) or no (n).";;
	esac
    done
else
    mkdir ${BACKUP_DIR}
    mkdir ${BACKUP_DIR}/database
    mkdir ${BACKUP_DIR}/files
fi



########## BACKUP DATABASE ##########

# Get database connection parameters
cnf_file=${secret_path}/sled_ro.cnf
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

# Full database backup using mysqldump
$MYSQLDUMP --single-transaction -h $MHOST -P $MPORT -u $MUSER -p$MPASS $MDB > ${BACKUP_DIR}/database/strong_lenses_database.sql





########## TRANSFER TO REMOTE STORAGE ##########

# Transfer backup file to remote backup storage
conf_file=${secret_path}/rclone.conf
if ! [ -f $conf_file ]
then
    echo "File $conf_file not found!"    
    exit
fi
rclone --config="${conf_file}" sync ${BACKUP_DIR} sled_backup:${NAME}
rm -r ${BACKUP_DIR}



########## TRANSFER TO REMOTE STORAGE ##########

rclone --config="${conf_file}" sync sled_storage:static sled_backup:${NAME}/files





exit


########## BACKUP FILES ##########
# Incremental backups using rsync
set -o errexit
set -o nounset
set -o pipefail

readonly BACKUP_PATH=${BACKUP_DIR}/${TARGET}
readonly LATEST_LINK=${BACKUP_DIR}/latest

mkdir -p ${BACKUP_DIR}/${TARGET}

rsync -av --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  --exclude="temporary" \
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"
