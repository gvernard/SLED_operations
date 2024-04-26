#!/bin/bash

root_path=/home/gvernardos/SLED
site_path=/home/gvernardos/SLED

bash create_env.sh ${root_path} migrate
cp sled-envvars.py ${site_path}/SLED_api/mysite/
cp settings_debug.py ${site_path}/SLED_api/mysite/settings.py

cd ${site_path}/SLED_api
sudo -E ${mypython} manage.py runserver 216.73.242.43:8000
