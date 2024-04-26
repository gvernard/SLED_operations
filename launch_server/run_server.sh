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
mode=debug
source ${root_path}/SLED_operations/launch_server/set_server.sh

# Execute server
cd ${root_path}/SLED_api
sudo -E ${mypython} manage.py runserver 216.73.242.43:8000
