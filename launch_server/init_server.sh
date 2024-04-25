#!/bin/bash
mypython=/usr/local/bin/python3.12
cd /var/www/sled/SLED/SLED_api/
source mysite/sled-production-envvars.env
sudo -E ${mypython} manage.py collectstatic --noinput
sudo -E ${mypython} manage.py makemigrations
sudo -E ${mypython} manage.py migrate

