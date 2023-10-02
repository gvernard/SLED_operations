#!/bin/bash

if [ $# != 3 ]
then
    echo "Two command line arguments are required: "
    echo "  1 - the machine where the django server will run: 'server' or 'localhost'"
    echo "  2 - the database to use: 'test' or 'production' or 'sqlite'"
    echo "  3 - the final command to run: 'migrate' or 'launch'"
    exit 0
fi
host=$1
database=$2
command=$3


# Some checks for the allowed optiions
if [ `hostname -s` != "django01" ] && ([ $host = "server" ] || [ $database = "production" ])
then
    echo "These options can be used only on django01!"
    exit 0
fi
if [ `hostname -s` = "django01" ] && ([ $host = "localhost" ] || [ $database = "sqlite" ])
then
    echo "These options cannot be used on django01!"
    exit 0
fi
if !([ $command = "launch" ] || [ $command = "migrate" ])
then
    echo "'command' (the 3rd argument) can only be 'launch' or 'migrate'!"
    exit 0
fi


sled_root=`pwd`/../..

# Export environment variables and set the settings.py file
export DJANGO_SLACK_API_TOKEN=`cat slack_api_token.txt`
if [ $host = "server" ]
then
    if [ $database = "production" ]
    then
	export DJANGO_SECRET_KEY=`cat secret_key.txt`
	export DJANGO_EMAIL_PASSWORD=`cat email_password.txt`
	export DJANGO_MEDIA_ROOT=/projects/astro/sled/FILES
	export DJANGO_STATIC_ROOT=/projects/astro/sled/STATIC
	export DJANGO_DB_FILE=production_rw.cnf
	export DJANGO_NO_LAST_LOGIN=false	
	cp settings_production.py ${sled_root}/SLED_api/mysite/settings.py
    elif [ $database = "production_ro" ]
    then
	export DJANGO_SECRET_KEY=`cat secret_key.txt`
	export DJANGO_EMAIL_PASSWORD=`cat email_password.txt`
	export DJANGO_MEDIA_ROOT=/projects/astro/sled/FILES
	export DJANGO_STATIC_ROOT=/projects/astro/sled/STATIC
	export DJANGO_DB_FILE=production_ro_server.cnf
	export DJANGO_NO_LAST_LOGIN=true
	cp settings_production.py ${sled_root}/SLED_api/mysite/settings.py
    else
	echo "Options '"${host}"' and '"${database}"' not allowed!"
	exit 0
    fi
elif [ $host = "localhost" ]
then
    if [ $database = "test" ]
    then
	export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
	export DJANGO_EMAIL_PASSWORD='ixzdsavcwdgohgrj'
	export DJANGO_MEDIA_ROOT=${sled_root}/FILES_TEST
	export DJANGO_STATIC_ROOT=${sled_root}/SLED_api/staticfiles
	export DJANGO_DB_FILE=test_localhost.cnf
	cp settings_debug.py ${sled_root}/SLED_api/mysite/settings.py
    elif [ $database = "test_production" ]
    then
	export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
	export DJANGO_EMAIL_PASSWORD='ixzdsavcwdgohgrj'
	export DJANGO_MEDIA_ROOT=${sled_root}/FILES_TEST
	export DJANGO_STATIC_ROOT=${sled_root}/SLED_api/staticfiles
	export DJANGO_DB_FILE=test_localhost.cnf
	export DJANGO_NO_LAST_LOGIN=false
	cp settings_production.py ${sled_root}/SLED_api/mysite/settings.py
    elif [ $database = "production_ro" ]
    then
	export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
	export DJANGO_EMAIL_PASSWORD='ixzdsavcwdgohgrj'
	export DJANGO_MEDIA_ROOT=${sled_root}/FILES_TEST
	export DJANGO_STATIC_ROOT=${sled_root}/SLED_api/staticfiles
	export DJANGO_DB_FILE=production_ro_localhost.cnf
	export DJANGO_NO_LAST_LOGIN=true
	cp settings_production.py ${sled_root}/SLED_api/mysite/settings.py	
    elif [ $database = "sqlite" ]
    then
	cp settings_localhost_sqlite.py ${sled_root}/SLED_api/mysite/settings.py
    else
	echo "Options '"${host}"' and '"${database}"' not allowed!"
	exit 0
    fi
fi


    
# Open SSH tunnel if necessary
if [ `hostname -s` != "django01" ] && ([ $database = "test" ] || [ $database = "test_production" ] || [ $database = "production_ro" ])
then
    pkill -f 'ssh -f gvernard@login01.astro.unige.ch -L 8888:mysql10.astro.unige.ch:4006 -N'
    echo "Creating SSH tunnel to the mysql server..."
    ssh -f gvernard@login01.astro.unige.ch -L 8888:mysql10.astro.unige.ch:4006 -N
    echo "Creating SSH tunnel to the mysql server...DONE"
fi



# Activate SLED environment
eval "$(conda shell.bash hook)"
if [ `hostname -s` = "django01" ]
then
    conda activate /projects/astro/sled/SLED_environment
else
    conda activate SLED_environment
fi



# Start the django server
cd ${sled_root}/SLED_api
if [ $command = "launch" ]
then
    if [ `hostname -s` = "django01" ]
    then
	if [ $database = "production" ] || [ $database = "production_ro" ]
	then
	    python manage.py collectstatic --noinput
	    python manage.py runserver 10.194.66.167:8806
	else
	    python manage.py runserver 10.194.66.167:8808
	fi
    else
	python manage.py runserver
    fi
else
    python manage.py makemigrations
    python manage.py migrate
fi


