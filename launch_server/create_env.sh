#!/bin/bash

secret_path=$1
mode=$2

> sled-envvars.env
> sled-envvars.py
echo "import os" >> sled-envvars.py

if [[ "$mode" == "production" ]]
then
    SLED_PROD='true'
    DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
    DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
    DJANGO_DB_FILE=${secret_path}/sled_rw.cnf
    DJANGO_SECRET_KEY=`cat ${secret_path}/secret_key.txt`
    S3_ACCESS_KEY_ID=`grep -o 'Access.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_SECRET_ACCESS_KEY=`grep -o 'Secret.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_STORAGE_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_ENDPOINT_URL=`grep -o 'Endpoint.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    DJANGO_NO_LAST_LOGIN='true'
elif [[ "$mode" == "migrate" ]]
then
    SLED_PROD='true'
    DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
    DJANGO_EMAIL_PASSWORD=dummy
    DJANGO_DB_FILE=${secret_path}/sled_root.cnf
    DJANGO_SECRET_KEY='django-insecure-3o0gw68gwy5anq4yb2b1bkjsemboqlt'
    S3_ACCESS_KEY_ID=`grep -o 'Access.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_SECRET_ACCESS_KEY=`grep -o 'Secret.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_STORAGE_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    S3_ENDPOINT_URL=`grep -o 'Endpoint.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
    DJANGO_NO_LAST_LOGIN='false'
else
    echo "Unknown mode"
    exit 0
fi

echo "export SLED_PROD=${SLED_PROD}" >> sled-envvars.env
echo "os.environ['SLED_PROD'] = '${SLED_PROD}'" >> sled-envvars.py

echo "export DJANGO_SLACK_API_TOKEN=${DJANGO_SLACK_API_TOKEN}" >> sled-envvars.env
echo "os.environ['DJANGO_SLACK_API_TOKEN'] = '${DJANGO_SLACK_API_TOKEN}'" >> sled-envvars.py

echo "export DJANGO_EMAIL_PASSWORD=${DJANGO_EMAIL_PASSWORD}" >> sled-envvars.env
echo "os.environ['DJANGO_EMAIL_PASSWORD'] = '${DJANGO_EMAIL_PASSWORD}'" >> sled-envvars.py

echo "export DJANGO_DB_FILE=${DJANGO_DB_FILE}" >> sled-envvars.env
echo "os.environ['DJANGO_DB_FILE'] = '${DJANGO_DB_FILE}'" >> sled-envvars.py

echo "export DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}" >> sled-envvars.env
echo "os.environ['DJANGO_SECRET_KEY'] = '${DJANGO_SECRET_KEY}'" >> sled-envvars.py

echo "export S3_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}" >> sled-envvars.env
echo "os.environ['S3_ACCESS_KEY_ID'] = '${S3_ACCESS_KEY_ID}'" >> sled-envvars.py

echo "export S3_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}" >> sled-envvars.env
echo "os.environ['S3_SECRET_ACCESS_KEY'] = '${S3_SECRET_ACCESS_KEY}'" >> sled-envvars.py

echo "export S3_STORAGE_BUCKET_NAME=${S3_STORAGE_BUCKET_NAME}" >> sled-envvars.env
echo "os.environ['S3_STORAGE_BUCKET_NAME'] = '${S3_STORAGE_BUCKET_NAME}'" >> sled-envvars.py

echo "export S3_ENDPOINT_URL=${S3_ENDPOINT_URL}" >> sled-envvars.env
echo "os.environ['S3_ENDPOINT_URL'] = '${S3_ENDPOINT_URL}'" >> sled-envvars.py

#echo "export DJANGO_NO_LAST_LOGIN=${DJANGO_NO_LAST_LOGIN}" >> sled-envvars.env
#echo "os.environ['DJANGO_NO_LAST_LOGIN'] = ${DJANGO_NO_LAST_LOGIN}" >> sled-envvars.py
