#!/bin/bash
secret_path=$1/SLED_secrets
> sled-production-envvars.env
> sled-production-envvars.py
echo "import os" >> sled-production-envvars.py


DJANGO_SLACK_API_TOKEN=`cat ${secret_path}/slack_api_token.txt`
echo "export DJANGO_SLACK_API_TOKEN=${DJANGO_SLACK_API_TOKEN}" >> sled-production-envvars.env
echo "os.environ['DJANGO_SLACK_API_TOKEN'] = '${DJANGO_SLACK_API_TOKEN}'" >> sled-production-envvars.py

DJANGO_EMAIL_PASSWORD=`cat ${secret_path}/email_password.txt`
echo "export DJANGO_EMAIL_PASSWORD=${DJANGO_EMAIL_PASSWORD}" >> sled-production-envvars.env
echo "os.environ['DJANGO_EMAIL_PASSWORD'] = '${DJANGO_EMAIL_PASSWORD}'" >> sled-production-envvars.py

#DJANGO_DB_FILE=${secret_path}/sled_root.cnf # For migrate
DJANGO_DB_FILE=${secret_path}/sled_rw.cnf
echo "export DJANGO_DB_FILE=${DJANGO_DB_FILE}" >> sled-production-envvars.env
echo "os.environ['DJANGO_DB_FILE'] = '${DJANGO_DB_FILE}'" >> sled-production-envvars.py

DJANGO_SECRET_KEY=`cat ${secret_path}/secret_key.txt`
echo "export DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}" >> sled-production-envvars.env
echo "os.environ['DJANGO_SECRET_KEY'] = '${DJANGO_SECRET_KEY}'" >> sled-production-envvars.py

S3_ACCESS_KEY_ID=`grep -o 'Access.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
echo "export S3_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}" >> sled-production-envvars.env
echo "os.environ['S3_ACCESS_KEY_ID'] = '${S3_ACCESS_KEY_ID}'" >> sled-production-envvars.py

S3_SECRET_ACCESS_KEY=`grep -o 'Secret.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
echo "export S3_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}" >> sled-production-envvars.env
echo "os.environ['S3_SECRET_ACCESS_KEY'] = '${S3_SECRET_ACCESS_KEY}'" >> sled-production-envvars.py

S3_STORAGE_BUCKET_NAME=`grep -o 'Bucket.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
echo "export S3_STORAGE_BUCKET_NAME=${S3_STORAGE_BUCKET_NAME}" >> sled-production-envvars.env
echo "os.environ['S3_STORAGE_BUCKET_NAME'] = '${S3_STORAGE_BUCKET_NAME}'" >> sled-production-envvars.py

S3_ENDPOINT_URL=`grep -o 'Endpoint.*' ${secret_path}/s3_storage.txt | cut -f2- -d: | tr -d ' '`
echo "export S3_ENDPOINT_URL=${S3_ENDPOINT_URL}" >> sled-production-envvars.env
echo "os.environ['S3_ENDPOINT_URL'] = '${S3_ENDPOINT_URL}'" >> sled-production-envvars.py

DJANGO_NO_LAST_LOGIN=true
echo "export DJANGO_NO_LAST_LOGIN=${DJANGO_NO_LAST_LOGIN}" >> sled-production-envvars.env
echo "os.environ['DJANGO_NO_LAST_LOGIN'] = ${DJANGO_NO_LAST_LOGIN}" >> sled-production-envvars.py
