#!/usr/bin/env bash

set -Eeuo pipefail

cd "$(dirname "$0")"

echo "Starting SHAHEEN OS..."

php artisan config:clear
php artisan route:clear
php artisan view:clear

php artisan config:cache
php artisan route:cache
php artisan view:cache

php artisan migrate --force

if [ ! -L public/storage ]; then
    php artisan storage:link --force || true
fi

PORT="${PORT:-8080}"

echo "SHAHEEN OS listening on port $PORT"

php artisan serve \
    --host=0.0.0.0 \
    --port="$PORT"
