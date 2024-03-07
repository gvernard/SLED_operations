#!/bin/bash

# variables 'mode' and 'root_path' need to be set
secret_path=${root_path}/SLED_secrets

# Export environment variables and set the settings.py file
export DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
if [ $mode = "debug" ]
then
    export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/debug/FILES
    export DJANGO_STATIC_ROOT=/debug/STATIC
    export DJANGO_DB_FILE=${secret_path}/sled_rw.cnf
    cp settings_debug.py ${root_path}/SLED_api/mysite/settings.py
else
    export DJANGO_SECRET_KEY=`cat ${secret_path}/secret_key.txt`
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/production/FILES
    export DJANGO_STATIC_ROOT=/production/STATIC
    if [ $mode = "production" ]
    then
	export DJANGO_DB_FILE=`pwd`/sled_rw.cnf
	export DJANGO_NO_LAST_LOGIN=false	
    elif [ $mode = "production_ro" ]
    then
	export DJANGO_DB_FILE=`pwd`/sled_ro.cnf
	export DJANGO_NO_LAST_LOGIN=true
    else
	echo "Unknown mode (1st argument)! It must be 'production', 'production_ro', or 'debug'"
	exit 0
    fi
    cp settings_production.py ${root_path}/SLED_api/mysite/settings.py
fi
