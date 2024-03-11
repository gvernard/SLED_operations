#!/bin/bash

if [ $# != 2 ]
then
    echo "Two command line arguments are required: "
    echo "  1 - the mode of the django server: 'production' or 'debug' or 'production_ro'"
    echo "  2 - the full path to the SLED project directory, i.e. the directory containing SLED_api"
    exit 0
fi
mode=$1
root_path=${2%/}

if [ $mode != "migrate" ]
then
    echo "This script can run only in 'migrate' mode"
    exit
fi

# Sets environment variables and copies the correct setting.py file
source ${root_path}/SLED_operations/launch_server/set_server.sh

# Execute server
cd ${root_path}/SLED_api
sudo -E python3 manage.py makemigrations
sudo -E python3 manage.py migrate
