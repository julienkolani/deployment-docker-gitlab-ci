#!/bin/sh

set -ex

WAITLOOPS=5
SLEEPSEC=1

export HOME=$PWD

# Chemin vers l'environnement virtuel
VENV_DIR="/home/app/venv"

# Chemin vers le gestionnaire Django
DJANGO_CMD="$VENV_DIR/bin/python3 /home/app/application_api/manage.py"

ls /home/app/application_api/

ls /home/app/venv/bin/python3

# Activation de l'environnement virtuel en utilisant le point (.)
. "$VENV_DIR/bin/activate"

# Exécuter les commandes Django
$DJANGO_CMD check --deploy
$DJANGO_CMD collectstatic --noinput
$DJANGO_CMD migrate
$DJANGO_CMD makemigrations

if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_MAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ] ; then
    if echo "from django.contrib.auth.models import User; User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_MAIL', '$DJANGO_SUPERUSER_PASSWORD')" | $DJANGO_CMD shell; then
        echo "Superuser created successfully."
    else
        echo "Error creating superuser."
    fi
fi

chown unit:unit -R $PWD

# Désactivation de l'environnement virtuel

unitd --control unix:/var/run/control.unit.sock ;
curl -X PUT --data-binary @/home/app/application_api/configurations/unit.config --unix-socket /run/control.unit.sock http://localhost/config

echo "$0: Stopping Unit daemon after initial configuration..."
kill -TERM $(/bin/cat /var/run/unit.pid)
for i in $(/usr/bin/seq $WAITLOOPS); do
    if [ -S /var/run/control.unit.sock ]; then
        echo "$0: Waiting for control socket to be removed..."
            /bin/sleep $SLEEPSEC
    else
        break
    fi
done
if [ -S /var/run/control.unit.sock ]; then
    kill -KILL $(/bin/cat /var/run/unit.pid)
    rm -f /var/run/control.unit.sock
fi

echo
echo "$0: Unit initial configuration complete; ready for start up..."
echo

deactivate

cron

exec "$@"