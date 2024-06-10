cd /var/www/sled/SLED_api/
git pull
cp mysite/settings_production.py mysite/settings.py
source /var/www/sled/venv/bin/activate
python manage.py makemigrations --noinput
python manage.py migrate --noinput
python manage.py collectstatic --noinput
sudo systemctl restart uwsgi

