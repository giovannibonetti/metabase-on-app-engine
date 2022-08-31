#!/bin/bash
# Load secret environment variables from Secret Manager into the current shell
# https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs#answer-20909045
export $(cat .env | xargs)

# https://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Connect to Metabase database
cloud_sql_proxy -term_timeout=30s \
  -instances="$GOOGLE_CLOUD_PROJECT:us-central1:metabase=tcp:0.0.0.0:$MB_DB_PORT" &

# Connect to production replica database
cloud_sql_proxy -term_timeout=30s \
  -instances="$GOOGLE_CLOUD_PROJECT:us-central1:production-replica=tcp:0.0.0.0:1234" &

java -jar ./metabase.jar
