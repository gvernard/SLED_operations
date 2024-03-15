#!/bin/bash


current_path=`pwd`
secret_path=${current_path}/../../SLED_secrets
if ! [ -d ${secret_path} ]
then
    echo "Directory ${secret_path} not found!"
    exit
fi


conf_file=${secret_path}/rclone.conf
if ! [ -f $conf_file ]
then
    echo "File $conf_file not found!"    
    exit
fi


echo "DANGER!!! This will wipe-out the production storage/static files."
while true; do
    read -p " Are you DEFINITELY sure you want to proceed (y/n)? " yn
    case $yn in
        [Yy]* ) rclone --config="${conf_file}" delete sled_storage:/stronglens01/files --rmdirs; break;;
        [Nn]* ) exit 1;;
        * ) echo "Please answer yes (y) or no (n).";;
    esac
done
exit 0

