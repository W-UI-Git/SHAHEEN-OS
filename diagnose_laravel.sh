#!/usr/bin/env bash
set -Eeuo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"

echo "=============================================="
echo " SOOQMARKET - Laravel Diagnostic & Repair"
echo "=============================================="

echo
echo "[1/9] PHP"
php -v | head -n 3

echo
echo "[2/9] Laravel"
php artisan --version || true

echo
echo "[3/9] Checking environment"
if [[ ! -f .env ]]; then
    echo "ERROR: .env is missing"
    exit 1
fi

echo
echo "[4/9] Clearing Laravel caches"
php artisan optimize:clear

echo
echo "[5/9] Rebuilding Composer autoload"
composer dump-autoload --optimize

echo
echo "[6/9] Checking storage/bootstrap permissions"
mkdir -p storage/framework/cache \
         storage/framework/sessions \
         storage/framework/views \
         storage/logs \
         bootstrap/cache

chmod -R ug+rwX storage bootstrap/cache 2>/dev/null || true

echo
echo "[7/9] Checking Laravel"
php artisan about || true

echo
echo "[8/9] Creating a fresh test request"

LOG="storage/logs/laravel.log"

BEFORE_LINES=0
if [[ -f "$LOG" ]]; then
    BEFORE_LINES=$(wc -l < "$LOG")
fi

echo "Requesting http://127.0.0.1:8080/ ..."

HTTP_CODE="$(curl -sS \
    -o /tmp/sooq_response.html \
    -w '%{http_code}' \
    --max-time 15 \
    http://127.0.0.1:8080/ || true)"

echo "HTTP STATUS: $HTTP_CODE"

echo
echo "[9/9] Extracting the REAL exception"

if [[ -f "$LOG" ]]; then

    echo
    echo "----- LAST ERROR BLOCK -----"

    tail -n 350 "$LOG" | \
    grep -nE \
    "ERROR|CRITICAL|Exception|ErrorException|FatalError|ParseError|TypeError|SQLSTATE|ViewException|Livewire|Blade|Undefined|not found|failed" \
    | tail -n 80 || true

    echo
    echo "----- LAST 120 LOG LINES -----"
    tail -n 120 "$LOG"

else
    echo "Laravel log was not found:"
    echo "$LOG"
fi

echo
echo "=============================================="
echo " DIAGNOSTIC COMPLETE"
echo "=============================================="
echo
echo "HTTP STATUS: $HTTP_CODE"
echo
echo "Response saved to:"
echo "/tmp/sooq_response.html"
echo
echo "Laravel log:"
echo "$APP_DIR/storage/logs/laravel.log"
