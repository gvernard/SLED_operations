import os
from mysite.settings_common import *

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

DEBUG = True

EMAIL_HOST_PASSWORD = os.environ['DJANGO_EMAIL_PASSWORD']

ALLOWED_HOSTS = ['127.0.0.1','127.0.1.1','localhost','django01.obs.unige.ch','10.194.66.167']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {
            'read_default_file': os.environ['DJANGO_DB_FILE'],
        }
    }
}

STATIC_URL = 'static/'
MEDIA_ROOT = os.environ['DJANGO_MEDIA_ROOT']
STATIC_ROOT = os.environ['DJANGO_STATIC_ROOT']
