#!/bin/bash

# variables 'mode' and 'root_path' need to be set
secret_path=${root_path}/SLED_secrets
current_path=${root_path}/SLED_operations/launch_server

# Export environment variables and set the settings.py file
export DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
export DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
if [ $mode = "debug" ]
then
    export DJANGO_DB_FILE=${secret_path}/sled_rw.cnf
else
    export DJANGO_DB_FILE=${secret_path}/sled_root.cnf
fi
export DJANGO_SECRET_KEY='django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'
export S3_ACCESS_KEY_ID=`grep -o 'Access.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
export S3_SECRET_ACCESS_KEY=`grep -o 'Secret.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
export S3_STORAGE_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
export S3_ENDPOINT_URL=`grep -o 'Endpoint.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
export DJANGO_NO_LAST_LOGIN=false
cp ${current_path}/settings_debug.py ${root_path}/SLED_api/mysite/settings.py
