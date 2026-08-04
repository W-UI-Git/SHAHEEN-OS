#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(pwd)"
APP_NAME="SHAHEEN OS"

CSS_DIR="$PROJECT_ROOT/resources/css"
JS_DIR="$PROJECT_ROOT/resources/js"
COMPONENT_DIR="$PROJECT_ROOT/resources/views/components"
BACKUP_ROOT="$PROJECT_ROOT/.shaheen-ui-backups"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

ERRORS=0

printf '\n============================================================\n'
printf '          SHAHEEN OS — GLOBAL COMPONENTS\n'
printf '============================================================\n\n'

###############################################################################
# 1. VALIDATION
###############################################################################

printf '[1/12] Validating project...\n'

if [[ ! -f "$PROJECT_ROOT/artisan" ]]; then
    echo "ERROR: Laravel project not found."
    exit 1
fi

if [[ ! -d "$CSS_DIR" ]]; then
    mkdir -p "$CSS_DIR"
fi

if [[ ! -d "$JS_DIR" ]]; then
    mkdir -p "$JS_DIR"
fi

if [[ ! -d "$COMPONENT_DIR" ]]; then
    mkdir -p "$COMPONENT_DIR"
fi

mkdir -p "$BACKUP_DIR"

###############################################################################
# 2. BACKUP
###############################################################################

printf '[2/12] Creating backup...\n'

for file in \
    "$CSS_DIR/sh aheen-os-components.css" \
    "$JS_DIR/shaheen-os-components.js" \
    "$COMPONENT_DIR/shaheen-components.blade.php"
do
    file="${file//sh aheen/shaheen}"

    if [[ -f "$file" ]]; then
        cp -f "$file" "$BACKUP_DIR/"
    fi
done

printf '✓ Backup created: %s\n' "$BACKUP_DIR"

###############################################################################
# 3. GLOBAL COMPONENT CSS
###############################################################################

printf '[3/12] Installing global component design system...\n'

cat > "$CSS_DIR/shaheen-os-components.css" <<'CSS'
/* ==========================================================================
   SHAHEEN OS
   Global Component Design System
   ========================================================================== */

:root {
    --sh-bg: #050507;
    --sh-bg-soft: #0a0b0f;
    --sh-panel: rgba(255,255,255,.045);
    --sh-panel-strong: rgba(255,255,255,.075);

    --sh-border: rgba(255,255,255,.09);
    --sh-border-strong: rgba(255,255,255,.16);

    --sh-text: #f5f7fa;
    --sh-text-soft: rgba(245,247,250,.72);
    --sh-text-muted: rgba(245,247,250,.48);

    --sh-accent: #e5c158;
    --sh-accent-soft: rgba(229,193,88,.16);
    --sh-accent-glow: rgba(229,193,88,.28);

    --sh-success: #50d890;
    --sh-warning: #f4c95d;
    --sh-danger: #ff6b78;
    --sh-info: #6ea8ff;

    --sh-radius-sm: 10px;
    --sh-radius-md: 16px;
    --sh-radius-lg: 24px;
    --sh-radius-xl: 32px;

    --sh-shadow:
        0 20px 70px rgba(0,0,0,.30);

    --sh-transition:
        280ms cubic-bezier(.22,1,.36,1);
}

/* --------------------------------------------------------------------------
   Base
   -------------------------------------------------------------------------- */

.sh-component,
.sh-card,
.sh-panel,
.sh-section {
    box-sizing: border-box;
}

.sh-component *,
.sh-card *,
.sh-panel *,
.sh-section * {
    box-sizing: border-box;
}

/* --------------------------------------------------------------------------
   Container
   -------------------------------------------------------------------------- */

.sh-container {
    width: min(100% - 32px, 1440px);
    margin-inline: auto;
}

.sh-container-wide {
    width: min(100% - 48px, 1680px);
    margin-inline: auto;
}

/* --------------------------------------------------------------------------
   Section
   -------------------------------------------------------------------------- */

.sh-section {
    position: relative;
    width: 100%;
    padding-block: clamp(56px, 8vw, 120px);
}

.sh-section-compact {
    padding-block: clamp(32px, 5vw, 72px);
}

.sh-section-header {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    gap: 24px;
    margin-bottom: 32px;
}

.sh-section-title {
    margin: 0;
    color: var(--sh-text);
    font-size: clamp(1.6rem, 3vw, 3rem);
    line-height: 1.05;
    letter-spacing: -.035em;
    font-weight: 800;
}

.sh-section-subtitle {
    max-width: 720px;
    margin: 12px 0 0;
    color: var(--sh-text-soft);
    font-size: clamp(.95rem, 1.5vw, 1.12rem);
    line-height: 1.7;
}

/* --------------------------------------------------------------------------
   Glass Card
   -------------------------------------------------------------------------- */

.sh-card {
    position: relative;
    overflow: hidden;

    border: 1px solid var(--sh-border);
    border-radius: var(--sh-radius-lg);

    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.075),
            rgba(255,255,255,.025)
        );

    box-shadow: var(--sh-shadow);

    backdrop-filter: blur(22px);
    -webkit-backdrop-filter: blur(22px);

    transition:
        transform var(--sh-transition),
        border-color var(--sh-transition),
        background var(--sh-transition),
        box-shadow var(--sh-transition);
}

.sh-card::before {
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
}

.sh-card:hover {
    transform: translateY(-5px);
    border-color: var(--sh-border-strong);

    box-shadow:
        0 28px 90px rgba(0,0,0,.40),
        0 0 0 1px rgba(229,193,88,.035);
}

.sh-card-body {
    position: relative;
    z-index: 1;
    padding: clamp(20px, 3vw, 32px);
}

/* --------------------------------------------------------------------------
   Card Grid
   -------------------------------------------------------------------------- */

.sh-grid {
    display: grid;
    gap: clamp(16px, 2vw, 28px);
}

.sh-grid-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
}

.sh-grid-3 {
    grid-template-columns: repeat(3, minmax(0, 1fr));
}

.sh-grid-4 {
    grid-template-columns: repeat(4, minmax(0, 1fr));
}

/* --------------------------------------------------------------------------
   Icon
   -------------------------------------------------------------------------- */

.sh-icon-box {
    width: 48px;
    height: 48px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    border-radius: 14px;
    border: 1px solid var(--sh-border);

    background:
        linear-gradient(
            145deg,
            rgba(229,193,88,.16),
            rgba(255,255,255,.035)
        );

    color: var(--sh-accent);

    box-shadow:
        inset 0 1px 0 rgba(255,255,255,.08),
        0 12px 30px rgba(0,0,0,.20);
}

.sh-icon-box-lg {
    width: 64px;
    height: 64px;
    border-radius: 18px;
}

/* --------------------------------------------------------------------------
   Badge
   -------------------------------------------------------------------------- */

.sh-badge {
    display: inline-flex;
    align-items: center;
    gap: 7px;

    min-height: 30px;
    padding: 6px 11px;

    border: 1px solid var(--sh-border);
    border-radius: 999px;

    background: rgba(255,255,255,.04);

    color: var(--sh-text-soft);

    font-size: .78rem;
    font-weight: 700;
    letter-spacing: .02em;
}

.sh-badge-accent {
    border-color: rgba(229,193,88,.28);
    background: var(--sh-accent-soft);
    color: var(--sh-accent);
}

.sh-badge-success {
    border-color: rgba(80,216,144,.25);
    background: rgba(80,216,144,.10);
    color: var(--sh-success);
}

/* --------------------------------------------------------------------------
   Buttons
   -------------------------------------------------------------------------- */

.sh-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;

    min-height: 46px;
    padding: 0 18px;

    border: 1px solid var(--sh-border);
    border-radius: 14px;

    background: rgba(255,255,255,.045);

    color: var(--sh-text);

    font: inherit;
    font-size: .92rem;
    font-weight: 750;

    text-decoration: none;

    cursor: pointer;

    transition:
        transform var(--sh-transition),
        background var(--sh-transition),
        border-color var(--sh-transition),
        box-shadow var(--sh-transition);
}

.sh-btn:hover {
    transform: translateY(-2px);
    border-color: var(--sh-border-strong);
    background: rgba(255,255,255,.075);
}

.sh-btn-primary {
    border-color: rgba(229,193,88,.38);

    background:
        linear-gradient(
            135deg,
            #e5c158,
            #b99436
        );

    color: #090909;

    box-shadow:
        0 12px 34px rgba(229,193,88,.18);
}

.sh-btn-primary:hover {
    box-shadow:
        0 18px 48px rgba(229,193,88,.28);
}

/* --------------------------------------------------------------------------
   Divider
   -------------------------------------------------------------------------- */

.sh-divider {
    width: 100%;
    height: 1px;

    background:
        linear-gradient(
            90deg,
            transparent,
            var(--sh-border-strong),
            transparent
        );
}

/* --------------------------------------------------------------------------
   Status
   -------------------------------------------------------------------------- */

.sh-status {
    display: inline-flex;
    align-items: center;
    gap: 8px;

    color: var(--sh-text-soft);

    font-size: .82rem;
    font-weight: 650;
}

.sh-status-dot {
    width: 8px;
    height: 8px;

    border-radius: 50%;

    background: var(--sh-success);

    box-shadow:
        0 0 0 4px rgba(80,216,144,.10),
        0 0 20px rgba(80,216,144,.35);
}

.sh-status-dot.warning {
    background: var(--sh-warning);
}

.sh-status-dot.danger {
    background: var(--sh-danger);
}

/* --------------------------------------------------------------------------
   Brand Marker
   -------------------------------------------------------------------------- */

.sh-brand-marker {
    display: inline-flex;
    align-items: center;
    gap: 10px;

    color: var(--sh-text);

    text-decoration: none;
    font-weight: 850;
    letter-spacing: -.025em;
}

.sh-brand-marker::before {
    content: "";

    width: 9px;
    height: 9px;

    border-radius: 50%;

    background: var(--sh-accent);

    box-shadow:
        0 0 0 5px rgba(229,193,88,.09),
        0 0 24px rgba(229,193,88,.35);
}

/* --------------------------------------------------------------------------
   Empty State
   -------------------------------------------------------------------------- */

.sh-empty {
    min-height: 220px;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    padding: 32px;

    text-align: center;

    border: 1px dashed var(--sh-border-strong);
    border-radius: var(--sh-radius-lg);

    background: rgba(255,255,255,.018);
}

.sh-empty-title {
    margin: 16px 0 7px;

    color: var(--sh-text);

    font-size: 1.05rem;
    font-weight: 800;
}

.sh-empty-text {
    max-width: 520px;

    margin: 0;

    color: var(--sh-text-muted);

    line-height: 1.65;
}

/* --------------------------------------------------------------------------
   Responsive
   -------------------------------------------------------------------------- */

@media (max-width: 1100px) {
    .sh-grid-4 {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .sh-grid-3 {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 760px) {
    .sh-container {
        width: min(100% - 24px, 1440px);
    }

    .sh-container-wide {
        width: min(100% - 24px, 1680px);
    }

    .sh-section {
        padding-block: 48px;
    }

    .sh-section-header {
        align-items: flex-start;
        flex-direction: column;
    }

    .sh-grid-2,
    .sh-grid-3,
    .sh-grid-4 {
        grid-template-columns: 1fr;
    }

    .sh-card {
        border-radius: 20px;
    }

    .sh-btn {
        width: 100%;
    }
}

/* --------------------------------------------------------------------------
   RTL
   -------------------------------------------------------------------------- */

[dir="rtl"] .sh-section-header {
    text-align: right;
}

[dir="ltr"] .sh-section-header {
    text-align: left;
}

/* --------------------------------------------------------------------------
   Accessibility
   -------------------------------------------------------------------------- */

.sh-btn:focus-visible,
.sh-card:focus-visible,
.sh-brand-marker:focus-visible {
    outline: 2px solid var(--sh-accent);
    outline-offset: 4px;
}

/* --------------------------------------------------------------------------
   Reduced Motion
   -------------------------------------------------------------------------- */

@media (prefers-reduced-motion: reduce) {
    .sh-card,
    .sh-btn {
        transition: none !important;
    }

    .sh-card:hover,
    .sh-btn:hover {
        transform: none !important;
    }
}
CSS

printf '✓ Global component CSS installed.\n'

###############################################################################
# 4. GLOBAL COMPONENT JS
###############################################################################

printf '[4/12] Installing component interaction system...\n'

cat > "$JS_DIR/shaheen-os-components.js" <<'JS'
/**
 * SHAHEEN OS
 * Global Components Interaction Layer
 */

(function () {
    'use strict';

    const SHAHEEN = window.SHAHEEN || {};

    SHAHEEN.components = {
        initialized: false,

        init() {
            if (this.initialized) {
                return;
            }

            this.bindButtons();
            this.bindCards();
            this.bindKeyboard();

            this.initialized = true;

            document.documentElement.setAttribute(
                'data-shaheen-components',
                'ready'
            );
        },

        bindButtons() {
            document.addEventListener('click', (event) => {
                const button = event.target.closest('[data-sh-button]');

                if (!button) {
                    return;
                }

                if (
                    window.matchMedia &&
                    window.matchMedia(
                        '(prefers-reduced-motion: reduce)'
                    ).matches
                ) {
                    return;
                }

                button.animate(
                    [
                        {
                            transform: 'scale(1)'
                        },
                        {
                            transform: 'scale(.97)'
                        },
                        {
                            transform: 'scale(1)'
                        }
                    ],
                    {
                        duration: 180,
                        easing: 'cubic-bezier(.22,1,.36,1)'
                    }
                );
            });
        },

        bindCards() {
            document.addEventListener('pointermove', (event) => {
                const card = event.target.closest(
                    '[data-sh-card-tilt]'
                );

                if (!card) {
                    return;
                }

                if (
                    window.matchMedia &&
                    window.matchMedia(
                        '(prefers-reduced-motion: reduce)'
                    ).matches
                ) {
                    return;
                }

                const rect = card.getBoundingClientRect();

                const x =
                    (event.clientX - rect.left) /
                    rect.width;

                const y =
                    (event.clientY - rect.top) /
                    rect.height;

                const rotateX = (0.5 - y) * 2;
                const rotateY = (x - 0.5) * 2;

                card.style.transform =
                    `perspective(900px) ` +
                    `rotateX(${rotateX}deg) ` +
                    `rotateY(${rotateY}deg) ` +
                    `translateY(-3px)`;
            });

            document.addEventListener('pointerleave', () => {
                document
                    .querySelectorAll('[data-sh-card-tilt]')
                    .forEach((card) => {
                        card.style.transform = '';
                    });
            }, true);
        },

        bindKeyboard() {
            document.addEventListener('keydown', (event) => {
                if (
                    (event.ctrlKey || event.metaKey) &&
                    event.key.toLowerCase() === 'k'
                ) {
                    const target =
                        document.querySelector(
                            '[data-sh-command]'
                        );

                    if (target) {
                        event.preventDefault();
                        target.focus();
                    }
                }
            });
        }
    };

    window.SHAHEEN = SHAHEEN;

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            () => SHAHEEN.components.init()
        );
    } else {
        SHAHEEN.components.init();
    }
})();
JS

printf '✓ Component JavaScript installed.\n'

###############################################################################
# 5. REUSABLE BLADE COMPONENT
###############################################################################

printf '[5/12] Creating reusable Blade component...\n'

cat > "$COMPONENT_DIR/shaheen-components.blade.php" <<'BLADE'
{{-- =========================================================================
     SHAHEEN OS
     Global reusable components
     ========================================================================= --}}

@props([
    'title' => null,
    'subtitle' => null,
    'badge' => null,
    'action' => null,
])

<section {{ $attributes->merge(['class' => 'sh-section']) }}>

    <div class="sh-container">

        @if($title || $subtitle || $badge || $action)

            <div class="sh-section-header">

                <div>

                    @if($badge)
                        <span class="sh-badge sh-badge-accent">
                            {{ $badge }}
                        </span>
                    @endif

                    @if($title)
                        <h2 class="sh-section-title">
                            {{ $title }}
                        </h2>
                    @endif

                    @if($subtitle)
                        <p class="sh-section-subtitle">
                            {{ $subtitle }}
                        </p>
                    @endif

                </div>

                @if($action)
                    <div>
                        {!! $action !!}
                    </div>
                @endif

            </div>

        @endif

        {{ $slot }}

    </div>

</section>
BLADE

printf '✓ Blade component created.\n'

###############################################################################
# 6. REGISTER CSS
###############################################################################

printf '[6/12] Registering component CSS...\n'

APP_CSS="$CSS_DIR/app.css"

if [[ -f "$APP_CSS" ]]; then

    if ! grep -qF "@import './shaheen-os-components.css';" "$APP_CSS"; then

        TMP_FILE="$(mktemp)"

        {
            printf "@import './shaheen-os-components.css';\n"
            cat "$APP_CSS"
        } > "$TMP_FILE"

        mv "$TMP_FILE" "$APP_CSS"

    fi

fi

printf '✓ Component CSS registered.\n'

###############################################################################
# 7. REGISTER JS
###############################################################################

printf '[7/12] Registering component JavaScript...\n'

APP_JS="$JS_DIR/app.js"

if [[ -f "$APP_JS" ]]; then

    if ! grep -qF "shaheen-os-components.js" "$APP_JS"; then

        printf "\nimport './shaheen-os-components.js';\n" >> "$APP_JS"

    fi

else

    cat > "$APP_JS" <<'JS'
import './shaheen-os-components.js';
JS

fi

printf '✓ Component JavaScript registered.\n'

###############################################################################
# 8. CREATE COMPONENT MANIFEST
###############################################################################

printf '[8/12] Creating component manifest...\n'

cat > "$PROJECT_ROOT/public/brand/shaheen-components.json" <<'JSON'
{
    "brand": "SHAHEEN OS",
    "version": "1.0.0",
    "system": "global-components",
    "components": [
        "section",
        "container",
        "card",
        "grid",
        "icon-box",
        "badge",
        "button",
        "divider",
        "status",
        "brand-marker",
        "empty-state"
    ],
    "responsive": true,
    "rtl": true,
    "ltr": true,
    "reduced_motion": true,
    "accessibility": true
}
JSON

printf '✓ Component manifest created.\n'

###############################################################################
# 9. VALIDATE FILES
###############################################################################

printf '[9/12] Verifying SHAHEEN OS components...\n'

for file in \
    "$CSS_DIR/shaheen-os-components.css" \
    "$JS_DIR/shaheen-os-components.js" \
    "$COMPONENT_DIR/shaheen-components.blade.php" \
    "$PROJECT_ROOT/public/brand/shaheen-components.json"
do
    if [[ -f "$file" ]]; then
        printf '✓ %s\n' "$file"
    else
        printf '✗ MISSING: %s\n' "$file"
        ERRORS=$((ERRORS + 1))
    fi
done

###############################################################################
# 10. JAVASCRIPT CHECK
###############################################################################

printf '[10/12] Checking JavaScript...\n'

if command -v node >/dev/null 2>&1; then

    if node --check "$JS_DIR/shaheen-os-components.js"; then
        printf '✓ JavaScript syntax verified.\n'
    else
        printf '✗ JavaScript syntax error.\n'
        ERRORS=$((ERRORS + 1))
    fi

else

    printf '⚠ Node.js not available; JavaScript syntax check skipped.\n'

fi

###############################################################################
# 11. LARAVEL CACHE
###############################################################################

printf '[11/12] Rebuilding Laravel cache...\n'

php artisan optimize:clear

php artisan optimize

printf '✓ Laravel cache rebuilt.\n'

###############################################################################
# 12. FINAL VERIFICATION
###############################################################################

printf '[12/12] Final SHAHEEN OS verification...\n'

if grep -RIn \
    --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=build \
    --exclude-dir=.git \
    'SHAHEEN ON' \
    "$PROJECT_ROOT/public/brand" \
    >/dev/null 2>&1
then

    printf '⚠ SHAHEEN ON references found in public/brand.\n'

else

    printf '✓ No SHAHEEN ON references found in public/brand.\n'

fi

if [[ "$ERRORS" -eq 0 ]]; then

    printf '\n============================================================\n'
    printf '          SHAHEEN OS GLOBAL COMPONENTS COMPLETE\n'
    printf '============================================================\n\n'

    printf 'Project:\n'
    printf '  SHAHEEN OS\n\n'

    printf 'Component CSS:\n'
    printf '  %s\n\n' "$CSS_DIR/shaheen-os-components.css"

    printf 'Component JS:\n'
    printf '  %s\n\n' "$JS_DIR/shaheen-os-components.js"

    printf 'Blade Component:\n'
    printf '  %s\n\n' "$COMPONENT_DIR/shaheen-components.blade.php"

    printf 'Manifest:\n'
    printf '  %s\n\n' "$PROJECT_ROOT/public/brand/shaheen-components.json"

    printf 'Backup:\n'
    printf '  %s\n\n' "$BACKUP_DIR"

    printf '✓ Premium cards installed.\n'
    printf '✓ Premium buttons installed.\n'
    printf '✓ Global badges installed.\n'
    printf '✓ Status components installed.\n'
    printf '✓ Responsive grids installed.\n'
    printf '✓ RTL/LTR support installed.\n'
    printf '✓ Accessibility states installed.\n'
    printf '✓ Reduced-motion support installed.\n'
    printf '✓ Component interaction system installed.\n'
    printf '✓ Laravel cache rebuilt.\n\n'

    printf 'Next stage can start.\n\n'

else

    printf '\n============================================================\n'
    printf '          SHAHEEN OS GLOBAL COMPONENTS FAILED\n'
    printf '============================================================\n\n'

    printf 'Errors: %s\n' "$ERRORS"
    printf 'Backup: %s\n\n' "$BACKUP_DIR"

    exit 1

fi
