import os
from mysite.settings_common import *

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

DEBUG = False

SESSION_COOKIE_SECURE = True

CSRF_COOKIE_SECURE = True

ALLOWED_HOSTS = ['django01.obs.unige.ch','10.194.66.167','127.0.0.1']

EMAIL_HOST_PASSWORD = os.environ['DJANGO_EMAIL_PASSWORD']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'OPTIONS': {
            'read_default_file': os.path.join(BASE_DIR, '../launch_server/production_root.cnf'),
        }
    }
}


# Specific for the server
FORCE_SCRIPT_NAME = '/'
STATIC_URL = 'staticfiles/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
MEDIA_ROOT  = os.path.join(BASE_DIR,'../FILES')
