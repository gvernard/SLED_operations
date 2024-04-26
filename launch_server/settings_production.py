import os
from mysite.settings_common import *

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

DEBUG = False

SESSION_COOKIE_SECURE = True

CSRF_COOKIE_SECURE = True

ALLOWED_HOSTS = ['127.0.0.1','127.0.1.1','localhost','sled.amnh.org','216.73.242.43']

EMAIL_HOST_PASSWORD = os.environ['DJANGO_EMAIL_PASSWORD']
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = 'sleddatabase@gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_USE_SSL = False

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


# Specific for the server
FORCE_SCRIPT_NAME = '/'
STATIC_URL = 'staticfiles/'
MEDIA_ROOT = os.environ['DJANGO_MEDIA_ROOT']
STATIC_ROOT = os.environ['DJANGO_STATIC_ROOT']
