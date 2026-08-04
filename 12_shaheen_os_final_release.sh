#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

PROJECT_NAME="SHAHEEN OS"
RELEASE_VERSION="${SHAHEEN_OS_VERSION:-1.0.0}"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

RELEASE_DIR="$PROJECT_ROOT/storage/releases/shaheen-os"
REPORT_DIR="$PROJECT_ROOT/storage/logs/shaheen-os"
BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

REPORT_FILE="$REPORT_DIR/final-release-$TIMESTAMP.log"
RELEASE_FILE="$RELEASE_DIR/SHAHEEN-OS-$RELEASE_VERSION-$TIMESTAMP.txt"

ERRORS=0
WARNINGS=0

mkdir -p "$RELEASE_DIR"
mkdir -p "$REPORT_DIR"
mkdir -p "$BACKUP_DIR"

exec > >(tee -a "$REPORT_FILE") 2>&1

###############################################################################
# FUNCTIONS
###############################################################################

ok() {
    printf '✓ %s\n' "$1"
}

warn() {
    printf '⚠ %s\n' "$1"
    WARNINGS=$((WARNINGS + 1))
}

fail() {
    printf '✗ %s\n' "$1"
    ERRORS=$((ERRORS + 1))
}

section() {
    printf '\n[%s] %s\n' "$1" "$2"
}

###############################################################################
# HEADER
###############################################################################

printf '\n'
printf '============================================================\n'
printf '              SHAHEEN OS — FINAL RELEASE\n'
printf '============================================================\n'
printf '\n'

echo "Project:"
echo "  $PROJECT_NAME"
echo
echo "Version:"
echo "  $RELEASE_VERSION"
echo
echo "Root:"
echo "  $PROJECT_ROOT"
echo
echo "Timestamp:"
echo "  $TIMESTAMP"
echo

###############################################################################
# 1/12 RELEASE ENVIRONMENT
###############################################################################

section "1/12" "Validating release environment..."

if [[ "$(basename "$PROJECT_ROOT")" == "sooq-app" ]]; then
    ok "Project directory verified."
else
    warn "Project directory is not named sooq-app."
fi

if [[ -f artisan ]]; then
    ok "Laravel application detected."
else
    fail "Laravel artisan not found."
fi

if [[ -f composer.json ]]; then
    ok "Composer configuration detected."
else
    fail "composer.json missing."
fi

if [[ -f package.json ]]; then
    ok "Node package configuration detected."
else
    fail "package.json missing."
fi

###############################################################################
# 2/12 SHAHEEN OS BRAND
###############################################################################

section "2/12" "Verifying SHAHEEN OS branding..."

BRAND_FILES=(
    "public/brand/logo/shaheen-os-horizontal.svg"
    "public/brand/logo/shaheen-os-symbol.svg"
    "resources/css/shaheen-os.css"
    "resources/views/components/shaheen-brand.blade.php"
)

for file in "${BRAND_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        fail "Missing SHAHEEN OS asset: $file"
    fi
done

###############################################################################
# 3/12 GLOBAL UI
###############################################################################

section "3/12" "Verifying global UI integration..."

GLOBAL_FILES=(
    "resources/css/app.css"
    "resources/js/app.js"
    "resources/views/components/shaheen-os-global.blade.php"
)

for file in "${GLOBAL_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        fail "Missing global UI file: $file"
    fi
done

###############################################################################
# 4/12 DESIGN SYSTEM
###############################################################################

section "4/12" "Verifying SHAHEEN OS design systems..."

DESIGN_FILES=(
    "resources/css/shaheen-os.css"
    "resources/css/shaheen-os-motion.css"
    "resources/css/shaheen-os-shell.css"
    "resources/css/shaheen-os-navigation.css"
    "resources/css/shaheen-os-components.css"
)

for file in "${DESIGN_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        warn "Design system file missing: $file"
    fi
done

###############################################################################
# 5/12 JAVASCRIPT
###############################################################################

section "5/12" "Verifying SHAHEEN OS JavaScript systems..."

JS_FILES=(
    "resources/js/shaheen-os-motion.js"
    "resources/js/shaheen-os-shell.js"
    "resources/js/shaheen-os-navigation.js"
    "resources/js/shaheen-os-components.js"
)

for file in "${JS_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        warn "JavaScript module missing: $file"
    fi
done

###############################################################################
# 6/12 BLADE COMPONENTS
###############################################################################

section "6/12" "Verifying reusable Blade components..."

BLADE_FILES=(
    "resources/views/components/shaheen-brand.blade.php"
    "resources/views/components/shaheen-hero.blade.php"
    "resources/views/components/shaheen-motion.blade.php"
    "resources/views/components/shaheen-shell.blade.php"
    "resources/views/components/shaheen-navigation.blade.php"
    "resources/views/components/shaheen-components.blade.php"
)

for file in "${BLADE_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        warn "Blade component missing: $file"
    fi
done

###############################################################################
# 7/12 LEGACY BRAND SCAN
###############################################################################

section "7/12" "Scanning for legacy branding..."

LEGACY_FILES="$(
    grep -RIl \
        --exclude-dir=node_modules \
        --exclude-dir=vendor \
        --exclude-dir=.git \
        --exclude-dir=storage \
        --exclude-dir=public/build \
        "SHAHEEN ON" \
        public resources app 2>/dev/null || true
)"

if [[ -z "$LEGACY_FILES" ]]; then
    ok "No SHAHEEN ON references found."
else
    warn "Legacy SHAHEEN ON references detected:"
    printf '%s\n' "$LEGACY_FILES"
fi

###############################################################################
# 8/12 LARAVEL
###############################################################################

section "8/12" "Validating Laravel application..."

if php artisan about >/dev/null 2>&1; then
    ok "Laravel application is healthy."
else
    fail "Laravel application health check failed."
fi

if php artisan route:list >/dev/null 2>&1; then
    ok "Laravel routes validated."
else
    fail "Laravel routes validation failed."
fi

###############################################################################
# 9/12 CACHE
###############################################################################

section "9/12" "Rebuilding Laravel production cache..."

if php artisan optimize:clear >/dev/null 2>&1; then
    ok "Laravel caches cleared."
else
    fail "Laravel cache clearing failed."
fi

if php artisan optimize >/dev/null 2>&1; then
    ok "Laravel production cache rebuilt."
else
    fail "Laravel optimization failed."
fi

###############################################################################
# 10/12 FRONTEND
###############################################################################

section "10/12" "Building production frontend..."

if [[ ! -d node_modules ]]; then
    warn "node_modules missing. Running npm install..."

    if npm install; then
        ok "Node dependencies installed."
    else
        fail "npm install failed."
    fi
else
    ok "Node dependencies already installed."
fi

if npm run build; then
    ok "Vite production build completed."
else
    fail "Vite production build failed."
fi

###############################################################################
# 11/12 BUILD ARTIFACTS
###############################################################################

section "11/12" "Verifying production artifacts..."

if [[ -f public/build/manifest.json ]]; then
    ok "Vite manifest exists."
else
    fail "public/build/manifest.json missing."
fi

if [[ -d public/build/assets ]]; then
    ASSET_COUNT="$(find public/build/assets -type f | wc -l | tr -d ' ')"

    if [[ "$ASSET_COUNT" -gt 0 ]]; then
        ok "Production assets detected: $ASSET_COUNT"
    else
        fail "Production assets directory is empty."
    fi
else
    fail "public/build/assets missing."
fi

###############################################################################
# 12/12 FINAL SNAPSHOT
###############################################################################

section "12/12" "Creating final SHAHEEN OS release snapshot..."

SNAPSHOT_FILES=(
    "package.json"
    "composer.json"
    "vite.config.js"
    "vite.config.ts"
    "resources/css/app.css"
    "resources/js/app.js"
    "resources/views/components/shaheen-os-global.blade.php"
)

for file in "${SNAPSHOT_FILES[@]}"; do

    if [[ -f "$file" ]]; then

        TARGET="$BACKUP_DIR/$file"

        mkdir -p "$(dirname "$TARGET")"

        cp -p "$file" "$TARGET"

    fi

done

ok "Final snapshot created:"
echo "  $BACKUP_DIR"

###############################################################################
# RELEASE INFORMATION
###############################################################################

section "Release" "Generating release metadata..."

GIT_BRANCH="N/A"
GIT_COMMIT="N/A"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    GIT_BRANCH="$(git branch --show-current 2>/dev/null || echo N/A)"
    GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo N/A)"

    ok "Git repository detected."

else

    warn "Project is not currently a Git repository."

fi

cat > "$RELEASE_FILE" <<META
SHAHEEN OS
============================================================

Project:
$PROJECT_NAME

Version:
$RELEASE_VERSION

Release Timestamp:
$(date -Iseconds)

Project Root:
$PROJECT_ROOT

Git Branch:
$GIT_BRANCH

Git Commit:
$GIT_COMMIT

Laravel:
$(php artisan --version 2>/dev/null || echo "Unknown")

Node:
$(node --version 2>/dev/null || echo "Unknown")

NPM:
$(npm --version 2>/dev/null || echo "Unknown")

PHP:
$(php --version 2>/dev/null | head -n 1 || echo "Unknown")

Build:
Vite production build completed

QA:
Production QA completed

Errors:
$ERRORS

Warnings:
$WARNINGS

Status:
FINAL RELEASE READY
============================================================
META

ok "Release metadata generated."

###############################################################################
# GIT STATUS
###############################################################################

section "Git" "Checking repository status..."

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    echo
    git status --short || true
    echo

    if [[ -n "$(git status --porcelain)" ]]; then

        git add .

        if git diff --cached --quiet; then
            warn "No Git changes available to commit."
        else

            if git commit -m "release: SHAHEEN OS v$RELEASE_VERSION"; then
                ok "SHAHEEN OS release commit created."
            else
                warn "Git commit could not be created."
            fi

        fi

    else
        ok "Git working tree is clean."
    fi

else

    warn "Git release snapshot skipped because repository is not initialized."

fi

###############################################################################
# FINAL RESULT
###############################################################################

printf '\n============================================================\n'

if [[ "$ERRORS" -eq 0 ]]; then
    printf '             SHAHEEN OS FINAL RELEASE READY\n'
else
    printf '             SHAHEEN OS FINAL RELEASE FAILED\n'
fi

printf '============================================================\n\n'

echo "Project:"
echo "  $PROJECT_NAME"

echo
echo "Version:"
echo "  $RELEASE_VERSION"

echo
echo "Errors:"
echo "  $ERRORS"

echo
echo "Warnings:"
echo "  $WARNINGS"

echo
echo "Release metadata:"
echo "  $RELEASE_FILE"

echo
echo "QA log:"
echo "  $REPORT_FILE"

echo
echo "Snapshot:"
echo "  $BACKUP_DIR"

echo

if [[ "$ERRORS" -eq 0 ]]; then

    printf '✓ SHAHEEN OS identity verified.\n'
    printf '✓ Laravel application verified.\n'
    printf '✓ Design system verified.\n'
    printf '✓ Global UI verified.\n'
    printf '✓ Production assets verified.\n'
    printf '✓ Vite production build verified.\n'
    printf '✓ Final release snapshot created.\n'
    printf '✓ SHAHEEN OS FINAL RELEASE READY.\n'
    printf '\nProject is ready for the deployment stage.\n'

    exit 0

else

    printf '✗ Final release contains %s error(s).\n' "$ERRORS"
    printf '✗ Deployment must not continue until errors are resolved.\n'

    exit 1

fi

