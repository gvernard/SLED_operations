#!/bin/bash

root_path=$1
mode=$2

# Sets environment variables and copies the correct setting.py file
source ${root_path}/SLED_operations/launch/set_server.sh $mode $root_path

# Execute server
cd ${root_path}/SLED_api
sudo -E python3 manage.py collectstatic --noinput
sudo -E python3 manage.py runserver 216.73.242.43:8000
