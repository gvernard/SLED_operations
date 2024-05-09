#!/bin/bash

secret_path=/etc/sled/SLED_secrets
site_path=/var/www/sled/
bash create_env.sh ${secret_path} production
cp sled-envvars.env ${site_path}/envvars
cp settings_production.py ${site_path}/SLED/SLED_api/mysite/settings.py
