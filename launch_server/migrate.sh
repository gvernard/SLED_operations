#!/bin/bash

if [ $# != 1 ]
then
    echo "One command line arguments are required: "
    echo "  1 - the full path to the SLED project directory, i.e. the directory containing SLED_api"
    exit 0
fi

root_path=${1%/}
mypython=/usr/local/bin/python3.12

# Sets environment variables and copies the correct setting.py file
mode=migrate
source ${root_path}/SLED_operations/launch_server/set_server.sh

# Execute server
cd ${root_path}/SLED_api
sudo -E ${mypython} manage.py collectstatic --noinput
sudo -E ${mypython} manage.py makemigrations
sudo -E ${mypython} manage.py migrate
