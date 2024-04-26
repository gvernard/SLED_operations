#!/bin/bash

secret_path=/home/gvernardos/SLED/SLED_secrets
site_path=/home/gvernardos/SLED
mypython=/usr/local/bin/python3.12

bash create_env.sh ${secret_path} migrate
cp sled-envvars.py ${site_path}/SLED_api/mysite/
source sled-envvars.env

cd ${site_path}/SLED_api
sudo -E ${mypython} manage.py runserver 216.73.242.43:8000
