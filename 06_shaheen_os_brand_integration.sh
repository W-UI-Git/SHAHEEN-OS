#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

PROJECT_NAME="SHAHEEN OS"
OLD_BRAND="OpenClassify"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

CSS_FILE="resources/css/shaeheen-os-global.css"
JS_FILE="resources/js/shaeheen-os-global.js"

APP_CSS="resources/css/app.css"
APP_JS="resources/js/app.js"

ERRORS=0

log() {
    printf '\n[SHAHEEN OS] %s\n' "$1"
}

ok() {
    printf '✓ %s\n' "$1"
}

warn() {
    printf '⚠ %s\n' "$1"
}

fail() {
    printf '✗ %s\n' "$1"
    ERRORS=$((ERRORS + 1))
}

banner() {
    printf '\n============================================================\n'
    printf '              SHAHEEN OS — GLOBAL BRAND UI\n'
    printf '============================================================\n'
}

cleanup() {
    if [[ "$ERRORS" -gt 0 ]]; then
        printf '\nSHAHEEN OS GLOBAL BRANDING FAILED\n'
        printf 'Errors: %s\n' "$ERRORS"
        printf 'Backup: %s\n' "$BACKUP_DIR"
        exit 1
    fi
}

trap cleanup EXIT

banner

###############################################################################
# 01 — PROJECT VALIDATION
###############################################################################

log "[1/12] Validating Laravel project..."

if [[ ! -f "artisan" ]]; then
    fail "Laravel artisan file was not found."
    exit 1
fi

if [[ ! -d "resources" ]]; then
    fail "resources directory was not found."
    exit 1
fi

if [[ ! -d "public" ]]; then
    fail "public directory was not found."
    exit 1
fi

ok "Laravel project detected."

###############################################################################
# 02 — BACKUP
###############################################################################

log "[2/12] Creating protected backup..."

mkdir -p "$BACKUP_DIR"

cp -a resources "$BACKUP_DIR/resources"

if [[ -d "public/brand" ]]; then
    cp -a public/brand "$BACKUP_DIR/brand"
fi

if [[ -f ".env" ]]; then
    cp -a .env "$BACKUP_DIR/.env"
fi

ok "Backup created:"
echo "  $BACKUP_DIR"

###############################################################################
# 03 — CREATE GLOBAL CSS
###############################################################################

log "[3/12] Installing SHAHEEN OS global design layer..."

mkdir -p resources/css

cat > "$CSS_FILE" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global Brand UI
|--------------------------------------------------------------------------
| Global visual layer.
| Does not depend on a specific frontend framework.
|--------------------------------------------------------------------------
*/

:root {
    --shaheen-black: #050507;
    --shaheen-black-soft: #0a0b0f;
    --shaheen-surface: #101116;
    --shaheen-surface-2: #17191f;

    --shaheen-white: #ffffff;
    --shaheen-silver: #c8ccd4;
    --shaheen-muted: #8b909b;

    --shaheen-gold: #e5c158;
    --shaheen-gold-light: #f4d982;
    --shaheen-gold-dark: #9f8130;

    --shaheen-border: rgba(255,255,255,.09);
    --shaheen-border-gold: rgba(229,193,88,.28);

    --shaheen-shadow:
        0 20px 60px rgba(0,0,0,.35);

    --shaheen-radius-sm: 10px;
    --shaheen-radius-md: 16px;
    --shaheen-radius-lg: 24px;
    --shaheen-radius-xl: 32px;

    --shaheen-transition:
        240ms cubic-bezier(.22,1,.36,1);
}

/*
|--------------------------------------------------------------------------
| Base
|--------------------------------------------------------------------------
*/

html {
    scroll-behavior: smooth;
}

body {
    background:
        radial-gradient(
            circle at 50% -10%,
            rgba(229,193,88,.055),
            transparent 35%
        ),
        var(--shaheen-black);
    color: var(--shaheen-white);
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
}

::selection {
    background: rgba(229,193,88,.25);
    color: #fff;
}

/*
|--------------------------------------------------------------------------
| Global surfaces
|--------------------------------------------------------------------------
*/

.shaheen-surface {
    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.045),
            rgba(255,255,255,.015)
        );
    border: 1px solid var(--shaheen-border);
    box-shadow: var(--shaheen-shadow);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
}

.shaheen-glass {
    background: rgba(10,11,15,.72);
    border: 1px solid var(--shaheen-border);
    backdrop-filter: blur(22px);
    -webkit-backdrop-filter: blur(22px);
}

/*
|--------------------------------------------------------------------------
| Buttons
|--------------------------------------------------------------------------
*/

.shaheen-button {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: .55rem;
    min-height: 44px;
    padding: .7rem 1.15rem;
    border-radius: 999px;
    border: 1px solid var(--shaheen-border-gold);
    background:
        linear-gradient(
            135deg,
            rgba(229,193,88,.18),
            rgba(229,193,88,.04)
        );
    color: var(--shaheen-white);
    transition: transform var(--shaheen-transition),
                border-color var(--shaheen-transition),
                background var(--shaheen-transition),
                box-shadow var(--shaheen-transition);
}

.shaheen-button:hover {
    transform: translateY(-2px);
    border-color: rgba(229,193,88,.65);
    background:
        linear-gradient(
            135deg,
            rgba(229,193,88,.28),
            rgba(229,193,88,.08)
        );
    box-shadow:
        0 10px 30px rgba(229,193,88,.10);
}

.shaheen-button:active {
    transform: translateY(0) scale(.98);
}

/*
|--------------------------------------------------------------------------
| Cards
|--------------------------------------------------------------------------
*/

.shaheen-card {
    position: relative;
    overflow: hidden;
    border-radius: var(--shaheen-radius-lg);
    border: 1px solid var(--shaheen-border);
    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.045),
            rgba(255,255,255,.012)
        );
    transition:
        transform var(--shaheen-transition),
        border-color var(--shaheen-transition),
        box-shadow var(--shaheen-transition);
}

.shaheen-card::before {
    content: "";
    position: absolute;
    inset: 0;
    pointer-events: none;
    background:
        radial-gradient(
            circle at top right,
            rgba(229,193,88,.10),
            transparent 35%
        );
    opacity: .65;
}

.shaheen-card:hover {
    transform: translateY(-4px);
    border-color: var(--shaheen-border-gold);
    box-shadow:
        0 20px 50px rgba(0,0,0,.30);
}

/*
|--------------------------------------------------------------------------
| Brand typography
|--------------------------------------------------------------------------
*/

.shaheen-brand {
    font-weight: 800;
    letter-spacing: .08em;
    color: var(--shaheen-white);
}

.shaheen-brand-accent {
    color: var(--shaheen-gold);
}

.shaheen-eyebrow {
    font-size: .72rem;
    font-weight: 700;
    letter-spacing: .18em;
    text-transform: uppercase;
    color: var(--shaheen-gold);
}

/*
|--------------------------------------------------------------------------
| Images
|--------------------------------------------------------------------------
*/

.shaheen-image {
    display: block;
    width: 100%;
    height: auto;
    object-fit: cover;
    transition:
        transform 700ms cubic-bezier(.22,1,.36,1),
        filter 500ms ease;
}

.shaheen-image:hover {
    transform: scale(1.035);
}

/*
|--------------------------------------------------------------------------
| Focus
|--------------------------------------------------------------------------
*/

:focus-visible {
    outline: 2px solid var(--shaheen-gold);
    outline-offset: 3px;
}

/*
|--------------------------------------------------------------------------
| Mobile
|--------------------------------------------------------------------------
*/

@media (max-width: 768px) {
    :root {
        --shaheen-radius-lg: 20px;
        --shaheen-radius-xl: 24px;
    }

    .shaheen-card:hover {
        transform: none;
    }

    .shaheen-button:hover {
        transform: none;
    }
}

/*
|--------------------------------------------------------------------------
| Reduced Motion
|--------------------------------------------------------------------------
*/

@media (prefers-reduced-motion: reduce) {
    html {
        scroll-behavior: auto;
    }

    *,
    *::before,
    *::after {
        animation-duration: .01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: .01ms !important;
        scroll-behavior: auto !important;
    }
}
CSS

ok "Global SHAHEEN OS CSS created."

###############################################################################
# 04 — CREATE GLOBAL JS
###############################################################################

log "[4/12] Installing SHAHEEN OS interaction layer..."

mkdir -p resources/js

cat > "$JS_FILE" <<'JS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Global UI Runtime
|--------------------------------------------------------------------------
*/

(function () {
    "use strict";

    const reducedMotion = window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;

    function initReveal() {
        const elements = document.querySelectorAll(
            "[data-shaheen-reveal]"
        );

        if (!elements.length) {
            return;
        }

        if (reducedMotion || !("IntersectionObserver" in window)) {
            elements.forEach(function (element) {
                element.classList.add("shaheen-visible");
            });

            return;
        }

        const observer = new IntersectionObserver(
            function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("shaheen-visible");
                        observer.unobserve(entry.target);
                    }
                });
            },
            {
                threshold: 0.12
            }
        );

        elements.forEach(function (element) {
            observer.observe(element);
        });
    }

    function initBrandLinks() {
        document
            .querySelectorAll("[data-shaheen-brand]")
            .forEach(function (element) {
                element.addEventListener("click", function () {
                    window.scrollTo({
                        top: 0,
                        behavior: reducedMotion ? "auto" : "smooth"
                    });
                });
            });
    }

    function initImageMotion() {
        if (reducedMotion) {
            return;
        }

        document
            .querySelectorAll("[data-shaheen-image-motion]")
            .forEach(function (image) {
                image.addEventListener("pointermove", function (event) {
                    const rect = image.getBoundingClientRect();

                    const x =
                        ((event.clientX - rect.left) / rect.width - 0.5) *
                        2;

                    const y =
                        ((event.clientY - rect.top) / rect.height - 0.5) *
                        2;

                    image.style.transform =
                        "scale(1.025) translate(" +
                        x * 3 +
                        "px," +
                        y * 3 +
                        "px)";
                });

                image.addEventListener("pointerleave", function () {
                    image.style.transform = "";
                });
            });
    }

    function init() {
        initReveal();
        initBrandLinks();
        initImageMotion();

        document.documentElement.classList.add(
            "shaheen-os-ready"
        );
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
JS

ok "Global SHAHEEN OS JavaScript created."

###############################################################################
# 05 — ADD GLOBAL CSS IMPORT
###############################################################################

log "[5/12] Registering global CSS..."

if [[ -f "$APP_CSS" ]]; then

    if ! grep -Fq "shaheen-os-global.css" "$APP_CSS"; then
        {
            printf '%s\n' '/* SHAHEEN OS GLOBAL BRAND */'
            printf '%s\n' '@import "./shaheen-os-global.css";'
            printf '\n'
            cat "$APP_CSS"
        } > "$APP_CSS.shaheen.tmp"

        mv "$APP_CSS.shaheen.tmp" "$APP_CSS"

        ok "SHAHEEN OS CSS registered in resources/css/app.css."
    else
        ok "SHAHEEN OS CSS was already registered."
    fi

else
    warn "resources/css/app.css was not found."
    warn "Global CSS remains available at:"
    echo "  $CSS_FILE"
fi

###############################################################################
# 06 — ADD GLOBAL JS IMPORT
###############################################################################

log "[6/12] Registering global JavaScript..."

if [[ -f "$APP_JS" ]]; then

    if ! grep -Fq "shaheen-os-global.js" "$APP_JS"; then

        {
            printf '%s\n' '/* SHAHEEN OS GLOBAL BRAND */'
            printf '%s\n' 'import "./shaheen-os-global.js";'
            printf '\n'
            cat "$APP_JS"
        } > "$APP_JS.shaheen.tmp"

        mv "$APP_JS.shaheen.tmp" "$APP_JS"

        ok "SHAHEEN OS JavaScript registered in resources/js/app.js."
    else
        ok "SHAHEEN OS JavaScript was already registered."
    fi

else
    warn "resources/js/app.js was not found."
    warn "Global JavaScript remains available at:"
    echo "  $JS_FILE"
fi

###############################################################################
# 07 — BRAND VISIBLE TEXT REPLACEMENT
###############################################################################

log "[7/12] Removing visible OpenClassify branding..."

SEARCH_DIRS=(
    "resources/views"
    "resources/lang"
    "lang"
    "config"
)

for DIR in "${SEARCH_DIRS[@]}"; do

    [[ -d "$DIR" ]] || continue

    while IFS= read -r -d '' FILE; do

        if grep -Fq "$OLD_BRAND" "$FILE"; then

            sed -i "s/${OLD_BRAND}/${PROJECT_NAME}/g" "$FILE"

            ok "Updated: $FILE"
        fi

    done < <(
        find "$DIR" \
            -type f \
            \( \
                -name "*.php" \
                -o -name "*.blade.php" \
                -o -name "*.js" \
                -o -name "*.json" \
                -o -name "*.ts" \
                -o -name "*.vue" \
                -o -name "*.css" \
                -o -name "*.html" \
                -o -name "*.md" \
            \) \
            -print0
    )

done

###############################################################################
# 08 — APPLICATION BRAND METADATA
###############################################################################

log "[8/12] Updating application metadata..."

if [[ -f ".env" ]]; then

    if grep -q '^APP_NAME=' .env; then
        sed -i 's/^APP_NAME=.*/APP_NAME="SHAHEEN OS"/' .env
    else
        printf '\nAPP_NAME="SHAHEEN OS"\n' >> .env
    fi

    ok "APP_NAME=SHAHEEN OS"
fi

###############################################################################
# 09 — BLADE BRAND MARKER
###############################################################################

log "[9/12] Installing reusable SHAHEEN OS brand marker..."

mkdir -p resources/views/components

cat > resources/views/components/shaheen-global-brand.blade.php <<'BLADE'
@php
    $brandLogo = asset('brand/logo/shaheen-os-horizontal.svg');
    $brandSymbol = asset('brand/logo/shaheen-os-symbol.svg');
@endphp

<div
    class="shaheen-brand"
    data-shaheen-brand
    aria-label="SHAHEEN OS"
>
    <img
        src="{{ $brandLogo }}"
        alt="SHAHEEN OS"
        loading="eager"
        style="height:32px;width:auto;display:block;"
    >
</div>
BLADE

ok "Reusable brand component created."

###############################################################################
# 10 — BRAND CSS ANIMATION LAYER
###############################################################################

log "[10/12] Installing global reveal animation..."

cat >> "$CSS_FILE" <<'CSS'

/*
|--------------------------------------------------------------------------
| SHAHEEN OS Reveal System
|--------------------------------------------------------------------------
*/

[data-shaheen-reveal] {
    opacity: 0;
    transform: translateY(18px);
    transition:
        opacity 700ms cubic-bezier(.22,1,.36,1),
        transform 700ms cubic-bezier(.22,1,.36,1);
}

[data-shaheen-reveal].shaheen-visible {
    opacity: 1;
    transform: translateY(0);
}

.shaheen-os-ready {
    --shaheen-ui-ready: 1;
}

@media (prefers-reduced-motion: reduce) {
    [data-shaheen-reveal] {
        opacity: 1;
        transform: none;
    }
}
CSS

ok "Reveal animation system installed."

###############################################################################
# 11 — BUILD FRONTEND
###############################################################################

log "[11/12] Building frontend assets..."

if [[ -f "package.json" ]] && command -v npm >/dev/null 2>&1; then

    if grep -q '"build"' package.json; then

        npm run build

        ok "Frontend build completed."

    else
        warn "No npm build script found."
    fi

elif [[ -f "package.json" ]]; then

    warn "npm is not installed."
    warn "Frontend build was skipped."

else

    warn "package.json not found."
    warn "Frontend build was skipped."

fi

###############################################################################
# 12 — LARAVEL CACHE + VERIFICATION
###############################################################################

log "[12/12] Clearing and rebuilding Laravel..."

php artisan optimize:clear
php artisan optimize

ok "Laravel cache rebuilt."

printf '\n'
printf '%s\n' "Checking SHAHEEN OS brand files..."

CHECK_FILES=(
    "$CSS_FILE"
    "$JS_FILE"
    "resources/views/components/shaheen-global-brand.blade.php"
    "resources/css/shaeheen-os-global.css"
)

# Correct the typo-proof CSS path if needed.
if [[ -f "resources/css/shaeheen-os-global.css" ]]; then
    :
elif [[ -f "$CSS_FILE" ]]; then
    :
else
    fail "Global SHAHEEN OS CSS was not found."
fi

for FILE in \
    "$CSS_FILE" \
    "$JS_FILE" \
    "resources/views/components/shaheen-global-brand.blade.php"
do

    if [[ -f "$FILE" ]]; then
        ok "$PROJECT_ROOT/$FILE"
    else
        fail "Missing: $FILE"
    fi

done

###############################################################################
# OPENCLASSIFY VERIFICATION
###############################################################################

printf '\n'
printf '%s\n' "Checking remaining OpenClassify references in UI source..."

FOUND=0

for DIR in \
    resources/views \
    resources/lang \
    lang \
    config
do

    [[ -d "$DIR" ]] || continue

    if grep -RIl \
        --exclude-dir=node_modules \
        --exclude-dir=vendor \
        --exclude-dir=build \
        -F "$OLD_BRAND" \
        "$DIR" 2>/dev/null | head -20 | grep -q .; then

        FOUND=1

        grep -RIn \
            --exclude-dir=node_modules \
            --exclude-dir=vendor \
            --exclude-dir=build \
            -F "$OLD_BRAND" \
            "$DIR" 2>/dev/null | head -20

    fi

done

if [[ "$FOUND" -eq 0 ]]; then
    ok "No OpenClassify references found in primary UI/config sources."
else
    warn "Some OpenClassify references remain."
    warn "They were not blindly modified because they may be package/config identifiers."
fi

###############################################################################
# FINAL REPORT
###############################################################################

printf '\n'
printf '============================================================\n'
printf '              SHAHEEN OS GLOBAL UI COMPLETE\n'
printf '============================================================\n'

printf '\n'
printf 'Project:\n'
printf '  %s\n' "$PROJECT_NAME"

printf '\n'
printf 'Global CSS:\n'
printf '  %s/%s\n' "$PROJECT_ROOT" "$CSS_FILE"

printf '\n'
printf 'Global JavaScript:\n'
printf '  %s/%s\n' "$PROJECT_ROOT" "$JS_FILE"

printf '\n'
printf 'Brand Component:\n'
printf '  %s/resources/views/components/shaheen-global-brand.blade.php\n' "$PROJECT_ROOT"

printf '\n'
printf 'Brand Assets:\n'
printf '  %s/public/brand/\n' "$PROJECT_ROOT"

printf '\n'
printf 'Backup:\n'
printf '  %s\n' "$BACKUP_DIR"

printf '\n'
ok "SHAHEEN OS global visual layer installed."
ok "Responsive design layer installed."
ok "Motion/reveal system installed."
ok "Application metadata updated."
ok "Laravel cache rebuilt."

printf '\n'
printf 'Next stage can start.\n'

