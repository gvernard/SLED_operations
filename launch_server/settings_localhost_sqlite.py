import os
from django.db.backends.signals import connection_created
from django.dispatch import receiver
import math
from mysite.settings_common import *

SECRET_KEY = 'django-insecure-3#$_(o_0g=w68gw@y5anq4$yb2$b!&1_@+bk%jse$*mboql#!t'

DEBUG = True

EMAIL_HOST_PASSWORD = 'ixzdsavcwdgohgrj'

ALLOWED_HOSTS = ['127.0.0.1','127.0.1.1','localhost']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

STATIC_URL = 'static/'
MEDIA_ROOT  = os.path.join(BASE_DIR,'../FILES_TEST')
STATIC_ROOT = os.path.join(BASE_DIR,'staticfiles')



### Here I load my user function to the sqlite database in every connection
def mydistance(ra1,dec1,ra2,dec2):
    """
    Same implementation as in lenses.py and distance_on_sky.sql
    """
    dec1_rad = math.radians(float(dec1))
    dec2_rad = math.radians(float(dec2))
    Ddec = abs(dec1_rad - dec2_rad);
    Dra = abs(math.radians(float(ra1)) - math.radians(float(ra2)));
    a = math.pow(math.sin(Ddec/2.0),2) + math.cos(dec1_rad)*math.cos(dec2_rad)*math.pow(math.sin(Dra/2.0),2);
    d = math.degrees( 2.0*math.atan2(math.sqrt(a),math.sqrt(1.0-a)) )
    return d*3600.0

@receiver(connection_created)
def extend_sqlite(connection = None, ** kwargs):
    if connection.vendor == "sqlite":
        connection.connection.create_function("distance_on_sky",4,mydistance)
