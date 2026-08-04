#!/usr/bin/env bash

set -Eeuo pipefail

###############################################################################
# SHAHEEN OS
# PREMIUM UI / BRAND INTEGRATION
#
# Project:
#   SHAHEEN OS
#
# Framework:
#   Laravel + Blade + Vite
#
# Purpose:
#   Integrate SHAHEEN OS visual identity into the existing application
#   without modifying business logic or database structure.
###############################################################################

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$PROJECT_ROOT"

PROJECT_NAME="SHAHEEN OS"
BRAND_SLUG="shaheen-os"

PUBLIC_DIR="$PROJECT_ROOT/public"
RESOURCES_DIR="$PROJECT_ROOT/resources"

BRAND_DIR="$PUBLIC_DIR/brand"
BRAND_LOGO_DIR="$BRAND_DIR/logo"
BRAND_SOCIAL_DIR="$BRAND_DIR/social"

CSS_DIR="$RESOURCES_DIR/css"

SITE_LAYOUT="$PROJECT_ROOT/Modules/Site/resources/views/layouts/app.blade.php"
AUTH_LAYOUT="$PROJECT_ROOT/Modules/User/resources/views/layouts/auth.blade.php"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

###############################################################################
# COLORS
###############################################################################

RESET="\033[0m"
BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
WHITE="\033[37m"

###############################################################################
# FUNCTIONS
###############################################################################

log() {
    printf "%b\n" "${CYAN}[SHAHEEN OS]${RESET} $1"
}

success() {
    printf "%b\n" "${GREEN}✔${RESET} $1"
}

warn() {
    printf "%b\n" "${YELLOW}⚠${RESET} $1"
}

error() {
    printf "%b\n" "${RED}✖${RESET} $1"
}

die() {
    error "$1"
    exit 1
}

###############################################################################
# HEADER
###############################################################################

clear

printf "\n"
printf "%b\n" "${BOLD}${CYAN}==============================================================${RESET}"
printf "%b\n" "${BOLD}${WHITE}                 SHAHEEN OS UI ENGINE${RESET}"
printf "%b\n" "${BOLD}${CYAN}==============================================================${RESET}"
printf "\n"

###############################################################################
# VALIDATION
###############################################################################

log "[1/12] Validating project..."

[[ -d "$PROJECT_ROOT" ]] || die "Project root not found."

[[ -f "$PROJECT_ROOT/artisan" ]] || die "Laravel artisan file not found."

[[ -d "$RESOURCES_DIR" ]] || die "resources directory not found."

[[ -d "$PUBLIC_DIR" ]] || die "public directory not found."

success "Laravel project detected."

###############################################################################
# BACKUP
###############################################################################

log "[2/12] Creating backup..."

mkdir -p "$BACKUP_DIR"

if [[ -f "$SITE_LAYOUT" ]]; then
    cp "$SITE_LAYOUT" "$BACKUP_DIR/app.blade.php"
fi

if [[ -f "$AUTH_LAYOUT" ]]; then
    cp "$AUTH_LAYOUT" "$BACKUP_DIR/auth.blade.php"
fi

if [[ -f "$RESOURCES_DIR/css/app.css" ]]; then
    cp "$RESOURCES_DIR/css/app.css" "$BACKUP_DIR/app.css"
fi

success "Backup created:"
printf "  %s\n" "$BACKUP_DIR"

###############################################################################
# BRAND DIRECTORIES
###############################################################################

log "[3/12] Preparing SHAHEEN OS brand directories..."

mkdir -p \
    "$BRAND_DIR" \
    "$BRAND_LOGO_DIR" \
    "$BRAND_SOCIAL_DIR" \
    "$CSS_DIR"

success "Brand directories ready."

###############################################################################
# FIND EXISTING LOGO
###############################################################################

log "[4/12] Detecting existing brand assets..."

LOGO_SOURCE=""

for candidate in \
    "$BRAND_LOGO_DIR/shaheen-os-horizontal.svg" \
    "$BRAND_LOGO_DIR/shaheen-on-horizontal.svg" \
    "$BRAND_DIR/logo/shaheen-os-horizontal.svg" \
    "$BRAND_DIR/logo/shaheen-on-horizontal.svg"
do
    if [[ -f "$candidate" ]]; then
        LOGO_SOURCE="$candidate"
        break
    fi
done

###############################################################################
# FIX OLD SHAHEEN ON ASSET NAMES
###############################################################################

if [[ -f "$BRAND_LOGO_DIR/shaheen-on-horizontal.svg" ]]; then

    log "Renaming old SHAHEEN ON horizontal logo..."

    mv \
        "$BRAND_LOGO_DIR/shaheen-on-horizontal.svg" \
        "$BRAND_LOGO_DIR/shaheen-os-horizontal.svg"

    LOGO_SOURCE="$BRAND_LOGO_DIR/shaheen-os-horizontal.svg"

    success "Logo renamed to SHAHEEN OS."

fi

if [[ -f "$BRAND_LOGO_DIR/shaheen-on-symbol.svg" ]]; then

    mv \
        "$BRAND_LOGO_DIR/shaheen-on-symbol.svg" \
        "$BRAND_LOGO_DIR/shaheen-os-symbol.svg"

    success "Symbol renamed to SHAHEEN OS."

fi

###############################################################################
# FALLBACK LOGO
###############################################################################

if [[ ! -f "$BRAND_LOGO_DIR/shaheen-os-horizontal.svg" ]]; then

    log "Creating SHAHEEN OS fallback SVG logo..."

    cat > "$BRAND_LOGO_DIR/shaheen-os-horizontal.svg" <<'SVG'
<svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 920 220"
    role="img"
    aria-labelledby="title desc"
>
    <title>SHAHEEN OS</title>
    <desc>SHAHEEN OS premium brand identity</desc>

    <defs>
        <linearGradient id="gold" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="#F8E7A1"/>
            <stop offset="45%" stop-color="#D8B85A"/>
            <stop offset="100%" stop-color="#9A7627"/>
        </linearGradient>

        <linearGradient id="silver" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="#FFFFFF"/>
            <stop offset="50%" stop-color="#D7D7D7"/>
            <stop offset="100%" stop-color="#777777"/>
        </linearGradient>
    </defs>

    <g transform="translate(20 20)">
        <circle
            cx="90"
            cy="90"
            r="78"
            fill="none"
            stroke="url(#gold)"
            stroke-width="4"
            opacity=".95"
        />

        <path
            d="M45 118
               C58 80 76 53 105 39
               C93 62 93 80 104 96
               C118 75 133 60 150 52
               C137 85 132 109 113 126
               C91 146 65 141 45 118Z"
            fill="url(#silver)"
        />

        <circle
            cx="110"
            cy="75"
            r="5"
            fill="#050507"
        />

        <path
            d="M111 79 L138 86 L113 91 Z"
            fill="url(#gold)"
        />
    </g>

    <text
        x="210"
        y="105"
        fill="url(#silver)"
        font-family="Arial, Helvetica, sans-serif"
        font-size="70"
        font-weight="800"
        letter-spacing="8"
    >
        SHAHEEN
    </text>

    <text
        x="215"
        y="162"
        fill="url(#gold)"
        font-family="Arial, Helvetica, sans-serif"
        font-size="42"
        font-weight="700"
        letter-spacing="15"
    >
        OS
    </text>
</svg>
SVG

    LOGO_SOURCE="$BRAND_LOGO_DIR/shaheen-os-horizontal.svg"

    success "Fallback SHAHEEN OS logo created."

fi

###############################################################################
# SHAHEEN OS BRAND CSS
###############################################################################

log "[5/12] Creating SHAHEEN OS design system..."

cat > "$CSS_DIR/shaheen-os.css" <<'CSS'

/* ==========================================================================
   SHAHEEN OS
   Premium Global Design System
   ========================================================================== */

:root {

    --shaheen-black: #050507;
    --shaheen-black-2: #09090d;
    --shaheen-graphite: #111217;
    --shaheen-graphite-2: #17181e;

    --shaheen-white: #ffffff;
    --shaheen-silver: #d9d9dd;
    --shaheen-muted: #8d8e96;

    --shaheen-gold: #d8b85a;
    --shaheen-gold-light: #f5df91;
    --shaheen-gold-dark: #8e6d27;

    --shaheen-border: rgba(255,255,255,.09);
    --shaheen-glass: rgba(255,255,255,.045);

    --shaheen-radius-sm: 10px;
    --shaheen-radius-md: 16px;
    --shaheen-radius-lg: 24px;
    --shaheen-radius-xl: 32px;

    --shaheen-shadow:
        0 25px 80px rgba(0,0,0,.35);

    --shaheen-transition:
        260ms cubic-bezier(.22,.61,.36,1);

    --shaheen-fast:
        160ms cubic-bezier(.22,.61,.36,1);
}

/* ==========================================================================
   GLOBAL
   ========================================================================== */

html {
    scroll-behavior: smooth;
}

body {
    background:
        radial-gradient(
            circle at 15% 10%,
            rgba(216,184,90,.07),
            transparent 28%
        ),
        radial-gradient(
            circle at 85% 20%,
            rgba(255,255,255,.045),
            transparent 25%
        ),
        var(--shaheen-black);

    color: var(--shaheen-white);

    text-rendering: optimizeLegibility;

    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* ==========================================================================
   BRAND
   ========================================================================== */

.shaheen-brand {
    display: inline-flex;
    align-items: center;
    gap: 14px;

    color: #fff;

    text-decoration: none;

    transition:
        transform var(--shaheen-transition),
        opacity var(--shaheen-transition);
}

.shaheen-brand:hover {
    transform: translateY(-1px);
    opacity: .96;
}

.shaheen-brand-logo {
    width: auto;
    height: 42px;

    object-fit: contain;

    filter:
        drop-shadow(0 0 18px rgba(216,184,90,.12));
}

.shaheen-brand-name {
    font-weight: 800;

    letter-spacing: .08em;

    line-height: 1;

    color: #fff;
}

.shaheen-brand-name span {
    color: var(--shaheen-gold);
}

/* ==========================================================================
   PREMIUM NAVIGATION
   ========================================================================== */

.shaheen-nav {
    position: relative;

    background:
        linear-gradient(
            180deg,
            rgba(5,5,7,.94),
            rgba(5,5,7,.78)
        );

    border-bottom:
        1px solid rgba(255,255,255,.07);

    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);

    box-shadow:
        0 15px 50px rgba(0,0,0,.22);

    transition:
        background var(--shaheen-transition),
        border-color var(--shaheen-transition);
}

.shaheen-nav::after {
    content: "";

    position: absolute;

    left: 0;
    right: 0;
    bottom: -1px;

    height: 1px;

    background:
        linear-gradient(
            90deg,
            transparent,
            rgba(216,184,90,.35),
            transparent
        );

    opacity: .65;
}

/* ==========================================================================
   GLASS CARD
   ========================================================================== */

.shaheen-glass {
    background:
        linear-gradient(
            135deg,
            rgba(255,255,255,.075),
            rgba(255,255,255,.025)
        );

    border:
        1px solid var(--shaheen-border);

    box-shadow:
        0 20px 70px rgba(0,0,0,.25);

    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
}

/* ==========================================================================
   BUTTONS
   ========================================================================== */

.shaheen-button {
    position: relative;

    display: inline-flex;

    align-items: center;
    justify-content: center;

    gap: 10px;

    min-height: 46px;

    padding:
        0 20px;

    border-radius:
        999px;

    border:
        1px solid rgba(216,184,90,.45);

    background:
        linear-gradient(
            135deg,
            #e8ca70,
            #b58b35
        );

    color:
        #080808;

    font-weight:
        800;

    text-decoration:
        none;

    overflow:
        hidden;

    box-shadow:
        0 10px 35px rgba(216,184,90,.12);

    transition:
        transform var(--shaheen-transition),
        box-shadow var(--shaheen-transition),
        filter var(--shaheen-transition);
}

.shaheen-button::before {
    content: "";

    position: absolute;

    top: 0;
    bottom: 0;

    left: -120%;

    width: 70%;

    transform: skewX(-20deg);

    background:
        linear-gradient(
            90deg,
            transparent,
            rgba(255,255,255,.45),
            transparent
        );

    transition:
        left 650ms ease;
}

.shaheen-button:hover {
    transform:
        translateY(-2px);

    box-shadow:
        0 16px 50px rgba(216,184,90,.22);

    filter:
        brightness(1.06);
}

.shaheen-button:hover::before {
    left: 150%;
}

/* ==========================================================================
   SECONDARY BUTTON
   ========================================================================== */

.shaheen-button-secondary {
    background:
        rgba(255,255,255,.045);

    border:
        1px solid rgba(255,255,255,.12);

    color:
        #fff;

    box-shadow:
        none;
}

.shaheen-button-secondary:hover {
    background:
        rgba(255,255,255,.08);

    border-color:
        rgba(216,184,90,.35);
}

/* ==========================================================================
   HERO
   ========================================================================== */

.shaheen-hero {
    position: relative;

    isolation: isolate;

    overflow: hidden;

    min-height: 620px;

    display: flex;

    align-items: center;

    background:
        radial-gradient(
            circle at 75% 45%,
            rgba(216,184,90,.12),
            transparent 28%
        ),
        radial-gradient(
            circle at 15% 80%,
            rgba(255,255,255,.04),
            transparent 30%
        ),
        var(--shaheen-black);
}

.shaheen-hero::before {
    content: "";

    position: absolute;

    inset: -30%;

    z-index: -2;

    background:
        conic-gradient(
            from 0deg,
            transparent,
            rgba(216,184,90,.06),
            transparent,
            rgba(255,255,255,.025),
            transparent
        );

    animation:
        shaheen-rotate 24s linear infinite;
}

.shaheen-hero::after {
    content: "";

    position: absolute;

    inset: 0;

    z-index: -1;

    background:
        linear-gradient(
            90deg,
            rgba(5,5,7,.98),
            rgba(5,5,7,.78),
            rgba(5,5,7,.42)
        );
}

.shaheen-hero-title {
    font-weight: 900;

    font-size:
        clamp(42px, 7vw, 96px);

    line-height:
        .92;

    letter-spacing:
        -.045em;

    max-width:
        900px;
}

.shaheen-hero-title strong {
    background:
        linear-gradient(
            110deg,
            #ffffff,
            #d8b85a,
            #ffffff
        );

    background-size:
        220% auto;

    -webkit-background-clip:
        text;

    background-clip:
        text;

    color:
        transparent;

    animation:
        shaheen-shimmer 8s ease-in-out infinite;
}

.shaheen-hero-description {
    max-width:
        680px;

    margin-top:
        24px;

    color:
        var(--shaheen-muted);

    font-size:
        clamp(16px, 2vw, 20px);

    line-height:
        1.75;
}

/* ==========================================================================
   ORBIT
   ========================================================================== */

.shaheen-orbit {
    position:
        absolute;

    width:
        min(620px, 72vw);

    aspect-ratio:
        1;

    right:
        -120px;

    top:
        50%;

    transform:
        translateY(-50%);

    border:
        1px solid rgba(216,184,90,.18);

    border-radius:
        50%;

    animation:
        shaheen-float 8s ease-in-out infinite;
}

.shaheen-orbit::before,
.shaheen-orbit::after {
    content: "";

    position:
        absolute;

    inset:
        12%;

    border:
        1px solid rgba(255,255,255,.08);

    border-radius:
        50%;
}

.shaheen-orbit::after {
    inset:
        28%;

    border-color:
        rgba(216,184,90,.14);
}

/* ==========================================================================
   AUTH
   ========================================================================== */

.shaheen-auth-page {
    min-height:
        100vh;

    display:
        flex;

    align-items:
        center;

    justify-content:
        center;

    padding:
        24px;

    background:
        radial-gradient(
            circle at 50% 0%,
            rgba(216,184,90,.10),
            transparent 35%
        ),
        var(--shaheen-black);
}

.shaheen-auth-card {
    width:
        min(100%, 480px);

    padding:
        clamp(24px, 5vw, 48px);

    border:
        1px solid rgba(255,255,255,.09);

    border-radius:
        30px;

    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.075),
            rgba(255,255,255,.025)
        );

    box-shadow:
        0 40px 100px rgba(0,0,0,.42);

    backdrop-filter:
        blur(28px);

    -webkit-backdrop-filter:
        blur(28px);
}

/* ==========================================================================
   INPUTS
   ========================================================================== */

.shaheen-input {
    width:
        100%;

    min-height:
        48px;

    padding:
        0 16px;

    border:
        1px solid rgba(255,255,255,.10);

    border-radius:
        14px;

    background:
        rgba(255,255,255,.035);

    color:
        #fff;

    outline:
        none;

    transition:
        border-color var(--shaheen-fast),
        background var(--shaheen-fast),
        box-shadow var(--shaheen-fast);
}

.shaheen-input:focus {
    border-color:
        rgba(216,184,90,.65);

    background:
        rgba(255,255,255,.055);

    box-shadow:
        0 0 0 4px rgba(216,184,90,.08);
}

/* ==========================================================================
   ANIMATIONS
   ========================================================================== */

@keyframes shaheen-rotate {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

@keyframes shaheen-shimmer {

    0%,
    100% {
        background-position:
            0% 50%;
    }

    50% {
        background-position:
            100% 50%;
    }
}

@keyframes shaheen-float {

    0%,
    100% {
        transform:
            translateY(-50%)
            translateX(0);
    }

    50% {
        transform:
            translateY(calc(-50% - 18px))
            translateX(-8px);
    }
}

@keyframes shaheen-fade-up {

    from {
        opacity: 0;
        transform:
            translateY(18px);
    }

    to {
        opacity: 1;
        transform:
            translateY(0);
    }
}

.shaheen-animate {
    animation:
        shaheen-fade-up
        700ms
        cubic-bezier(.22,.61,.36,1)
        both;
}

/* ==========================================================================
   ACCESSIBILITY
   ========================================================================== */

@media (prefers-reduced-motion: reduce) {

    *,
    *::before,
    *::after {
        animation-duration:
            0.01ms !important;

        animation-iteration-count:
            1 !important;

        scroll-behavior:
            auto !important;

        transition-duration:
            0.01ms !important;
    }
}

/* ==========================================================================
   TABLET
   ========================================================================== */

@media (max-width: 1024px) {

    .shaheen-hero {
        min-height:
            560px;
    }

    .shaheen-orbit {
        right:
            -220px;

        opacity:
            .55;
    }
}

/* ==========================================================================
   MOBILE
   ========================================================================== */

@media (max-width: 768px) {

    .shaheen-hero {
        min-height:
            auto;

        padding-top:
            100px;

        padding-bottom:
            90px;
    }

    .shaheen-hero::after {
        background:
            linear-gradient(
                180deg,
                rgba(5,5,7,.92),
                rgba(5,5,7,.72)
            );
    }

    .shaheen-orbit {
        width:
            520px;

        right:
            -260px;

        top:
            35%;

        opacity:
            .28;
    }

    .shaheen-brand-logo {
        height:
            36px;
    }

    .shaheen-brand-name {
        font-size:
            14px;
    }

    .shaheen-button {
        width:
            100%;
    }
}

/* ==========================================================================
   SMALL MOBILE
   ========================================================================== */

@media (max-width: 480px) {

    .shaheen-auth-page {
        padding:
            14px;
    }

    .shaheen-auth-card {
        padding:
            22px 18px;

        border-radius:
            24px;
    }

    .shaheen-hero-title {
        font-size:
            clamp(38px, 12vw, 58px);
    }

}

CSS

success "SHAHEEN OS design system created."

###############################################################################
# VITE IMPORT
###############################################################################

log "[6/12] Integrating design system with Vite..."

APP_CSS="$CSS_DIR/app.css"

if [[ -f "$APP_CSS" ]]; then

    if ! grep -q "shaheen-os.css" "$APP_CSS"; then

        cat >> "$APP_CSS" <<'CSS'

/* ==========================================================================
   SHAHEEN OS BRAND SYSTEM
   ========================================================================== */

@import './shaheen-os.css';

CSS

        success "SHAHEEN OS CSS imported into app.css."

    else

        warn "SHAHEEN OS CSS import already exists."

    fi

else

    cat > "$APP_CSS" <<'CSS'

@import './shaheen-os.css';

CSS

    success "Created app.css."

fi

###############################################################################
# BRAND META FILE
###############################################################################

log "[7/12] Creating brand metadata..."

cat > "$BRAND_DIR/brand.json" <<JSON
{
    "name": "SHAHEEN OS",
    "short_name": "SHAHEEN",
    "brand": "SHAHEEN OS",
    "version": "1.0.0",
    "theme": {
        "primary": "#D8B85A",
        "background": "#050507",
        "surface": "#111217",
        "text": "#FFFFFF",
        "muted": "#8D8E96"
    },
    "design": {
        "style": "premium futuristic",
        "responsive": true,
        "motion": true,
        "rtl": true,
        "dark": true
    }
}
JSON

success "Brand metadata created."

###############################################################################
# UPDATE SITE LAYOUT
###############################################################################

log "[8/12] Updating Site layout..."

if [[ -f "$SITE_LAYOUT" ]]; then

    python3 - "$SITE_LAYOUT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])

text = path.read_text()

# Remove old accidental ON naming references.
text = text.replace("SHAHEEN ON", "SHAHEEN OS")
text = text.replace("shaheen-on", "shaheen-os")

# Replace generic fallback values.
text = text.replace(
    "config('app.name', 'OpenClassify')",
    "config('app.name', 'SHAHEEN OS')"
)

text = text.replace(
    "config('app.name', 'SHAHEEN OS')",
    "config('app.name', 'SHAHEEN OS')"
)

# Add SHAHEEN OS classes to body.
text = text.replace(
    '<body',
    '<body class="shaheen-os-app"'
    ' data-shaheen-os="true"'
    ' data-brand="SHAHEEN OS"'
)

# Avoid duplicate class attribute if the layout already has one.
text = text.replace(
    '<body class="shaheen-os-app" data-shaheen-os="true" data-brand="SHAHEEN OS"\n    @class([',
    '<body data-shaheen-os="true" data-brand="SHAHEEN OS"\n    @class(['
)

# Add brand stylesheet after Vite declaration if not already there.
if 'shaheen-os.css' not in text:

    marker = "@vite(['resources/css/app.css', 'resources/js/app.js'])"

    if marker in text:
        text = text.replace(
            marker,
            marker + "\n    <link rel=\"stylesheet\" href=\"{{ asset('build/assets/app.css') }}\">"
        )

path.write_text(text)
PY

    success "Site layout updated."

else
    warn "Site layout not found; skipped."
fi

###############################################################################
# UPDATE AUTH LAYOUT
###############################################################################

log "[9/12] Updating authentication layout..."

if [[ -f "$AUTH_LAYOUT" ]]; then

    python3 - "$AUTH_LAYOUT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])

text = path.read_text()

text = text.replace(
    "config('app.name', 'OpenClassify')",
    "config('app.name', 'SHAHEEN OS')"
)

text = text.replace(
    "SHAHEEN ON",
    "SHAHEEN OS"
)

text = text.replace(
    "shaheen-on",
    "shaheen-os"
)

# Add premium auth class.
text = text.replace(
    '<body class="user-auth-page">',
    '<body class="user-auth-page shaheen-auth-page">'
)

# Upgrade card.
text = text.replace(
    '<div class="user-auth-card">',
    '<div class="user-auth-card shaheen-auth-card shaheen-animate">'
)

# Add brand image when logo exists.
old = '''<span class="brand-logo" aria-hidden="true"></span>'''

new = '''<img
    src="{{ asset('brand/logo/shaheen-os-horizontal.svg') }}"
    alt="{{ $siteName }}"
    class="shaheen-brand-logo"
>'''

text = text.replace(old, new)

path.write_text(text)
PY

    success "Authentication layout updated."

else
    warn "Authentication layout not found; skipped."
fi

###############################################################################
# CREATE SHAHEEN BRAND COMPONENT
###############################################################################

log "[10/12] Creating reusable brand component..."

COMPONENT_DIR="$RESOURCES_DIR/views/components"

mkdir -p "$COMPONENT_DIR"

cat > "$COMPONENT_DIR/shaheen-brand.blade.php" <<'BLADE'
@props([
    'href' => null,
    'compact' => false,
])

@php
    $brandName = config('app.name', 'SHAHEEN OS');
    $brandHref = $href ?: route('home');
@endphp

<a
    href="{{ $brandHref }}"
    {{ $attributes->merge(['class' => 'shaheen-brand']) }}
    aria-label="{{ $brandName }}"
>
    <img
        src="{{ asset('brand/logo/shaheen-os-horizontal.svg') }}"
        alt="{{ $brandName }}"
        class="shaheen-brand-logo"
    >

    @unless($compact)
        <span class="shaheen-brand-name">
            SHAHEEN <span>OS</span>
        </span>
    @endunless
</a>
BLADE

success "Reusable SHAHEEN OS brand component created."

###############################################################################
# CREATE HERO COMPONENT
###############################################################################

log "[11/12] Creating premium hero component..."

cat > "$COMPONENT_DIR/shaheen-hero.blade.php" <<'BLADE'
<section {{ $attributes->merge(['class' => 'shaheen-hero']) }}>

    <div class="shaheen-orbit" aria-hidden="true"></div>

    <div class="relative z-10 mx-auto w-full max-w-7xl px-5 sm:px-8">

        <div class="shaheen-animate max-w-4xl">

            <div class="mb-5 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/[.04] px-4 py-2 text-xs font-bold tracking-[.18em] text-white/70 backdrop-blur-xl">
                <span class="h-2 w-2 rounded-full bg-[#d8b85a] shadow-[0_0_18px_rgba(216,184,90,.65)]"></span>
                SHAHEEN OS
            </div>

            <h1 class="shaheen-hero-title">
                {{ $title ?? 'The next generation of the digital marketplace.' }}
            </h1>

            <p class="shaheen-hero-description">
                {{ $description ?? 'A premium digital ecosystem designed for speed, intelligence, discovery and modern commerce.' }}
            </p>

            <div class="mt-9 flex flex-col gap-3 sm:flex-row">

                <a
                    href="{{ $primaryUrl ?? route('listings.index') }}"
                    class="shaheen-button"
                >
                    {{ $primaryText ?? 'Explore SHAHEEN OS' }}
                </a>

                <a
                    href="{{ $secondaryUrl ?? route('register') }}"
                    class="shaheen-button shaheen-button-secondary"
                >
                    {{ $secondaryText ?? 'Create account' }}
                </a>

            </div>

        </div>

    </div>

</section>
BLADE

success "Premium hero component created."

###############################################################################
# REMOVE OLD ON NAMING FROM PUBLIC BRAND FILES
###############################################################################

log "[12/12] Final SHAHEEN OS cleanup..."

find "$BRAND_DIR" \
    -type f \
    \( -name "*.svg" -o -name "*.json" -o -name "*.txt" \) \
    -print0 2>/dev/null |
while IFS= read -r -d '' file; do

    if grep -q "SHAHEEN ON" "$file" 2>/dev/null; then

        sed -i 's/SHAHEEN ON/SHAHEEN OS/g' "$file"

    fi

    if grep -q "SHAHEEN-ON" "$file" 2>/dev/null; then

        sed -i 's/SHAHEEN-ON/SHAHEEN-OS/g' "$file"

    fi

    if grep -q "shaheen-on" "$file" 2>/dev/null; then

        sed -i 's/shaheen-on/shaheen-os/g' "$file"

    fi

done

###############################################################################
# CLEAR LARAVEL CACHE
###############################################################################

printf "\n"

log "Clearing Laravel caches..."

php artisan optimize:clear

###############################################################################
# VERIFY
###############################################################################

printf "\n"

log "Running SHAHEEN OS verification..."

echo

echo "Project:"
echo "  $PROJECT_NAME"

echo

echo "Brand:"
echo "  $BRAND_DIR"

echo

echo "Logo:"
echo "  $BRAND_LOGO_DIR/shaheen-os-horizontal.svg"

echo

echo "Design System:"
echo "  $CSS_DIR/shaheen-os.css"

echo

echo "Components:"
echo "  $COMPONENT_DIR/shaheen-brand.blade.php"
echo "  $COMPONENT_DIR/shaheen-hero.blade.php"

echo

###############################################################################
# CHECK OLD BRAND IN APPLICATION
###############################################################################

OLD_FOUND=0

if grep -RniF \
    "SHAHEEN ON" \
    Modules \
    resources \
    config \
    public/brand \
    --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=storage \
    2>/dev/null | head -n 20; then

    OLD_FOUND=1

fi

if [[ "$OLD_FOUND" -eq 0 ]]; then
    success "No SHAHEEN ON reference detected in active brand/UI paths."
else
    warn "Some SHAHEEN ON references remain. They will be handled in the next cleanup stage."
fi

###############################################################################
# FINAL
###############################################################################

printf "\n"
printf "%b\n" "${BOLD}${CYAN}==============================================================${RESET}"
printf "%b\n" "${BOLD}${GREEN}              SHAHEEN OS UI BUILD COMPLETE${RESET}"
printf "%b\n" "${BOLD}${CYAN}==============================================================${RESET}"
printf "\n"

echo "Backup:"
echo "  $BACKUP_DIR"

echo

echo "Main logo:"
echo "  $BRAND_LOGO_DIR/shaheen-os-horizontal.svg"

echo

echo "Design system:"
echo "  $CSS_DIR/shaheen-os.css"

echo

echo "Brand component:"
echo "  $COMPONENT_DIR/shaheen-brand.blade.php"

echo

echo "Hero component:"
echo "  $COMPONENT_DIR/shaheen-hero.blade.php"

echo

echo "Project identity:"
echo "  SHAHEEN OS"

echo

printf "%b\n" "${GREEN}✔ SHAHEEN OS branding integration finished.${RESET}"
printf "\n"
