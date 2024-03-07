#!/bin/bash

if [ $# != 2 ]
then
    echo "Two command line arguments are required: "
    echo "  1 - the mode of the django server: 'production' or 'debug' or 'production_ro'"
    echo "  2 - the full path to the SLED project directory, i.e. the directory containing SLED_api"
    exit 0
fi
mode=$1
root_path=$2


sudo ${root_path}/SLED_operations/launch/set_server.sh $mode $root_path
cd ${root_path}/SLED_api
sudo -E python3 manage.py collectstatic --noinput
sudo -E python3 manage.py runserver 216.73.242.43:8000


