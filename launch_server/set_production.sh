#!/bin/bash

secret_path=/home/gvernardos/SLED/SLED_secrets
site_path=/var/www/sled/SLED
bash create_env.sh ${secret_path} production
cp sled-envvars.py ${site_path}/SLED_api/mysite/
cp settings_production.py ${site_path}/SLED_api/mysite/settings.py
