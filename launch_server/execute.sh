#!/bin/bash

if [ $# != 2 ]
then
    echo "Two command line arguments are required: "
    echo "  1 - the mode of the django server: 'production' or 'debug' or 'production_ro'"
    echo "  2 - the final command to run: 'migrate' or 'launch'"
    exit 0
fi
mode=$1
command=$2


# Some checks for the allowed optiions
if !([ $command = "launch" ] || [ $command = "migrate" ])
then
    echo "'command' (the 3rd argument) can only be 'launch' or 'migrate'!"
    exit 0
fi


root_path=`pwd`/../..
secret_path=`pwd`/../../SLED_secrets



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



# Start the django server
cd ${root_path}/SLED_api
if [ $command = "launch" ]
then
    sudo python3 manage.py collectstatic --noinput
    sudo python3 manage.py runserver 10.194.66.167:8806
else
    sudo python3 manage.py makemigrations
    sudo python3 manage.py migrate
fi


