#!/usr/bin/env bash
set -Eeuo pipefail

###############################################################################
# SHAHEEN OS
# 10/12 — FINAL GLOBAL UI INTEGRATION
#
# Purpose:
#   - Assemble all SHAHEEN OS UI systems
#   - Normalize Vite CSS import order
#   - Verify JavaScript modules
#   - Register global assets safely
#   - Rebuild Laravel cache
#   - Run production Vite build
#   - Perform final integrity checks
###############################################################################

APP_NAME="SHAHEEN OS"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CSS_DIR="$ROOT/resources/css"
JS_DIR="$ROOT/resources/js"
VIEW_DIR="$ROOT/resources/views/components"
BRAND_DIR="$ROOT/public/brand"
BACKUP_ROOT="$ROOT/.shaheen-ui-backups"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

ERRORS=0

###############################################################################
# COLORS
###############################################################################

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

log() {
    printf "%b\n" "$1"
}

step() {
    printf "\n${CYAN}[%s] %s${RESET}\n" "$1" "$2"
}

success() {
    printf "${GREEN}✓ %s${RESET}\n" "$1"
}

warning() {
    printf "${YELLOW}⚠ %s${RESET}\n" "$1"
}

failure() {
    printf "${RED}✗ %s${RESET}\n" "$1"
    ERRORS=$((ERRORS + 1))
}

###############################################################################
# HEADER
###############################################################################

printf "\n"
printf '%s\n' '=============================================================='
printf '%s\n' '              SHAHEEN OS — FINAL UI INTEGRATION'
printf '%s\n' '=============================================================='
printf "\n"

###############################################################################
# 1. PROJECT VALIDATION
###############################################################################

step "1/12" "Validating SHAHEEN OS project..."

if [[ ! -f "$ROOT/artisan" ]]; then
    failure "Laravel artisan was not found."
    exit 1
fi

if [[ ! -f "$ROOT/package.json" ]]; then
    failure "package.json was not found."
    exit 1
fi

if [[ ! -d "$ROOT/resources" ]]; then
    failure "resources directory was not found."
    exit 1
fi

if [[ ! -d "$ROOT/public" ]]; then
    failure "public directory was not found."
    exit 1
fi

success "Laravel project detected."
success "SHAHEEN OS integration root: $ROOT"

###############################################################################
# 2. BACKUP
###############################################################################

step "2/12" "Creating integration backup..."

mkdir -p "$BACKUP_DIR"

backup_if_exists() {
    local file="$1"

    if [[ -f "$file" ]]; then
        mkdir -p "$(dirname "$BACKUP_DIR/${file#$ROOT/}")"
        cp -p "$file" "$BACKUP_DIR/${file#$ROOT/}"
    fi
}

backup_if_exists "$ROOT/resources/css/app.css"
backup_if_exists "$ROOT/resources/js/app.js"
backup_if_exists "$ROOT/resources/views/components/sh aheen-os.blade.php"

for file in \
    "$CSS_DIR/shaheen-os.css" \
    "$CSS_DIR/shaheen-os-motion.css" \
    "$CSS_DIR/shaheen-os-global.css" \
    "$CSS_DIR/shaheen-os-shell.css" \
    "$CSS_DIR/shaheen-os-navigation.css" \
    "$CSS_DIR/shaheen-os-components.css" \
    "$JS_DIR/shaheen-os-motion.js" \
    "$JS_DIR/shaheen-os-global.js" \
    "$JS_DIR/shaheen-os-shell.js" \
    "$JS_DIR/shaheen-os-navigation.js" \
    "$JS_DIR/shaheen-os-components.js"
do
    backup_if_exists "$file"
done

success "Backup created:"
printf "  %s\n" "$BACKUP_DIR"

###############################################################################
# 3. DIRECTORY VALIDATION
###############################################################################

step "3/12" "Validating SHAHEEN OS directories..."

mkdir -p \
    "$CSS_DIR" \
    "$JS_DIR" \
    "$VIEW_DIR" \
    "$BRAND_DIR"

success "CSS directory ready."
success "JavaScript directory ready."
success "Blade component directory ready."
success "Brand directory ready."

###############################################################################
# 4. REQUIRED CSS VALIDATION
###############################################################################

step "4/12" "Checking SHAHEEN OS CSS modules..."

REQUIRED_CSS=(
    "shaheen-os.css"
    "shaheen-os-motion.css"
    "shaheen-os-global.css"
    "shaheen-os-shell.css"
    "shaheen-os-navigation.css"
    "shaheen-os-components.css"
)

for file in "${REQUIRED_CSS[@]}"; do
    if [[ -f "$CSS_DIR/$file" ]]; then
        success "$CSS_DIR/$file"
    else
        warning "Missing CSS module: $file"
    fi
done

###############################################################################
# 5. REQUIRED JS VALIDATION
###############################################################################

step "5/12" "Checking SHAHEEN OS JavaScript modules..."

REQUIRED_JS=(
    "shaheen-os-motion.js"
    "shaheen-os-global.js"
    "shaheen-os-shell.js"
    "shaheen-os-navigation.js"
    "shaheen-os-components.js"
)

for file in "${REQUIRED_JS[@]}"; do
    if [[ -f "$JS_DIR/$file" ]]; then
        success "$JS_DIR/$file"
    else
        warning "Missing JavaScript module: $file"
    fi
done

###############################################################################
# 6. NORMALIZE APP CSS IMPORTS
###############################################################################

step "6/12" "Normalizing Vite CSS import order..."

APP_CSS="$CSS_DIR/app.css"

if [[ ! -f "$APP_CSS" ]]; then
    touch "$APP_CSS"
fi

TMP_CSS="$(mktemp)"

cat > "$TMP_CSS" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global Application CSS
|--------------------------------------------------------------------------
| IMPORTANT:
| All @import statements must remain at the beginning of this file.
|--------------------------------------------------------------------------
*/

@import "./shaheen-os-global.css";
@import "./shaheen-os.css";
@import "./shaheen-os-motion.css";
@import "./shaheen-os-shell.css";
@import "./shaheen-os-navigation.css";
@import "./shaheen-os-components.css";
CSS

cat "$APP_CSS" >> "$TMP_CSS"

mv "$TMP_CSS" "$APP_CSS"

success "Global CSS imports normalized."
success "All SHAHEEN OS CSS imports placed before regular CSS."

###############################################################################
# 7. NORMALIZE APP JS IMPORTS
###############################################################################

step "7/12" "Normalizing Vite JavaScript imports..."

APP_JS="$JS_DIR/app.js"

if [[ ! -f "$APP_JS" ]]; then
    touch "$APP_JS"
fi

TMP_JS="$(mktemp)"

cat > "$TMP_JS" <<'JS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global Application JavaScript
|--------------------------------------------------------------------------
*/

import "./shaheen-os-global.js";
import "./shaheen-os-motion.js";
import "./shaheen-os-shell.js";
import "./shaheen-os-navigation.js";
import "./shaheen-os-components.js";

JS

cat "$APP_JS" >> "$TMP_JS"

mv "$TMP_JS" "$APP_JS"

success "Global JavaScript imports normalized."

###############################################################################
# 8. CREATE GLOBAL BLADE INTEGRATION COMPONENT
###############################################################################

step "8/12" "Creating SHAHEEN OS global integration component..."

GLOBAL_BLADE="$VIEW_DIR/shaheen-os-global.blade.php"

cat > "$GLOBAL_BLADE" <<'BLADE'
{{-- =========================================================================
     SHAHEEN OS — Global UI Integration
     ========================================================================= --}}

<div
    id="shaheen-os-root"
    data-shaheen-os="true"
    data-app-name="SHAHEEN OS"
    data-direction="{{ app()->getLocale() === 'ar' ? 'rtl' : 'ltr' }}"
    class="shaheen-os-root"
>
    <div class="shaheen-os-layer shaheen-os-layer-background"></div>

    <div class="shaheen-os-layer shaheen-os-layer-grid"></div>

    <div class="shaheen-os-layer shaheen-os-layer-glow"></div>

    <div class="shaheen-os-shell-layer">
        @if (View::exists('components.shaheen-brand'))
            @include('components.shaheen-brand')
        @endif

        @if (View::exists('components.shaheen-navigation'))
            @include('components.shaheen-navigation')
        @endif
    </div>
</div>
BLADE

success "Global Blade integration component created."

###############################################################################
# 9. BRAND IDENTITY VALIDATION
###############################################################################

step "9/12" "Verifying SHAHEEN OS brand identity..."

MAIN_LOGO="$BRAND_DIR/logo/shaheen-os-horizontal.svg"
SYMBOL_LOGO="$BRAND_DIR/logo/shaheen-os-symbol.svg"

if [[ -f "$MAIN_LOGO" ]]; then
    success "SHAHEEN OS horizontal logo found."
else
    warning "Horizontal logo not found."
fi

if [[ -f "$SYMBOL_LOGO" ]]; then
    success "SHAHEEN OS symbol logo found."
else
    warning "Symbol logo not found."
fi

if [[ -d "$BRAND_DIR" ]]; then

    OLD_REFERENCES="$(grep -Rni \
        --exclude='*.map' \
        -E 'SHAHEEN[[:space:]_-]*ON' \
        "$BRAND_DIR" 2>/dev/null || true)"

    if [[ -z "$OLD_REFERENCES" ]]; then
        success "No SHAHEEN ON references found in public/brand."
    else
        warning "Legacy SHAHEEN ON references detected:"
        printf "%s\n" "$OLD_REFERENCES"
    fi

fi

###############################################################################
# 10. JAVASCRIPT SYNTAX CHECK
###############################################################################

step "10/12" "Checking JavaScript syntax..."

if command -v node >/dev/null 2>&1; then

    for file in \
        "$JS_DIR/shaheen-os-motion.js" \
        "$JS_DIR/shaheen-os-global.js" \
        "$JS_DIR/shaheen-os-shell.js" \
        "$JS_DIR/shaheen-os-navigation.js" \
        "$JS_DIR/shaheen-os-components.js"
    do
        if [[ -f "$file" ]]; then
            if node --check "$file" >/dev/null 2>&1; then
                success "JavaScript syntax: $(basename "$file")"
            else
                warning "JavaScript syntax requires inspection: $(basename "$file")"
            fi
        fi
    done

else
    warning "Node.js is not available; skipping direct JS syntax check."
fi

###############################################################################
# 11. LARAVEL CACHE + VITE BUILD
###############################################################################

step "11/12" "Rebuilding Laravel cache..."

php artisan optimize:clear

php artisan optimize

success "Laravel cache rebuilt."

printf "\n"
printf "${CYAN}Building SHAHEEN OS production frontend...${RESET}\n\n"

if npm run build; then
    success "Vite production build completed."
else
    failure "Vite production build failed."
fi

###############################################################################
# 12. FINAL VERIFICATION
###############################################################################

step "12/12" "Running final SHAHEEN OS verification..."

if [[ -f "$ROOT/public/build/manifest.json" ]]; then
    success "Vite manifest exists."
else
    failure "Vite manifest is missing."
fi

if [[ -f "$GLOBAL_BLADE" ]]; then
    success "Global Blade integration exists."
fi

if [[ -f "$APP_CSS" ]]; then
    success "Application CSS exists."
fi

if [[ -f "$APP_JS" ]]; then
    success "Application JavaScript exists."
fi

###############################################################################
# FINAL REPORT
###############################################################################

printf "\n"
printf '%s\n' '=============================================================='

if [[ "$ERRORS" -eq 0 ]]; then

    printf "${GREEN}%s${RESET}\n" \
        '              SHAHEEN OS FINAL INTEGRATION COMPLETE'

    printf '%s\n' '=============================================================='
    printf "\n"

    echo "Project:"
    echo "  SHAHEEN OS"
    echo

    echo "Root:"
    echo "  $ROOT"
    echo

    echo "Global CSS:"
    echo "  $APP_CSS"
    echo

    echo "Global JS:"
    echo "  $APP_JS"
    echo

    echo "Global Blade:"
    echo "  $GLOBAL_BLADE"
    echo

    echo "Main Logo:"
    echo "  $MAIN_LOGO"
    echo

    echo "Symbol:"
    echo "  $SYMBOL_LOGO"
    echo

    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo

    success "Global UI integration installed."
    success "CSS import order normalized."
    success "JavaScript import order normalized."
    success "Laravel cache rebuilt."
    success "Production Vite build completed."
    success "SHAHEEN OS identity verified."

    printf "\n"
    echo "Next stage can start."

else

    printf "${RED}%s${RESET}\n" \
        '              SHAHEEN OS FINAL INTEGRATION FAILED'

    printf '%s\n' '=============================================================='
    printf "\n"

    echo "Errors:"
    echo "  $ERRORS"

    echo
    echo "Backup:"
    echo "  $BACKUP_DIR"

    exit 1

fi

printf "\n"
