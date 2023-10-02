#!/bin/bash

readonly BACKUP_DIR="/mnt/data/backups/FILES"
readonly BACKUP_DATABASE_DIR="/mnt/data/backups/database"

read -p "Provide a date in YYYY-MM-DD format: "

arr=(${REPLY//"-"/ })
year=${arr[0]} 
month=${arr[1]}
day=${arr[2]}

echo $year$month$day


cur_year="$(date '+%YYYY')"
cur_month="$(date '+%0m')"
cur_day="$(date '+%0d')"

if [[ $year -eq $cur_year ]]
then
    if [[ $month -eq $cur_month ]]
    then
	if [[ $day -gt $cur_day ]]
	then
	    echo "No backup found"
	    exit 0
	else
	    bu=$day
	fi
    elif [[ $month -eq $last_month ]]
    then
	if [[ $day -ge $cur_day ]]
	then
	    bu=$day
	else
	    echo "No backup found"
	    exit 0
	fi
    else
	bu=${year}${month}${day}
    fi
else
    bu=${year}${month}${day}
fi
	 

if [ -e ${BACKUP_DIR}/${bu} && -e ${BACKUP_DATABASE_DIR}/${bu}.sql ]
then
    echo "Backup from ${year}-${month}-${day} was found."
    while true; do
	read -p "Do you wish to restore this backup? [Y/N] " yn
	case $yn in
            [Y]* ) make install; break;;
            [N]* ) exit;;
            * ) echo "Please answer yes or no.";;
	esac
    done

    if [ $yn = "Y" ]
    then
	# Restore FILES
	rm -r ../FILES/*
	rsync ${BACKUP_DIR}/${bu}/ ../FILES/

	# Restore database
	MYSQL=$(which mysql)
	AWK=$(which awk)
	cnf_file=server_root.cnf
	bash drop_all_tables.sh $cnf_file
	MHOST=$($AWK '/^host/{print $3}' $cnf_file)
	MPORT=$($AWK '/^port/{print $3}' $cnf_file)
	MDB=$($AWK '/^database/{print $3}' $cnf_file)
	MUSER=$($AWK '/^user/{print $3}' $cnf_file)
	MPASS=$($AWK '/^password/{print $3}' $cnf_file)
	$MYSQL -h $MHOST -P $MPORT -u $MUSER –p$MPASS $MDB < ${BACKUP_DATABASE_DIR}/${bu}.sql
	echo "Backup restored successfully!"
    else
	echo "Exiting"
	exit 0
    fi

else
    echo "No backup found"
fi


