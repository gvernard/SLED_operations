#!/bin/bash

if [ $# != 2 ]
then
    echo "Two command line arguments are required: "
    echo "  1 - the mode of the django server: 'production' or 'debug' or 'production_ro'"
    echo "  2 - the full path to the SLED project directory, i.e. the directory containing SLED_api"
    exit 0
fi
local_mode=$1
local_root_path=$2
secret_path=${local_root_path}/SLED_secrets


# Export environment variables and set the settings.py file
export DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
if [ $local_mode = "debug" ]
then
    export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/debug/FILES
    export DJANGO_STATIC_ROOT=/debug/STATIC
    export DJANGO_DB_FILE=${secret_path}/sled_rw.cnf
    cp settings_debug.py ${local_root_path}/SLED_api/mysite/settings.py
else
    export DJANGO_SECRET_KEY=`cat ${secret_path}/secret_key.txt`
    export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    export DJANGO_MEDIA_ROOT=/production/FILES
    export DJANGO_STATIC_ROOT=/production/STATIC
    if [ $local_mode = "production" ]
    then
	export DJANGO_DB_FILE=`pwd`/sled_rw.cnf
	export DJANGO_NO_LAST_LOGIN=false	
    elif [ $local_mode = "production_ro" ]
    then
	export DJANGO_DB_FILE=`pwd`/sled_ro.cnf
	export DJANGO_NO_LAST_LOGIN=true
    else
	echo "Unknown mode (1st argument)! It must be 'production', 'production_ro', or 'debug'"
	exit 0
    fi
    cp settings_production.py ${local_root_path}/SLED_api/mysite/settings.py
fi
