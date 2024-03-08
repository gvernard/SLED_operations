import os
from mysite.settings_common import *

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

DEBUG = True

EMAIL_HOST_PASSWORD = os.environ['DJANGO_EMAIL_PASSWORD']

ALLOWED_HOSTS = ['127.0.0.1','127.0.1.1','localhost','sled.amnh.org','216.73.242.43']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {
            'read_default_file': os.environ['DJANGO_DB_FILE'],
        }
    }
}



AWS_ACCESS_KEY_ID = os.environ['S3_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['S3_SECRET_ACCESS_KEY']
AWS_STORAGE_BUCKET_NAME = os.environ['S3_STORAGE_BUCKET_NAME']
AWS_S3_ENDPOINT_URL = os.environ['S3_STORAGE_BUCKET_NAME']
AWS_DEFAULT_ACL = 'public-read'
#AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'
AWS_S3_OBJECT_PARAMETERS = {'CacheControl': 'max-age=86400'}
# s3 static settings
AWS_LOCATION = 'static'
STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/{AWS_LOCATION}/'
STATICFILES_STORAGE = 'storages.backends.s3.S3Storage'


MEDIA_ROOT = os.environ['DJANGO_MEDIA_ROOT']
#STATIC_URL = 'static/'
#STATIC_ROOT = os.environ['DJANGO_STATIC_ROOT']
