#!/bin/bash

root_path=/home/gvernardos/SLED
bash create_env.sh ${root_path}
cp sled-production-envvars.py /var/www/sled/SLED/SLED_api/mysite/
cp settings_production.py /var/www/sled/SLED/SLED_api/mysite/settings.py
