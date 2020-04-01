#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

#CELERY
export CELERY_BROKER_URL="amqp://${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}@${RABBITMQ_DEFAULT_HOST}:${RABBITMQ_DEFAULT_PORT}/${RABBITMQ_DEFAULT_VHOST}"

celery_ready() {
python << END
import sys
import subprocess
from celery import Celery
print('Loading Celery...')
CELERY_COMMAND = "celery multi start w1 -A worsica_web -l info --concurrency=${CELERY_NUM_WORKERS} --max-tasks-per-child=1"
cmd = subprocess.Popen(CELERY_COMMAND, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
cmd_wait = cmd.wait()
if (cmd_wait == 0):
    print('OK: Celery is running')
else:
    print('Error: Celery stopeed working')
    sys.exit(-1)
print('Pinging the workers')
app = Celery('corsica_web', broker="${CELERY_BROKER_URL}")
conn = app.connection()
try:
    conn.ensure_connection(max_retries=3)
    conn.default_channel.queue_declare()
    print('OK: Ping successfull')
except Exception as e:
    print('Error: No response from Celery workers.')
    print(e)
    sys.exit(-1)
else:
    
sys.exit(0)
END
}
until celery_ready; do
  >&2 echo 'Waiting for Celery to become available...'
  sleep 1
done
>&2 echo 'Celery is available'



#POSTGRES
if [ -z "${POSTGRES_USER}" ]; then
    base_postgres_image_default_user='postgres'
    export POSTGRES_USER="${base_postgres_image_default_user}"
fi
export DATABASE_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"

postgres_ready() {
python << END
import sys
import psycopg2
try:
    print('Trying to connect to DB')
    psycopg2.connect(
        dbname="${POSTGRES_DB}",
        user="${POSTGRES_USER}",
        password="${POSTGRES_PASSWORD}",
        host="${POSTGRES_HOST}",
        port="${POSTGRES_PORT}",
    )
    print('OK: Connection successful')
except psycopg2.OperationalError:
    print('Error: Unable to connect to PostgreSQL')
    sys.exit(-1)
sys.exit(0)
END
}
until postgres_ready; do
  >&2 echo 'Waiting for PostgreSQL to become available...'
  sleep 1
done
>&2 echo 'PostgreSQL is available'

exec "$@"
