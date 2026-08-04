#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

PROJECT_NAME="SHAHEEN OS"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$PROJECT_DIR/.shaheen-ui-backups/$TIMESTAMP"
CSS_FILE="$PROJECT_DIR/resources/css/shah​een-os.css"
APP_CSS="$PROJECT_DIR/resources/css/app.css"
JS_FILE="$PROJECT_DIR/resources/js/app.js"
MOTION_CSS="$PROJECT_DIR/resources/css/shaheen-os-motion.css"
MOTION_JS="$PROJECT_DIR/resources/js/shaheen-os-motion.js"

printf '\n'
printf '%s\n' '============================================================'
printf '%s\n' '          SHAHEEN OS — MOTION & INTERACTION UI'
printf '%s\n' '============================================================'
printf '\n'

###############################################################################
# 01 — VALIDATION
###############################################################################

echo "[1/10] Validating project..."

if [[ ! -f "artisan" ]]; then
    echo "ERROR: Laravel project not found."
    exit 1
fi

if [[ ! -d "resources/css" ]]; then
    echo "ERROR: resources/css directory not found."
    exit 1
fi

if [[ ! -d "resources/js" ]]; then
    echo "ERROR: resources/js directory not found."
    exit 1
fi

###############################################################################
# 02 — BACKUP
###############################################################################

echo "[2/10] Creating backup..."

mkdir -p "$BACKUP_DIR"

cp -a resources/css "$BACKUP_DIR/css" 2>/dev/null || true
cp -a resources/js "$BACKUP_DIR/js" 2>/dev/null || true

echo "Backup:"
echo "  $BACKUP_DIR"

###############################################################################
# 03 — MOTION CSS
###############################################################################

echo "[3/10] Installing SHAHEEN OS motion system..."

cat > "$MOTION_CSS" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Motion System
|--------------------------------------------------------------------------
*/

:root {
    --shaheen-motion-fast: 140ms;
    --shaheen-motion-normal: 260ms;
    --shaheen-motion-smooth: 420ms;
    --shaheen-motion-slow: 700ms;

    --shaheen-ease:
        cubic-bezier(0.22, 1, 0.36, 1);

    --shaheen-ease-soft:
        cubic-bezier(0.16, 1, 0.3, 1);

    --shaheen-ease-spring:
        cubic-bezier(0.34, 1.56, 0.64, 1);
}

/*
|--------------------------------------------------------------------------
| Global interaction
|--------------------------------------------------------------------------
*/

.shaheen-motion,
.shaheen-motion * {
    transition-timing-function: var(--shaheen-ease);
}

.shaheen-interactive {
    transition:
        transform var(--shaheen-motion-normal) var(--shaheen-ease),
        opacity var(--shaheen-motion-normal) var(--shaheen-ease),
        filter var(--shaheen-motion-normal) var(--shaheen-ease),
        box-shadow var(--shaheen-motion-normal) var(--shaheen-ease),
        border-color var(--shaheen-motion-normal) var(--shaheen-ease),
        background-color var(--shaheen-motion-normal) var(--shaheen-ease);
}

.shaheen-interactive:hover {
    transform: translateY(-2px);
}

.shaheen-interactive:active {
    transform: translateY(0) scale(0.985);
}

/*
|--------------------------------------------------------------------------
| Reveal
|--------------------------------------------------------------------------
*/

.shaheen-reveal {
    opacity: 0;
    transform: translateY(22px);
    transition:
        opacity var(--shaheen-motion-smooth) var(--shaheen-ease-soft),
        transform var(--shaheen-motion-smooth) var(--shaheen-ease-soft);
}

.shaheen-reveal.is-visible {
    opacity: 1;
    transform: translateY(0);
}

/*
|--------------------------------------------------------------------------
| Scale reveal
|--------------------------------------------------------------------------
*/

.shaheen-scale-reveal {
    opacity: 0;
    transform: scale(0.965);
    transition:
        opacity var(--shaheen-motion-smooth) var(--shaheen-ease-soft),
        transform var(--shaheen-motion-smooth) var(--shaheen-ease-soft);
}

.shaheen-scale-reveal.is-visible {
    opacity: 1;
    transform: scale(1);
}

/*
|--------------------------------------------------------------------------
| Fade
|--------------------------------------------------------------------------
*/

.shaheen-fade {
    opacity: 0;
    transition:
        opacity var(--shaheen-motion-smooth) var(--shaheen-ease-soft);
}

.shaheen-fade.is-visible {
    opacity: 1;
}

/*
|--------------------------------------------------------------------------
| Stagger
|--------------------------------------------------------------------------
*/

.shaheen-stagger > * {
    opacity: 0;
    transform: translateY(16px);
    transition:
        opacity var(--shaheen-motion-smooth) var(--shaheen-ease-soft),
        transform var(--shaheen-motion-smooth) var(--shaheen-ease-soft);
}

.shaheen-stagger.is-visible > * {
    opacity: 1;
    transform: translateY(0);
}

.shaheen-stagger.is-visible > *:nth-child(1) {
    transition-delay: 40ms;
}

.shaheen-stagger.is-visible > *:nth-child(2) {
    transition-delay: 80ms;
}

.shaheen-stagger.is-visible > *:nth-child(3) {
    transition-delay: 120ms;
}

.shaheen-stagger.is-visible > *:nth-child(4) {
    transition-delay: 160ms;
}

.shaheen-stagger.is-visible > *:nth-child(5) {
    transition-delay: 200ms;
}

.shaheen-stagger.is-visible > *:nth-child(6) {
    transition-delay: 240ms;
}

.shaheen-stagger.is-visible > *:nth-child(7) {
    transition-delay: 280ms;
}

.shaheen-stagger.is-visible > *:nth-child(8) {
    transition-delay: 320ms;
}

/*
|--------------------------------------------------------------------------
| Floating
|--------------------------------------------------------------------------
*/

@keyframes shaheenFloat {
    0%,
    100% {
        transform: translate3d(0, 0, 0);
    }

    50% {
        transform: translate3d(0, -8px, 0);
    }
}

.shaheen-floating {
    animation:
        shaheenFloat 5s var(--shaheen-ease-soft) infinite;
}

/*
|--------------------------------------------------------------------------
| Glow pulse
|--------------------------------------------------------------------------
*/

@keyframes shaheenGlow {
    0%,
    100% {
        opacity: 0.65;
    }

    50% {
        opacity: 1;
    }
}

.shaheen-glow {
    animation:
        shaheenGlow 3s ease-in-out infinite;
}

/*
|--------------------------------------------------------------------------
| Shimmer
|--------------------------------------------------------------------------
*/

@keyframes shaheenShimmer {
    0% {
        background-position: -200% 0;
    }

    100% {
        background-position: 200% 0;
    }
}

.shaheen-shimmer {
    background-size: 200% 100%;
    animation:
        shaheenShimmer 2.8s linear infinite;
}

/*
|--------------------------------------------------------------------------
| Hero entrance
|--------------------------------------------------------------------------
*/

@keyframes shaheenHeroIn {
    from {
        opacity: 0;
        transform:
            translate3d(0, 30px, 0)
            scale(0.985);
    }

    to {
        opacity: 1;
        transform:
            translate3d(0, 0, 0)
            scale(1);
    }
}

.shaheen-hero-enter {
    animation:
        shaheenHeroIn
        800ms
        var(--shaheen-ease-soft)
        both;
}

/*
|--------------------------------------------------------------------------
| Navigation
|--------------------------------------------------------------------------
*/

.shaheen-nav-transition {
    transition:
        background-color var(--shaheen-motion-normal) var(--shaheen-ease),
        box-shadow var(--shaheen-motion-normal) var(--shaheen-ease),
        backdrop-filter var(--shaheen-motion-normal) var(--shaheen-ease),
        transform var(--shaheen-motion-normal) var(--shaheen-ease);
}

/*
|--------------------------------------------------------------------------
| Button interaction
|--------------------------------------------------------------------------
*/

.shaheen-button {
    position: relative;
    overflow: hidden;

    transition:
        transform var(--shaheen-motion-fast) var(--shaheen-ease-spring),
        box-shadow var(--shaheen-motion-normal) var(--shaheen-ease),
        filter var(--shaheen-motion-normal) var(--shaheen-ease);
}

.shaheen-button:hover {
    transform: translateY(-2px);
}

.shaheen-button:active {
    transform: scale(0.965);
}

.shaheen-button::after {
    content: "";
    position: absolute;
    inset: 0;

    transform:
        translateX(-120%);

    background:
        linear-gradient(
            90deg,
            transparent,
            rgba(255, 255, 255, 0.16),
            transparent
        );

    transition:
        transform 650ms var(--shaheen-ease);
}

.shaheen-button:hover::after {
    transform:
        translateX(120%);
}

/*
|--------------------------------------------------------------------------
| Cards
|--------------------------------------------------------------------------
*/

.shaheen-card {
    transition:
        transform var(--shaheen-motion-normal) var(--shaheen-ease),
        box-shadow var(--shaheen-motion-normal) var(--shaheen-ease),
        border-color var(--shaheen-motion-normal) var(--shaheen-ease);
}

.shaheen-card:hover {
    transform: translateY(-4px);
}

/*
|--------------------------------------------------------------------------
| Image hover
|--------------------------------------------------------------------------
*/

.shaheen-image-motion {
    overflow: hidden;
}

.shaheen-image-motion img {
    transition:
        transform 700ms var(--shaheen-ease-soft),
        filter 700ms var(--shaheen-ease-soft);
}

.shaheen-image-motion:hover img {
    transform: scale(1.035);
}

/*
|--------------------------------------------------------------------------
| Loading
|--------------------------------------------------------------------------
*/

@keyframes shaheenPulse {
    0%,
    100% {
        opacity: 0.45;
        transform: scale(0.96);
    }

    50% {
        opacity: 1;
        transform: scale(1);
    }
}

.shaheen-loading-pulse {
    animation:
        shaheenPulse 1.5s ease-in-out infinite;
}

/*
|--------------------------------------------------------------------------
| Reduced motion
|--------------------------------------------------------------------------
*/

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        scroll-behavior: auto !important;
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }

    .shaheen-reveal,
    .shaheen-scale-reveal,
    .shaheen-fade,
    .shaheen-stagger > * {
        opacity: 1 !important;
        transform: none !important;
    }
}

/*
|--------------------------------------------------------------------------
| Mobile optimization
|--------------------------------------------------------------------------
*/

@media (max-width: 767px) {
    .shaheen-interactive:hover,
    .shaheen-card:hover,
    .shaheen-button:hover {
        transform: none;
    }

    .shaheen-floating {
        animation-duration: 7s;
    }
}
CSS

###############################################################################
# 04 — MOTION JS
###############################################################################

echo "[4/10] Installing motion controller..."

cat > "$MOTION_JS" <<'JS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Motion Controller
|--------------------------------------------------------------------------
*/

(() => {
    'use strict';

    const reducedMotion = window.matchMedia(
        '(prefers-reduced-motion: reduce)'
    );

    const revealElements = () => {
        const elements = document.querySelectorAll(
            '.shaheen-reveal, .shaheen-scale-reveal, .shaheen-fade, .shaheen-stagger'
        );

        if (!elements.length) {
            return;
        }

        if (reducedMotion.matches) {
            elements.forEach((element) => {
                element.classList.add('is-visible');
            });

            return;
        }

        if (!('IntersectionObserver' in window)) {
            elements.forEach((element) => {
                element.classList.add('is-visible');
            });

            return;
        }

        const observer = new IntersectionObserver(
            (entries, instance) => {
                entries.forEach((entry) => {
                    if (!entry.isIntersecting) {
                        return;
                    }

                    entry.target.classList.add('is-visible');

                    instance.unobserve(entry.target);
                });
            },
            {
                root: null,
                rootMargin: '0px 0px -8% 0px',
                threshold: 0.08,
            }
        );

        elements.forEach((element) => {
            observer.observe(element);
        });
    };

    const initNavigation = () => {
        const navigation = document.querySelector(
            '.market-nav-surface, nav'
        );

        if (!navigation) {
            return;
        }

        const update = () => {
            if (window.scrollY > 16) {
                navigation.classList.add(
                    'shaheen-nav-scrolled'
                );
            } else {
                navigation.classList.remove(
                    'shaheen-nav-scrolled'
                );
            }
        };

        update();

        window.addEventListener(
            'scroll',
            update,
            {
                passive: true,
            }
        );
    };

    const initButtons = () => {
        document
            .querySelectorAll(
                'button, a[type="button"], .btn'
            )
            .forEach((element) => {
                element.classList.add(
                    'shaheen-interactive'
                );
            });
    };

    const initCards = () => {
        document
            .querySelectorAll(
                '.card, [class*="card"]'
            )
            .forEach((element) => {
                if (!element.classList.contains(
                    'shaheen-card'
                )) {
                    return;
                }
            });
    };

    const init = () => {
        document.documentElement.classList.add(
            'shaheen-motion'
        );

        revealElements();
        initNavigation();
        initButtons();
        initCards();
    };

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            init,
            {
                once: true,
            }
        );
    } else {
        init();
    }
})();
JS

###############################################################################
# 05 — REGISTER CSS
###############################################################################

echo "[5/10] Registering motion stylesheet..."

if [[ -f "$APP_CSS" ]]; then

    if ! grep -qF "shaheen-os-motion.css" "$APP_CSS"; then
        printf '\n@import "./shaheen-os-motion.css";\n' >> "$APP_CSS"
    fi

else
    cat > "$APP_CSS" <<'CSS'
@import "./shaheen-os.css";
@import "./shaheen-os-motion.css";
CSS
fi

###############################################################################
# 06 — REGISTER JS
###############################################################################

echo "[6/10] Registering motion JavaScript..."

if [[ -f "$JS_FILE" ]]; then

    if ! grep -qF "shaheen-os-motion" "$JS_FILE"; then
        cat >> "$JS_FILE" <<'JS'

/*
|--------------------------------------------------------------------------
| SHAHEEN OS Motion System
|--------------------------------------------------------------------------
*/

import './shaheen-os-motion.js';
JS
    fi

else
    cat > "$JS_FILE" <<'JS'
import './shaheen-os-motion.js';
JS
fi

###############################################################################
# 07 — BLADE COMPONENT
###############################################################################

echo "[7/10] Creating reusable motion component..."

mkdir -p resources/views/components

cat > resources/views/components/shaheen-motion.blade.php <<'BLADE'
@props([
    'type' => 'reveal',
    'class' => '',
])

@php
    $allowed = [
        'reveal' => 'shaheen-reveal',
        'scale' => 'shaheen-scale-reveal',
        'fade' => 'shaheen-fade',
        'stagger' => 'shaheen-stagger',
    ];

    $motionClass = $allowed[$type] ?? $allowed['reveal'];
@endphp

<div {{ $attributes->merge([
    'class' => trim($motionClass . ' ' . $class),
]) }}>
    {{ $slot }}
</div>
BLADE

###############################################################################
# 08 — HERO MOTION ENHANCEMENT
###############################################################################

echo "[8/10] Enhancing SHAHEEN OS hero motion..."

HERO_FILE="resources/views/components/shaheen-hero.blade.php"

if [[ -f "$HERO_FILE" ]]; then

    if ! grep -qF "shaheen-hero-enter" "$HERO_FILE"; then
        sed -i 's/<section/<section class="shaheen-hero-enter"/' "$HERO_FILE" 2>/dev/null || true
    fi

fi

###############################################################################
# 09 — LARAVEL CACHE
###############################################################################

echo "[9/10] Rebuilding Laravel cache..."

php artisan optimize:clear

php artisan optimize

###############################################################################
# 10 — VERIFICATION
###############################################################################

echo "[10/10] Verifying SHAHEEN OS motion system..."

ERRORS=0

check_file() {
    local file="$1"

    if [[ -f "$file" ]]; then
        echo "✓ $file"
    else
        echo "✗ Missing: $file"
        ERRORS=$((ERRORS + 1))
    fi
}

check_file "$MOTION_CSS"
check_file "$MOTION_JS"
check_file "resources/views/components/shaheen-motion.blade.php"

if grep -qF "shaheen-os-motion.css" "$APP_CSS"; then
    echo "✓ Motion CSS registered"
else
    echo "✗ Motion CSS registration missing"
    ERRORS=$((ERRORS + 1))
fi

if grep -qF "shaheen-os-motion.js" "$JS_FILE"; then
    echo "✓ Motion JS registered"
else
    echo "✗ Motion JS registration missing"
    ERRORS=$((ERRORS + 1))
fi

if grep -RniF "SHAHEEN ON" \
    resources/css \
    resources/js \
    resources/views/components \
    2>/dev/null | head -n 1 | grep -q .; then

    echo "⚠ Old SHAHEEN ON reference detected."
    ERRORS=$((ERRORS + 1))

else

    echo "✓ No SHAHEEN ON references found in motion integration."

fi

###############################################################################
# RESULT
###############################################################################

echo
printf '%s\n' '============================================================'

if [[ "$ERRORS" -eq 0 ]]; then

    printf '%s\n' '          SHAHEEN OS MOTION UI COMPLETE'
    printf '%s\n' '============================================================'
    echo
    echo "Project:"
    echo "  SHAHEEN OS"
    echo
    echo "Motion CSS:"
    echo "  $MOTION_CSS"
    echo
    echo "Motion JS:"
    echo "  $MOTION_JS"
    echo
    echo "Reusable Blade component:"
    echo "  resources/views/components/shaheen-motion.blade.php"
    echo
    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo
    echo "✓ Smooth transitions installed."
    echo "✓ Scroll reveal system installed."
    echo "✓ Stagger animation system installed."
    echo "✓ Hero entrance animation installed."
    echo "✓ Button interaction system installed."
    echo "✓ Card interaction system installed."
    echo "✓ Image motion system installed."
    echo "✓ Reduced-motion support installed."
    echo "✓ Mobile motion optimization installed."
    echo "✓ Laravel cache rebuilt."
    echo
    echo "Next stage can start."

else

    printf '%s\n' '          SHAHEEN OS MOTION UI FAILED'
    printf '%s\n' '============================================================'
    echo
    echo "Errors: $ERRORS"
    echo "Backup:"
    echo "  $BACKUP_DIR"
    exit 1

fi

