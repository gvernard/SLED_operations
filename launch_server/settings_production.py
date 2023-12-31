import os
from mysite.settings_common import *

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

DEBUG = True

SESSION_COOKIE_SECURE = True

CSRF_COOKIE_SECURE = True

ALLOWED_HOSTS = ['django01.obs.unige.ch','10.194.66.167','127.0.0.1','127.0.1.1','localhost']

EMAIL_HOST_PASSWORD = os.environ['DJANGO_EMAIL_PASSWORD']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {
            'read_default_file': os.environ['DJANGO_DB_FILE'],
        }
    }
}

if os.environ['DJANGO_NO_LAST_LOGIN'] == 'true':
    NO_UPDATE_LAST_LOGIN = True
else:
    NO_UPDATE_LAST_LOGIN = False
NO_UPDATE_LAST_LOGIN = True

# Specific for the server
FORCE_SCRIPT_NAME = '/'
STATIC_URL = 'staticfiles/'
MEDIA_ROOT = os.environ['DJANGO_MEDIA_ROOT']
STATIC_ROOT = os.environ['DJANGO_STATIC_ROOT']
