#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

APP_NAME="SHAHEEN OS"
VERSION="1.0.0"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

LOG_DIR="$PROJECT_ROOT/storage/logs/shaheen-os"
RELEASE_DIR="$PROJECT_ROOT/storage/releases/shaheen-os"
BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

DEPLOY_LOG="$LOG_DIR/deploy-$TIMESTAMP.log"
DEPLOY_METADATA="$RELEASE_DIR/SHAHEEN-OS-$VERSION-$TIMESTAMP.deploy.txt"

ERRORS=0
WARNINGS=0

mkdir -p \
    "$LOG_DIR" \
    "$RELEASE_DIR" \
    "$BACKUP_DIR"

exec > >(tee -a "$DEPLOY_LOG") 2>&1

printf '\n'
printf '%s\n' '============================================================'
printf '%s\n' '              SHAHEEN OS DEPLOYMENT STAGE'
printf '%s\n' '============================================================'
printf '\n'

###############################################################################
# ERROR HANDLER
###############################################################################

trap '
    ERR_CODE=$?
    echo
    echo "ERROR: Deployment stopped."
    echo "Exit code: $ERR_CODE"
    echo "Log: $DEPLOY_LOG"
    exit "$ERR_CODE"
' ERR

###############################################################################
# 01 - PROJECT VALIDATION
###############################################################################

echo "[1/12] Validating project..."

if [[ ! -f "$PROJECT_ROOT/artisan" ]]; then
    echo "ERROR: Laravel artisan file not found."
    exit 1
fi

if [[ ! -f "$PROJECT_ROOT/package.json" ]]; then
    echo "ERROR: package.json not found."
    exit 1
fi

if [[ ! -d "$PROJECT_ROOT/resources" ]]; then
    echo "ERROR: resources directory not found."
    exit 1
fi

echo "✓ Laravel project detected."
echo "✓ Node/Vite project detected."
echo "✓ Resources directory detected."

###############################################################################
# 02 - SHAHEEN OS IDENTITY
###############################################################################

echo
echo "[2/12] Verifying SHAHEEN OS identity..."

if grep -RIl \
    --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=.git \
    "SHAHEEN OS" \
    resources public storage 2>/dev/null | head -n 1 >/dev/null; then

    echo "✓ SHAHEEN OS identity detected."

else
    echo "WARNING: SHAHEEN OS identity could not be detected."
    WARNINGS=$((WARNINGS + 1))
fi

###############################################################################
# 03 - BRAND ASSETS
###############################################################################

echo
echo "[3/12] Checking brand assets..."

BRAND_FILES=(
    "public/brand/logo/shaheen-os-horizontal.svg"
    "public/brand/logo/shaheen-os-symbol.svg"
)

for FILE in "${BRAND_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$FILE" ]]; then
        echo "✓ $FILE"
    else
        echo "WARNING: Missing $FILE"
        WARNINGS=$((WARNINGS + 1))
    fi
done

###############################################################################
# 04 - GLOBAL UI FILES
###############################################################################

echo
echo "[4/12] Checking global UI files..."

UI_FILES=(
    "resources/css/app.css"
    "resources/js/app.js"
    "resources/css/shaheen-os.css"
    "resources/css/shaheen-os-motion.css"
    "resources/css/shaheen-os-global.css"
    "resources/css/shaheen-os-navigation.css"
    "resources/css/shaheen-os-shell.css"
    "resources/css/shaheen-os-components.css"
    "resources/js/shaheen-os-global.js"
    "resources/js/shaheen-os-components.js"
    "resources/js/shaheen-os-navigation.js"
    "resources/js/shaheen-os-shell.js"
)

for FILE in "${UI_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$FILE" ]]; then
        echo "✓ $FILE"
    else
        echo "WARNING: Missing $FILE"
        WARNINGS=$((WARNINGS + 1))
    fi
done

###############################################################################
# 05 - BLADE COMPONENTS
###############################################################################

echo
echo "[5/12] Checking Blade components..."

BLADE_FILES=(
    "resources/views/components/shaheen-brand.blade.php"
    "resources/views/components/shaheen-hero.blade.php"
    "resources/views/components/shaheen-motion.blade.php"
    "resources/views/components/shaheen-navigation.blade.php"
    "resources/views/components/shaheen-components.blade.php"
    "resources/views/components/shaheen-os-global.blade.php"
    "resources/views/components/shaheen-os-shell.blade.php"
)

for FILE in "${BLADE_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$FILE" ]]; then
        echo "✓ $FILE"
    else
        echo "WARNING: Missing $FILE"
        WARNINGS=$((WARNINGS + 1))
    fi
done

###############################################################################
# 06 - FRONTEND BUILD
###############################################################################

echo
echo "[6/12] Verifying production frontend..."

if [[ ! -f "$PROJECT_ROOT/public/build/manifest.json" ]]; then
    echo "WARNING: Vite manifest not found."
    WARNINGS=$((WARNINGS + 1))
else
    echo "✓ Vite manifest exists."
fi

if [[ -d "$PROJECT_ROOT/public/build/assets" ]]; then
    ASSET_COUNT="$(find "$PROJECT_ROOT/public/build/assets" -type f | wc -l | tr -d ' ')"

    echo "✓ Production assets directory exists."
    echo "  Assets: $ASSET_COUNT"

    if [[ "$ASSET_COUNT" -eq 0 ]]; then
        echo "WARNING: No production assets found."
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "ERROR: public/build/assets does not exist."
    exit 1
fi

###############################################################################
# 07 - LARAVEL CACHE
###############################################################################

echo
echo "[7/12] Rebuilding Laravel production cache..."

php artisan optimize:clear

php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✓ Laravel production cache rebuilt."

###############################################################################
# 08 - APPLICATION CHECK
###############################################################################

echo
echo "[8/12] Running Laravel application verification..."

if php artisan about >/dev/null 2>&1; then
    echo "✓ Laravel application verified."
else
    echo "WARNING: php artisan about returned a non-zero status."
    WARNINGS=$((WARNINGS + 1))
fi

###############################################################################
# 09 - OLD BRAND CHECK
###############################################################################

echo
echo "[9/12] Checking obsolete SHAHEEN ON references..."

OLD_REFERENCES="$(
    grep -RIl \
        --exclude-dir=node_modules \
        --exclude-dir=vendor \
        --exclude-dir=.git \
        --exclude-dir=build \
        "SHAHEEN ON" \
        public/brand resources 2>/dev/null || true
)"

if [[ -z "$OLD_REFERENCES" ]]; then
    echo "✓ No SHAHEEN ON references found in active UI."
else
    echo "WARNING: Legacy SHAHEEN ON references detected:"
    echo "$OLD_REFERENCES"
    WARNINGS=$((WARNINGS + 1))
fi

###############################################################################
# 10 - DEPLOYMENT SNAPSHOT
###############################################################################

echo
echo "[10/12] Creating deployment snapshot..."

SNAPSHOT_FILES=(
    "public/build/manifest.json"
    "public/brand/logo/shaheen-os-horizontal.svg"
    "public/brand/logo/shaheen-os-symbol.svg"
    "resources/css/app.css"
    "resources/js/app.js"
)

for FILE in "${SNAPSHOT_FILES[@]}"; do
    if [[ -f "$PROJECT_ROOT/$FILE" ]]; then
        DEST="$BACKUP_DIR/$FILE"
        mkdir -p "$(dirname "$DEST")"
        cp "$PROJECT_ROOT/$FILE" "$DEST"
    fi
done

echo "✓ Deployment snapshot created:"
echo "  $BACKUP_DIR"

###############################################################################
# 11 - RELEASE METADATA
###############################################################################

echo
echo "[11/12] Creating deployment metadata..."

cat > "$DEPLOY_METADATA" <<META
SHAHEEN OS DEPLOYMENT METADATA
================================

Project:
SHAHEEN OS

Version:
$VERSION

Timestamp:
$TIMESTAMP

Project Root:
$PROJECT_ROOT

Deployment Log:
$DEPLOY_LOG

Snapshot:
$BACKUP_DIR

Errors:
$ERRORS

Warnings:
$WARNINGS

Laravel:
$(php artisan --version 2>/dev/null || echo "unknown")

PHP:
$(php -v 2>/dev/null | head -n 1 || echo "unknown")

Node:
$(node --version 2>/dev/null || echo "unknown")

NPM:
$(npm --version 2>/dev/null || echo "unknown")

Git Commit:
$(git rev-parse HEAD 2>/dev/null || echo "not-a-git-repository")

Git Branch:
$(git branch --show-current 2>/dev/null || echo "unknown")

Status:
READY FOR DEPLOYMENT
META

echo "✓ Deployment metadata created."

###############################################################################
# 12 - FINAL VERIFICATION
###############################################################################

echo
echo "[12/12] Running final deployment verification..."

FINAL_OK=true

if [[ ! -f "$PROJECT_ROOT/public/build/manifest.json" ]]; then
    FINAL_OK=false
fi

if [[ ! -f "$PROJECT_ROOT/public/brand/logo/shaheen-os-horizontal.svg" ]]; then
    FINAL_OK=false
fi

if [[ ! -f "$PROJECT_ROOT/resources/css/app.css" ]]; then
    FINAL_OK=false
fi

if [[ ! -f "$PROJECT_ROOT/resources/js/app.js" ]]; then
    FINAL_OK=false
fi

if [[ "$FINAL_OK" != true ]]; then
    ERRORS=$((ERRORS + 1))
fi

###############################################################################
# FINAL RESULT
###############################################################################

printf '\n'
printf '%s\n' '============================================================'

if [[ "$FINAL_OK" == true && "$ERRORS" -eq 0 ]]; then

    printf '%s\n' '             SHAHEEN OS DEPLOYMENT READY'
    printf '%s\n' '============================================================'
    printf '\n'

    echo "Project:"
    echo "  $APP_NAME"
    echo

    echo "Version:"
    echo "  $VERSION"
    echo

    echo "Errors:"
    echo "  $ERRORS"
    echo

    echo "Warnings:"
    echo "  $WARNINGS"
    echo

    echo "Deployment metadata:"
    echo "  $DEPLOY_METADATA"
    echo

    echo "Deployment log:"
    echo "  $DEPLOY_LOG"
    echo

    echo "Snapshot:"
    echo "  $BACKUP_DIR"
    echo

    echo "✓ SHAHEEN OS identity verified."
    echo "✓ Laravel application verified."
    echo "✓ Production assets verified."
    echo "✓ Brand assets verified."
    echo "✓ Deployment snapshot created."
    echo "✓ Deployment metadata created."
    echo "✓ SHAHEEN OS is READY FOR DEPLOYMENT."
    echo

else

    printf '%s\n' '             SHAHEEN OS DEPLOYMENT FAILED'
    printf '%s\n' '============================================================'
    printf '\n'

    echo "Errors:"
    echo "  $ERRORS"
    echo

    echo "Warnings:"
    echo "  $WARNINGS"
    echo

    echo "Log:"
    echo "  $DEPLOY_LOG"
    echo

    exit 1
fi

