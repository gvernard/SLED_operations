import os
from mysite.settings_common import *

SECRET_KEY = 'django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'

DEBUG = True

EMAIL_HOST_PASSWORD = 'ixzdsavcwdgohgrj'

ALLOWED_HOSTS = ['django01.obs.unige.ch','10.194.66.167','127.0.0.1','localhost']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {
            'read_default_file': os.path.join(BASE_DIR, '../launch_server/server_test.cnf'),
        }
    }
}

FORCE_SCRIPT_NAME = '/'
STATIC_URL = 'static/'
MEDIA_ROOT  = os.path.join(BASE_DIR,'../FILES_TEST')
STATIC_ROOT = os.path.join(BASE_DIR,'staticfiles')
