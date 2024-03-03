#!/bin/bash

if [ $# != 1 ]
then
    echo "One command line arguments are required: "
    echo "  1 - the mode of the django server: 'production' or 'debug' or 'production_ro'"
    exit 0
fi
mode=$1



root_path=`pwd`/../..
secret_path=`pwd`/../../SLED_secrets



# Export environment variables and set the settings.py file
export DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
export DJANGO_DB_FILE=${secret_path}/sled_root.cnf




if [ $mode = "debug" ]
then
    export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/debug/FILES
    export DJANGO_STATIC_ROOT=/debug/STATIC
    cp settings_debug.py ${root_path}/SLED_api/mysite/settings.py
else
    export DJANGO_SECRET_KEY=`cat ${secret_path}/secret_key.txt`
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/production/FILES
    export DJANGO_STATIC_ROOT=/production/STATIC
    export DJANGO_NO_LAST_LOGIN=false	
    cp settings_production.py ${root_path}/SLED_api/mysite/settings.py
fi


cd ${root_path}/SLED_api
sudo -E python3 manage.py makemigrations
sudo -E python3 manage.py migrate
