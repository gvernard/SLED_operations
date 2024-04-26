#!/bin/bash

secret_path=/home/gvernardos/SLED/SLED_secrets
site_path=/home/gvernardos/SLED

bash create_env.sh ${secret_path} migrate
cp sled-envvars.py ${site_path}/SLED_api/mysite/
cp settings_debug.py ${site_path}/SLED_api/mysite/settings.py

cd ${site_path}/SLED_api
sudo -E ${mypython} manage.py collectstatic --noinput
sudo -E ${mypython} manage.py makemigrations
sudo -E ${mypython} manage.py migrate
