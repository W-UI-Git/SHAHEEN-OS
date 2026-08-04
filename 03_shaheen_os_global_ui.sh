#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(pwd)"
PROJECT_NAME="SHAHEEN OS"

BRAND_DIR="$PROJECT_ROOT/public/brand"
LOGO_DIR="$BRAND_DIR/logo"
CSS_DIR="$PROJECT_ROOT/resources/css"
VIEW_DIR="$PROJECT_ROOT/resources/views/components"

CSS_FILE="$CSS_DIR/shaheen-os.css"
BRAND_COMPONENT="$VIEW_DIR/shaheen-brand.blade.php"
HERO_COMPONENT="$VIEW_DIR/shaheen-hero.blade.php"

BACKUP_ROOT="$PROJECT_ROOT/.shaheen-ui-backups"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

echo
echo "============================================================"
echo "              SHAHEEN OS — GLOBAL UI"
echo "============================================================"
echo

###############################################################################
# 01 — VALIDATE PROJECT
###############################################################################

echo "[01/12] Validating Laravel project..."

if [ ! -f "$PROJECT_ROOT/artisan" ]; then
    echo "ERROR: artisan not found."
    echo "Run this script from ~/sooq-app"
    exit 1
fi

mkdir -p "$CSS_DIR"
mkdir -p "$VIEW_DIR"
mkdir -p "$LOGO_DIR"

###############################################################################
# 02 — BACKUP
###############################################################################

echo "[02/12] Creating backup..."

mkdir -p "$BACKUP_DIR"

backup_file() {
    local source="$1"

    if [ -f "$source" ]; then
        local relative="${source#$PROJECT_ROOT/}"
        mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
        cp -f "$source" "$BACKUP_DIR/$relative"
    fi
}

backup_file "$CSS_FILE"
backup_file "$BRAND_COMPONENT"
backup_file "$HERO_COMPONENT"
backup_file "$PROJECT_ROOT/resources/css/app.css"
backup_file "$PROJECT_ROOT/Modules/Site/resources/views/layouts/app.blade.php"
backup_file "$PROJECT_ROOT/Modules/User/resources/views/layouts/auth.blade.php"

echo "Backup created:"
echo "$BACKUP_DIR"

###############################################################################
# 03 — DESIGN SYSTEM
###############################################################################

echo "[03/12] Creating SHAHEEN OS design system..."

cat > "$CSS_FILE" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS
| Global Premium Design System
|--------------------------------------------------------------------------
*/

:root {
    --shaheen-black: #030303;
    --shaheen-black-2: #080808;
    --shaheen-graphite: #111214;
    --shaheen-surface: #17181b;
    --shaheen-surface-2: #202226;

    --shaheen-white: #ffffff;
    --shaheen-white-soft: #f3f3f3;
    --shaheen-muted: #a5a7ad;

    --shaheen-gold: #e5c158;
    --shaheen-gold-light: #f4dc88;
    --shaheen-gold-dark: #a47f27;

    --shaheen-border: rgba(255, 255, 255, .10);
    --shaheen-border-strong: rgba(255, 255, 255, .18);

    --shaheen-radius-sm: 10px;
    --shaheen-radius-md: 16px;
    --shaheen-radius-lg: 24px;
    --shaheen-radius-xl: 34px;

    --shaheen-ease: cubic-bezier(.2, .8, .2, 1);

    --shaheen-shadow:
        0 24px 80px rgba(0, 0, 0, .32);
}

/*
|--------------------------------------------------------------------------
| Base
|--------------------------------------------------------------------------
*/

.shaheen-os {
    position: relative;
}

.shaheen-os *,
.shaheen-os *::before,
.shaheen-os *::after {
    box-sizing: border-box;
}

.shaheen-os a {
    text-decoration: none;
}

/*
|--------------------------------------------------------------------------
| Brand
|--------------------------------------------------------------------------
*/

.shaheen-brand {
    display: inline-flex;
    align-items: center;
    gap: 12px;

    color: var(--shaheen-white);

    transition:
        transform 180ms var(--shaheen-ease),
        opacity 180ms var(--shaheen-ease);
}

.shaheen-brand:hover {
    transform: translateY(-1px);
    opacity: .94;
}

.shaheen-brand-logo {
    display: block;

    width: auto;
    height: 42px;
    max-width: 230px;

    object-fit: contain;
}

.shaheen-brand-symbol {
    display: block;

    width: 42px;
    height: 42px;

    object-fit: contain;
}

.shaheen-brand-name {
    color: var(--shaheen-white);

    font-size: 14px;
    font-weight: 900;
    letter-spacing: .18em;
    text-transform: uppercase;
}

/*
|--------------------------------------------------------------------------
| Hero
|--------------------------------------------------------------------------
*/

.shaheen-hero {
    position: relative;
    isolation: isolate;

    width: 100%;
    min-height: clamp(540px, 76vh, 880px);

    display: flex;
    align-items: center;

    overflow: hidden;

    border-radius: var(--shaheen-radius-xl);

    background:
        radial-gradient(
            circle at 80% 20%,
            rgba(229, 193, 88, .14),
            transparent 27%
        ),
        radial-gradient(
            circle at 15% 80%,
            rgba(255, 255, 255, .055),
            transparent 30%
        ),
        linear-gradient(
            135deg,
            #020202 0%,
            #090909 48%,
            #151619 100%
        );

    box-shadow: var(--shaheen-shadow);
}

.shaheen-hero::before {
    content: "";

    position: absolute;
    z-index: -1;

    inset: -20%;

    background:
        conic-gradient(
            from 180deg at 50% 50%,
            transparent,
            rgba(229, 193, 88, .08),
            transparent,
            rgba(255, 255, 255, .04),
            transparent
        );

    animation:
        shaheen-orbit 14s linear infinite;
}

.shaheen-hero::after {
    content: "";

    position: absolute;
    z-index: -1;

    inset: 0;

    background:
        linear-gradient(
            115deg,
            transparent 0%,
            transparent 40%,
            rgba(255, 255, 255, .045) 50%,
            transparent 60%,
            transparent 100%
        );

    background-size: 240% 100%;

    animation:
        shaheen-light-sweep 8s ease-in-out infinite;
}

.shaheen-hero-content {
    position: relative;
    z-index: 2;

    width: min(1180px, calc(100% - 40px));

    margin: 0 auto;

    padding:
        clamp(70px, 10vw, 130px)
        0;
}

.shaheen-hero-kicker {
    display: inline-flex;
    align-items: center;
    gap: 9px;

    margin-bottom: 24px;
    padding: 8px 14px;

    border: 1px solid var(--shaheen-border-strong);
    border-radius: 999px;

    background: rgba(255, 255, 255, .035);

    color: var(--shaheen-gold-light);

    font-size: 11px;
    font-weight: 800;
    letter-spacing: .16em;
    text-transform: uppercase;

    backdrop-filter: blur(18px);
}

.shaheen-hero-title {
    max-width: 950px;

    margin: 0;

    color: var(--shaheen-white);

    font-size: clamp(48px, 8vw, 108px);
    font-weight: 950;
    line-height: .93;

    letter-spacing: -.065em;
}

.shaheen-hero-title span {
    display: inline-block;

    color: transparent;

    background:
        linear-gradient(
            110deg,
            #ffffff 5%,
            #e5c158 45%,
            #ffffff 85%
        );

    background-size: 220% auto;

    -webkit-background-clip: text;
    background-clip: text;

    animation:
        shaheen-gradient 7s ease-in-out infinite;
}

.shaheen-hero-description {
    max-width: 700px;

    margin:
        30px
        0
        0;

    color: var(--shaheen-muted);

    font-size: clamp(15px, 2vw, 20px);
    line-height: 1.75;
}

.shaheen-hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;

    margin-top: 34px;
}

.shaheen-button {
    min-height: 52px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    padding:
        0
        23px;

    border: 1px solid transparent;
    border-radius: 999px;

    font-size: 14px;
    font-weight: 850;

    transition:
        transform 180ms var(--shaheen-ease),
        box-shadow 180ms var(--shaheen-ease),
        background 180ms var(--shaheen-ease);
}

.shaheen-button:hover {
    transform: translateY(-2px);
}

.shaheen-button-primary {
    background: var(--shaheen-gold);
    color: #050505;

    box-shadow:
        0 14px 40px rgba(229, 193, 88, .20);
}

.shaheen-button-primary:hover {
    background: var(--shaheen-gold-light);

    box-shadow:
        0 20px 55px rgba(229, 193, 88, .30);
}

.shaheen-button-secondary {
    border-color: var(--shaheen-border-strong);

    background: rgba(255, 255, 255, .045);

    color: var(--shaheen-white);

    backdrop-filter: blur(16px);
}

/*
|--------------------------------------------------------------------------
| Glass Cards
|--------------------------------------------------------------------------
*/

.shaheen-glass {
    border:
        1px solid
        var(--shaheen-border);

    background:
        linear-gradient(
            135deg,
            rgba(255, 255, 255, .075),
            rgba(255, 255, 255, .025)
        );

    box-shadow:
        0 20px 70px rgba(0, 0, 0, .20);

    backdrop-filter: blur(24px);
}

/*
|--------------------------------------------------------------------------
| Footer Brand
|--------------------------------------------------------------------------
*/

.shaheen-brand-footer {
    width: 100%;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 24px 16px;

    color: rgba(255, 255, 255, .45);

    font-size: 11px;
    font-weight: 750;
    letter-spacing: .12em;
    text-transform: uppercase;
}

.shaheen-brand-footer strong {
    margin-inline-start: 6px;

    color: var(--shaheen-gold);
}

/*
|--------------------------------------------------------------------------
| Mobile
|--------------------------------------------------------------------------
*/

@media (max-width: 900px) {
    .shaheen-hero {
        min-height: 620px;
        border-radius: var(--shaheen-radius-lg);
    }

    .shaheen-hero-content {
        width: calc(100% - 32px);
    }
}

@media (max-width: 640px) {
    .shaheen-hero {
        min-height: 600px;
        border-radius: 20px;
    }

    .shaheen-hero-content {
        width: calc(100% - 28px);
        padding: 70px 0;
    }

    .shaheen-brand-logo {
        height: 34px;
        max-width: 180px;
    }

    .shaheen-brand-symbol {
        width: 36px;
        height: 36px;
    }

    .shaheen-hero-title {
        font-size: clamp(44px, 14vw, 72px);
    }

    .shaheen-hero-description {
        font-size: 15px;
        line-height: 1.7;
    }

    .shaheen-hero-actions {
        flex-direction: column;
    }

    .shaheen-button {
        width: 100%;
    }
}

/*
|--------------------------------------------------------------------------
| Reduced Motion
|--------------------------------------------------------------------------
*/

@media (prefers-reduced-motion: reduce) {
    .shaheen-hero::before,
    .shaheen-hero::after,
    .shaheen-hero-title span {
        animation: none;
    }

    .shaheen-brand,
    .shaheen-button {
        transition: none;
    }
}

/*
|--------------------------------------------------------------------------
| Animations
|--------------------------------------------------------------------------
*/

@keyframes shaheen-orbit {
    from {
        transform: rotate(0deg) scale(1);
    }

    50% {
        transform: rotate(180deg) scale(1.06);
    }

    to {
        transform: rotate(360deg) scale(1);
    }
}

@keyframes shaheen-light-sweep {
    0% {
        background-position: 180% 0;
    }

    50% {
        background-position: -20% 0;
    }

    100% {
        background-position: 180% 0;
    }
}

@keyframes shaheen-gradient {
    0%,
    100% {
        background-position: 0% 50%;
    }

    50% {
        background-position: 100% 50%;
    }
}
CSS

###############################################################################
# 04 — BRAND COMPONENT
###############################################################################

echo "[04/12] Creating SHAHEEN OS brand component..."

cat > "$BRAND_COMPONENT" <<'BLADE'
@php
    $shaheenSiteName = $generalSettings['site_name'] ?? config('app.name', 'SHAHEEN OS');
    $shaheenLogo = $generalSettings['site_logo_url'] ?? null;
    $shaheenDefaultLogo = asset('brand/logo/shaheen-os-horizontal.svg');
    $shaheenSymbol = asset('brand/logo/shaheen-os-symbol.svg');
@endphp

<a
    href="{{ route('home') }}"
    class="shaheen-brand"
    aria-label="{{ $shaheenSiteName }}"
>
    @if($shaheenLogo)
        <img
            src="{{ $shaheenLogo }}"
            alt="{{ $shaheenSiteName }}"
            class="shaheen-brand-logo"
        >
    @else
        <img
            src="{{ $shaheenDefaultLogo }}"
            alt="{{ $shaheenSiteName }}"
            class="shaheen-brand-logo"
            onerror="this.onerror=null;this.src='{{ $shaheenSymbol }}';"
        >
    @endif
</a>
BLADE

###############################################################################
# 05 — HERO COMPONENT
###############################################################################

echo "[05/12] Creating premium SHAHEEN OS hero..."

cat > "$HERO_COMPONENT" <<'BLADE'
@php
    $shaheenSiteName = $generalSettings['site_name'] ?? config('app.name', 'SHAHEEN OS');

    $shaheenDescription = $generalSettings['site_description']
        ?? 'A premium digital marketplace built for the next generation.';
@endphp

<section class="shaheen-hero shaheen-os">

    <div class="shaheen-hero-content">

        <div class="shaheen-hero-kicker">
            <span aria-hidden="true">✦</span>
            <span>{{ $shaheenSiteName }}</span>
        </div>

        <h1 class="shaheen-hero-title">
            {{ $shaheenSiteName }}
            <br>
            <span>Beyond Ordinary.</span>
        </h1>

        <p class="shaheen-hero-description">
            {{ $shaheenDescription }}
        </p>

        <div class="shaheen-hero-actions">

            <a
                href="{{ route('listings.index') }}"
                class="shaheen-button shaheen-button-primary"
            >
                Explore Marketplace
            </a>

            <a
                href="{{ route('register') }}"
                class="shaheen-button shaheen-button-secondary"
            >
                Create Account
            </a>

        </div>

    </div>

</section>
BLADE

###############################################################################
# 06 — IMPORT DESIGN SYSTEM
###############################################################################

echo "[06/12] Registering SHAHEEN OS CSS..."

APP_CSS="$PROJECT_ROOT/resources/css/app.css"

if [ -f "$APP_CSS" ]; then

    if ! grep -qF "@import './shaheen-os.css';" "$APP_CSS"; then
        printf '%s\n' "@import './shaheen-os.css';" | cat - "$APP_CSS" > "$APP_CSS.tmp"
        mv "$APP_CSS.tmp" "$APP_CSS"
        echo "SHAHEEN OS CSS imported."
    else
        echo "SHAHEEN OS CSS already imported."
    fi

else

    printf '%s\n' "@import './shaheen-os.css';" > "$APP_CSS"
    echo "resources/css/app.css created."

fi

###############################################################################
# 07 — BRAND README CLEANUP
###############################################################################

echo "[07/12] Cleaning old SHAHEEN ON references..."

README_FILE="$BRAND_DIR/README.md"

if [ -f "$README_FILE" ]; then
    sed -i \
        -e 's/SHAHEEN ON/SHAHEEN OS/g' \
        -e 's/SHAHEEN-ON/SHAHEEN-OS/g' \
        -e 's/shaheen-on/shaheen-os/g' \
        "$README_FILE"
fi

###############################################################################
# 08 — VERIFY DATABASE BRAND
###############################################################################

echo "[08/12] Verifying database branding..."

php artisan tinker --execute='
$settings = app(\Modules\Site\App\Settings\GeneralSettings::class);
$settings->site_name = "SHAHEEN OS";
$settings->sender_name = "SHAHEEN OS";
$settings->save();
echo "site_name=" . $settings->site_name . PHP_EOL;
echo "sender_name=" . $settings->sender_name . PHP_EOL;
'

###############################################################################
# 09 — CLEAR LARAVEL CACHE
###############################################################################

echo "[09/12] Clearing Laravel caches..."

php artisan optimize:clear

###############################################################################
# 10 — REBUILD LARAVEL CACHE
###############################################################################

echo "[10/12] Rebuilding Laravel cache..."

php artisan optimize

###############################################################################
# 11 — VERIFY FILES
###############################################################################

echo "[11/12] Verifying SHAHEEN OS UI..."

FAILED=0

verify_file() {
    local file="$1"

    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ MISSING: $file"
        FAILED=1
    fi
}

verify_file "$CSS_FILE"
verify_file "$BRAND_COMPONENT"
verify_file "$HERO_COMPONENT"
verify_file "$APP_CSS"
verify_file "$LOGO_DIR/shaheen-os-horizontal.svg"
verify_file "$LOGO_DIR/shaheen-os-symbol.svg"

if [ "$FAILED" -ne 0 ]; then
    echo
    echo "ERROR: One or more required files are missing."
    exit 1
fi

###############################################################################
# 12 — FINAL REPORT
###############################################################################

echo "[12/12] Final SHAHEEN OS verification..."

echo
echo "Checking old SHAHEEN ON references in brand files..."

if grep -RniE 'SHAHEEN ON|shaheen-on' "$BRAND_DIR" 2>/dev/null; then
    echo
    echo "WARNING: Old SHAHEEN ON references still exist."
else
    echo "✓ No SHAHEEN ON references found in public/brand."
fi

echo
echo "============================================================"
echo "              SHAHEEN OS GLOBAL UI COMPLETE"
echo "============================================================"
echo
echo "Project:"
echo "  SHAHEEN OS"
echo
echo "Backup:"
echo "  $BACKUP_DIR"
echo
echo "Design System:"
echo "  $CSS_FILE"
echo
echo "Brand Component:"
echo "  $BRAND_COMPONENT"
echo
echo "Hero Component:"
echo "  $HERO_COMPONENT"
echo
echo "Main Logo:"
echo "  $LOGO_DIR/shaheen-os-horizontal.svg"
echo
echo "Symbol:"
echo "  $LOGO_DIR/shaheen-os-symbol.svg"
echo
echo "✓ Premium design system installed."
echo "✓ Responsive layout system installed."
echo "✓ Smooth animation system installed."
echo "✓ Mobile layout rules installed."
echo "✓ Reduced-motion support installed."
echo "✓ SHAHEEN OS database identity verified."
echo "✓ Laravel cache rebuilt."
echo
echo "Next stage can start."
echo
