#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

PROJECT_NAME="SHAHEEN OS"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"
REPORT_DIR="$PROJECT_ROOT/storage/logs/shaheen-os"
REPORT_FILE="$REPORT_DIR/production-qa-$TIMESTAMP.log"

ERRORS=0
WARNINGS=0

mkdir -p "$BACKUP_DIR"
mkdir -p "$REPORT_DIR"

exec > >(tee -a "$REPORT_FILE") 2>&1

printf '\n============================================================\n'
printf '        SHAHEEN OS — PRODUCTION QA & INTEGRITY\n'
printf '============================================================\n\n'

echo "Project: $PROJECT_NAME"
echo "Root: $PROJECT_ROOT"
echo "Started: $(date)"
echo

###############################################################################
# HELPERS
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
# 1/12 PROJECT VALIDATION
###############################################################################

section "1/12" "Validating Laravel project..."

if [[ -f artisan ]]; then
    ok "Laravel artisan detected."
else
    fail "artisan file not found."
fi

if [[ -f composer.json ]]; then
    ok "composer.json detected."
else
    fail "composer.json not found."
fi

if [[ -f package.json ]]; then
    ok "package.json detected."
else
    fail "package.json not found."
fi

###############################################################################
# 2/12 SHAHEEN OS IDENTITY
###############################################################################

section "2/12" "Checking SHAHEEN OS identity..."

if grep -RIl --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=.git \
    "SHAHEEN OS" \
    resources public 2>/dev/null | head -20 >/dev/null; then

    ok "SHAHEEN OS identity detected in project UI."
else
    warn "SHAHEEN OS identity was not detected in expected UI locations."
fi

###############################################################################
# 3/12 BRAND ASSETS
###############################################################################

section "3/12" "Checking brand assets..."

BRAND_FILES=(
    "public/brand/logo/shaheen-os-horizontal.svg"
    "public/brand/logo/shaheen-os-symbol.svg"
)

for file in "${BRAND_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        fail "Missing brand asset: $file"
    fi
done

###############################################################################
# 4/12 DESIGN SYSTEM
###############################################################################

section "4/12" "Checking SHAHEEN OS design system..."

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
        warn "Design file missing: $file"
    fi
done

###############################################################################
# 5/12 JAVASCRIPT SYSTEM
###############################################################################

section "5/12" "Checking SHAHEEN OS JavaScript..."

JS_FILES=(
    "resources/js/app.js"
    "resources/js/shaheen-os-motion.js"
    "resources/js/shaheen-os-shell.js"
    "resources/js/shaheen-os-navigation.js"
    "resources/js/shaheen-os-components.js"
)

for file in "${JS_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        ok "$file"
    else
        warn "JavaScript file missing: $file"
    fi
done

###############################################################################
# 6/12 BLADE COMPONENTS
###############################################################################

section "6/12" "Checking Blade components..."

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
# 7/12 OLD BRAND CHECK
###############################################################################

section "7/12" "Scanning for legacy SHAHEEN ON references..."

LEGACY_COUNT="$(
    grep -RIl --exclude-dir=node_modules \
        --exclude-dir=vendor \
        --exclude-dir=.git \
        --exclude-dir=storage \
        --exclude-dir=public/build \
        "SHAHEEN ON" \
        public resources app 2>/dev/null | wc -l || true
)"

if [[ "$LEGACY_COUNT" -eq 0 ]]; then
    ok "No legacy SHAHEEN ON references found."
else
    warn "$LEGACY_COUNT files still contain SHAHEEN ON references."
fi

###############################################################################
# 8/12 ENVIRONMENT SECURITY
###############################################################################

section "8/12" "Checking environment security..."

if [[ -f .env ]]; then
    ok ".env exists."

    if git ls-files --error-unmatch .env >/dev/null 2>&1; then
        fail ".env is tracked by Git. Remove it from tracking immediately."
    else
        ok ".env is not tracked by Git."
    fi
else
    warn ".env file not found."
fi

if [[ -f .gitignore ]]; then
    if grep -qxF '.env' .gitignore; then
        ok ".env is protected by .gitignore."
    else
        warn ".env is not explicitly listed in .gitignore."
    fi
else
    warn ".gitignore not found."
fi

###############################################################################
# 9/12 LARAVEL VALIDATION
###############################################################################

section "9/12" "Running Laravel integrity checks..."

if command -v php >/dev/null 2>&1; then

    if php artisan about >/dev/null 2>&1; then
        ok "Laravel application is healthy."
    else
        fail "Laravel artisan about failed."
    fi

    if php artisan route:list >/dev/null 2>&1; then
        ok "Laravel routes are valid."
    else
        fail "Laravel route validation failed."
    fi

else
    fail "PHP executable not available."
fi

###############################################################################
# 10/12 CACHE VALIDATION
###############################################################################

section "10/12" "Rebuilding Laravel production cache..."

if php artisan optimize:clear >/dev/null 2>&1; then
    ok "Laravel caches cleared."
else
    fail "Laravel cache clear failed."
fi

if php artisan optimize >/dev/null 2>&1; then
    ok "Laravel production cache rebuilt."
else
    fail "Laravel production cache rebuild failed."
fi

###############################################################################
# 11/12 FRONTEND BUILD
###############################################################################

section "11/12" "Validating production frontend build..."

if [[ -d node_modules ]]; then
    ok "Node dependencies detected."
else
    fail "node_modules directory not found."
fi

if [[ -f package.json ]] && grep -q '"build"' package.json; then

    if npm run build; then
        ok "Vite production build completed."
    else
        fail "Vite production build failed."
    fi

else
    warn "No npm build script found."
fi

###############################################################################
# 12/12 FINAL INTEGRITY
###############################################################################

section "12/12" "Running final SHAHEEN OS integrity verification..."

if [[ -f public/build/manifest.json ]]; then
    ok "Vite manifest exists."
else
    fail "Vite manifest is missing."
fi

if [[ -f resources/css/app.css ]]; then
    ok "Application CSS exists."
else
    fail "Application CSS is missing."
fi

if [[ -f resources/js/app.js ]]; then
    ok "Application JavaScript exists."
else
    fail "Application JavaScript is missing."
fi

if [[ -f resources/views/components/shaheen-os-global.blade.php ]]; then
    ok "Global SHAHEEN OS Blade exists."
else
    warn "Global SHAHEEN OS Blade was not found."
fi

###############################################################################
# BACKUP IMPORTANT FILES
###############################################################################

section "Backup" "Creating QA snapshot..."

BACKUP_FILES=(
    "resources/css/app.css"
    "resources/js/app.js"
    "package.json"
    "composer.json"
    ".env.example"
)

for file in "${BACKUP_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp -p "$file" "$BACKUP_DIR/$file"
    fi
done

ok "QA snapshot created:"
echo "  $BACKUP_DIR"

###############################################################################
# FINAL REPORT
###############################################################################

printf '\n============================================================\n'

if [[ "$ERRORS" -eq 0 ]]; then

    printf '          SHAHEEN OS PRODUCTION QA PASSED\n'

else

    printf '          SHAHEEN OS PRODUCTION QA FAILED\n'

fi

printf '============================================================\n\n'

echo "Project:"
echo "  $PROJECT_NAME"
echo

echo "Errors:"
echo "  $ERRORS"

echo "Warnings:"
echo "  $WARNINGS"

echo

echo "QA Report:"
echo "  $REPORT_FILE"

echo

echo "Backup:"
echo "  $BACKUP_DIR"

echo

if [[ "$ERRORS" -eq 0 ]]; then
    printf '✓ SHAHEEN OS production integrity verified.\n'
    printf '✓ Laravel integrity verified.\n'
    printf '✓ Frontend build verified.\n'
    printf '✓ Brand assets verified.\n'
    printf '✓ Security checks completed.\n'
    printf '✓ QA stage completed successfully.\n'
    printf '\nNext stage can start.\n'
    exit 0
else
    printf '✗ SHAHEEN OS QA detected %s error(s).\n' "$ERRORS"
    printf '✗ Fix the errors before continuing to the next stage.\n'
    exit 1
fi

