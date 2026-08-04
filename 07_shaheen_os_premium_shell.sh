#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_DIR="$HOME/sooq-app"
PROJECT_NAME="SHAHEEN OS"

cd "$PROJECT_DIR"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$PROJECT_DIR/.shaheen-ui-backups/$TIMESTAMP"

CSS_FILE="resources/css/shaheen-os-shell.css"
JS_FILE="resources/js/shaheen-os-shell.js"
BLADE_FILE="resources/views/components/shaheen-shell.blade.php"

ERRORS=0

printf '\n'
printf '%s\n' '============================================================'
printf '%s\n' '          SHAHEEN OS — PREMIUM RESPONSIVE SHELL'
printf '%s\n' '============================================================'
printf '\n'

fail() {
    printf '✗ %s\n' "$1"
    ERRORS=$((ERRORS + 1))
}

success() {
    printf '✓ %s\n' "$1"
}

info() {
    printf '[SHAHEEN OS] %s\n' "$1"
}

###############################################################################
# 1. VALIDATION
###############################################################################

info "[1/12] Validating project..."

if [[ ! -f artisan ]]; then
    fail "Laravel artisan file not found."
    exit 1
fi

if [[ ! -f package.json ]]; then
    fail "package.json not found."
    exit 1
fi

if [[ ! -d resources/css ]]; then
    fail "resources/css directory not found."
    exit 1
fi

if [[ ! -d resources/js ]]; then
    fail "resources/js directory not found."
    exit 1
fi

success "Laravel project detected."
success "Frontend resources detected."

###############################################################################
# 2. BACKUP
###############################################################################

info "[2/12] Creating backup..."

mkdir -p "$BACKUP_DIR"

for FILE in \
    resources/css/shaheen-os.css \
    resources/css/shaheen-os-motion.css \
    resources/css/shaheen-os-global.css \
    resources/js/shaheen-os-motion.js \
    resources/js/shaheen-os-global.js
do
    if [[ -f "$FILE" ]]; then
        cp "$FILE" "$BACKUP_DIR/"
    fi
done

success "Backup created:"
echo "  $BACKUP_DIR"

###############################################################################
# 3. PREMIUM SHELL CSS
###############################################################################

info "[3/12] Creating premium responsive shell..."

cat > "$CSS_FILE" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Premium Responsive Shell
|--------------------------------------------------------------------------
*/

:root {
    --shaheen-shell-max-width: 1440px;
    --shaheen-shell-padding: clamp(1rem, 3vw, 3rem);

    --shaheen-header-height: 76px;

    --shaheen-bg: #050505;
    --shaheen-bg-soft: #09090b;
    --shaheen-surface: rgba(16, 16, 19, 0.82);
    --shaheen-surface-solid: #101013;

    --shaheen-border: rgba(255, 255, 255, 0.09);
    --shaheen-border-hover: rgba(255, 255, 255, 0.18);

    --shaheen-text: #ffffff;
    --shaheen-text-soft: rgba(255, 255, 255, 0.68);
    --shaheen-text-muted: rgba(255, 255, 255, 0.45);

    --shaheen-radius-sm: 10px;
    --shaheen-radius-md: 16px;
    --shaheen-radius-lg: 24px;
    --shaheen-radius-xl: 32px;

    --shaheen-shadow:
        0 24px 80px rgba(0, 0, 0, 0.32);

    --shaheen-ease:
        cubic-bezier(.22, 1, .36, 1);
}

/* -------------------------------------------------------------------------- */
/* Base                                                                       */
/* -------------------------------------------------------------------------- */

.shaheen-shell {
    width: 100%;
    min-height: 100%;
    background: var(--shaheen-bg);
    color: var(--shaheen-text);
}

.shaheen-shell *,
.shaheen-shell *::before,
.shaheen-shell *::after {
    box-sizing: border-box;
}

.shaheen-shell-container {
    width: min(
        100% - (var(--shaheen-shell-padding) * 2),
        var(--shaheen-shell-max-width)
    );

    margin-inline: auto;
}

/* -------------------------------------------------------------------------- */
/* Header                                                                     */
/* -------------------------------------------------------------------------- */

.shaheen-shell-header {
    position: sticky;
    top: 0;
    z-index: 1000;

    width: 100%;
    min-height: var(--shaheen-header-height);

    background:
        linear-gradient(
            to bottom,
            rgba(5, 5, 5, .94),
            rgba(5, 5, 5, .72)
        );

    border-bottom: 1px solid var(--shaheen-border);

    backdrop-filter: blur(22px);
    -webkit-backdrop-filter: blur(22px);

    transition:
        background-color .35s var(--shaheen-ease),
        border-color .35s var(--shaheen-ease),
        box-shadow .35s var(--shaheen-ease);
}

.shaheen-shell-header.is-scrolled {
    background: rgba(5, 5, 5, .96);
    border-bottom-color: rgba(255, 255, 255, .14);
    box-shadow: 0 12px 40px rgba(0, 0, 0, .22);
}

.shaheen-shell-header-inner {
    min-height: var(--shaheen-header-height);

    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
}

/* -------------------------------------------------------------------------- */
/* Brand                                                                      */
/* -------------------------------------------------------------------------- */

.shaheen-shell-brand {
    display: inline-flex;
    align-items: center;
    gap: .75rem;

    color: var(--shaheen-text);
    text-decoration: none;

    font-weight: 700;
    letter-spacing: -.025em;

    white-space: nowrap;
}

.shaheen-shell-brand-symbol {
    width: 38px;
    height: 38px;

    display: grid;
    place-items: center;

    border: 1px solid var(--shaheen-border);
    border-radius: 12px;

    background:
        linear-gradient(
            145deg,
            rgba(255, 255, 255, .12),
            rgba(255, 255, 255, .025)
        );

    overflow: hidden;
}

.shaheen-shell-brand-symbol img,
.shaheen-shell-brand-symbol svg {
    width: 72%;
    height: 72%;
    object-fit: contain;
}

.shaheen-shell-brand-name {
    font-size: .95rem;
    line-height: 1;
}

/* -------------------------------------------------------------------------- */
/* Navigation                                                                 */
/* -------------------------------------------------------------------------- */

.shaheen-shell-nav {
    display: flex;
    align-items: center;
    gap: .35rem;
}

.shaheen-shell-nav-link {
    position: relative;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    min-height: 42px;
    padding: 0 .9rem;

    color: var(--shaheen-text-soft);
    text-decoration: none;

    border-radius: 12px;

    font-size: .9rem;
    font-weight: 500;

    transition:
        color .25s var(--shaheen-ease),
        background-color .25s var(--shaheen-ease),
        transform .25s var(--shaheen-ease);
}

.shaheen-shell-nav-link:hover {
    color: var(--shaheen-text);
    background: rgba(255, 255, 255, .06);
    transform: translateY(-1px);
}

.shaheen-shell-nav-link[aria-current="page"] {
    color: var(--shaheen-text);
    background: rgba(255, 255, 255, .08);
}

/* -------------------------------------------------------------------------- */
/* Actions                                                                    */
/* -------------------------------------------------------------------------- */

.shaheen-shell-actions {
    display: flex;
    align-items: center;
    gap: .55rem;
}

.shaheen-shell-button {
    min-height: 42px;
    padding: 0 1rem;

    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: .5rem;

    border: 1px solid var(--shaheen-border);
    border-radius: 12px;

    background: rgba(255, 255, 255, .045);
    color: var(--shaheen-text);

    text-decoration: none;
    cursor: pointer;

    font-size: .88rem;
    font-weight: 600;

    transition:
        transform .25s var(--shaheen-ease),
        background-color .25s var(--shaheen-ease),
        border-color .25s var(--shaheen-ease),
        box-shadow .25s var(--shaheen-ease);
}

.shaheen-shell-button:hover {
    transform: translateY(-2px);
    background: rgba(255, 255, 255, .08);
    border-color: var(--shaheen-border-hover);
    box-shadow: 0 10px 28px rgba(0, 0, 0, .22);
}

.shaheen-shell-button-primary {
    background: #ffffff;
    color: #050505;
    border-color: #ffffff;
}

.shaheen-shell-button-primary:hover {
    background: #eeeeee;
    color: #000000;
}

/* -------------------------------------------------------------------------- */
/* Mobile menu                                                                */
/* -------------------------------------------------------------------------- */

.shaheen-shell-menu-toggle {
    display: none;

    width: 42px;
    height: 42px;

    align-items: center;
    justify-content: center;

    border: 1px solid var(--shaheen-border);
    border-radius: 12px;

    background: rgba(255, 255, 255, .045);
    color: #ffffff;

    cursor: pointer;
}

.shaheen-shell-mobile {
    display: none;
}

.shaheen-shell-mobile.is-open {
    display: block;
}

.shaheen-shell-mobile-inner {
    padding: 1rem 0 1.25rem;

    display: grid;
    gap: .35rem;

    border-top: 1px solid var(--shaheen-border);
}

.shaheen-shell-mobile-link {
    display: flex;
    align-items: center;

    min-height: 48px;
    padding: 0 1rem;

    color: var(--shaheen-text-soft);
    text-decoration: none;

    border-radius: 12px;
}

.shaheen-shell-mobile-link:hover {
    color: #ffffff;
    background: rgba(255, 255, 255, .06);
}

/* -------------------------------------------------------------------------- */
/* Main                                                                       */
/* -------------------------------------------------------------------------- */

.shaheen-shell-main {
    position: relative;
    min-height: calc(100vh - var(--shaheen-header-height));

    isolation: isolate;
}

.shaheen-shell-main::before {
    content: "";

    position: absolute;
    inset: 0;

    pointer-events: none;
    z-index: -1;

    background:
        radial-gradient(
            circle at 50% -10%,
            rgba(255, 255, 255, .065),
            transparent 34%
        );
}

/* -------------------------------------------------------------------------- */
/* Sections                                                                   */
/* -------------------------------------------------------------------------- */

.shaheen-shell-section {
    width: min(
        100% - (var(--shaheen-shell-padding) * 2),
        var(--shaheen-shell-max-width)
    );

    margin-inline: auto;
    padding-block: clamp(3rem, 7vw, 8rem);
}

/* -------------------------------------------------------------------------- */
/* Cards                                                                      */
/* -------------------------------------------------------------------------- */

.shaheen-shell-card {
    position: relative;

    padding: clamp(1.1rem, 2vw, 1.75rem);

    background: var(--shaheen-surface);
    border: 1px solid var(--shaheen-border);
    border-radius: var(--shaheen-radius-lg);

    box-shadow: var(--shaheen-shadow);

    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);

    transition:
        transform .35s var(--shaheen-ease),
        border-color .35s var(--shaheen-ease),
        box-shadow .35s var(--shaheen-ease);
}

.shaheen-shell-card:hover {
    transform: translateY(-4px);
    border-color: var(--shaheen-border-hover);
    box-shadow:
        0 30px 90px rgba(0, 0, 0, .38);
}

/* -------------------------------------------------------------------------- */
/* Footer                                                                     */
/* -------------------------------------------------------------------------- */

.shaheen-shell-footer {
    border-top: 1px solid var(--shaheen-border);
    background: #050505;
}

.shaheen-shell-footer-inner {
    width: min(
        100% - (var(--shaheen-shell-padding) * 2),
        var(--shaheen-shell-max-width)
    );

    margin-inline: auto;

    padding-block: 2rem;

    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;

    color: var(--shaheen-text-muted);
    font-size: .82rem;
}

/* -------------------------------------------------------------------------- */
/* Focus                                                                     */
/* -------------------------------------------------------------------------- */

.shaheen-shell a:focus-visible,
.shaheen-shell button:focus-visible,
.shaheen-shell input:focus-visible,
.shaheen-shell textarea:focus-visible,
.shaheen-shell select:focus-visible {
    outline: 2px solid #ffffff;
    outline-offset: 3px;
}

/* -------------------------------------------------------------------------- */
/* RTL                                                                        */
/* -------------------------------------------------------------------------- */

[dir="rtl"] .shaheen-shell-nav,
[dir="rtl"] .shaheen-shell-actions,
[dir="rtl"] .shaheen-shell-header-inner {
    direction: rtl;
}

/* -------------------------------------------------------------------------- */
/* Tablet                                                                     */
/* -------------------------------------------------------------------------- */

@media (max-width: 1024px) {
    :root {
        --shaheen-header-height: 70px;
    }

    .shaheen-shell-nav {
        display: none;
    }

    .shaheen-shell-menu-toggle {
        display: inline-flex;
    }

    .shaheen-shell-actions .shaheen-shell-button:not(
        .shaheen-shell-button-primary
    ) {
        display: none;
    }
}

/* -------------------------------------------------------------------------- */
/* Mobile                                                                     */
/* -------------------------------------------------------------------------- */

@media (max-width: 640px) {
    :root {
        --shaheen-shell-padding: 1rem;
        --shaheen-header-height: 64px;
    }

    .shaheen-shell-brand-symbol {
        width: 34px;
        height: 34px;
        border-radius: 10px;
    }

    .shaheen-shell-brand-name {
        font-size: .86rem;
    }

    .shaheen-shell-actions {
        gap: .35rem;
    }

    .shaheen-shell-button {
        min-height: 40px;
        padding-inline: .8rem;
    }

    .shaheen-shell-section {
        padding-block: 3rem;
    }

    .shaheen-shell-card {
        border-radius: var(--shaheen-radius-md);
    }

    .shaheen-shell-footer-inner {
        flex-direction: column;
        align-items: flex-start;
    }
}

/* -------------------------------------------------------------------------- */
/* Small phones                                                              */
/* -------------------------------------------------------------------------- */

@media (max-width: 380px) {
    .shaheen-shell-brand-name {
        display: none;
    }

    .shaheen-shell-button-primary {
        padding-inline: .7rem;
    }
}

/* -------------------------------------------------------------------------- */
/* Safe area                                                                 */
/* -------------------------------------------------------------------------- */

@supports (padding: env(safe-area-inset-bottom)) {
    .shaheen-shell-footer {
        padding-bottom: env(safe-area-inset-bottom);
    }

    .shaheen-shell-header {
        padding-top: env(safe-area-inset-top);
    }
}

/* -------------------------------------------------------------------------- */
/* Reduced motion                                                            */
/* -------------------------------------------------------------------------- */

@media (prefers-reduced-motion: reduce) {
    .shaheen-shell *,
    .shaheen-shell *::before,
    .shaheen-shell *::after {
        transition: none !important;
        animation: none !important;
        scroll-behavior: auto !important;
    }
}
CSS

success "Premium responsive shell CSS created."

###############################################################################
# 4. PREMIUM SHELL JAVASCRIPT
###############################################################################

info "[4/12] Creating responsive shell runtime..."

cat > "$JS_FILE" <<'JS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Premium Responsive Shell Runtime
|--------------------------------------------------------------------------
*/

(() => {
    "use strict";

    const initShaheenShell = () => {
        const header = document.querySelector(".shaheen-shell-header");
        const menuToggle = document.querySelector(
            "[data-shaheen-menu-toggle]"
        );
        const mobileMenu = document.querySelector(
            "[data-shaheen-mobile-menu]"
        );

        if (header) {
            const updateHeader = () => {
                header.classList.toggle(
                    "is-scrolled",
                    window.scrollY > 12
                );
            };

            updateHeader();

            window.addEventListener(
                "scroll",
                updateHeader,
                { passive: true }
            );
        }

        if (menuToggle && mobileMenu) {
            const closeMenu = () => {
                mobileMenu.classList.remove("is-open");
                menuToggle.setAttribute("aria-expanded", "false");
            };

            const toggleMenu = () => {
                const open = mobileMenu.classList.toggle("is-open");

                menuToggle.setAttribute(
                    "aria-expanded",
                    open ? "true" : "false"
                );
            };

            menuToggle.addEventListener("click", toggleMenu);

            mobileMenu
                .querySelectorAll("a")
                .forEach((link) => {
                    link.addEventListener("click", closeMenu);
                });

            document.addEventListener("keydown", (event) => {
                if (event.key === "Escape") {
                    closeMenu();
                }
            });

            window.addEventListener("resize", () => {
                if (window.innerWidth > 1024) {
                    closeMenu();
                }
            });
        }

        window.dispatchEvent(
            new CustomEvent("shaheen:shell-ready", {
                detail: {
                    project: "SHAHEEN OS",
                    version: "1.0.0",
                },
            })
        );
    };

    if (document.readyState === "loading") {
        document.addEventListener(
            "DOMContentLoaded",
            initShaheenShell,
            { once: true }
        );
    } else {
        initShaheenShell();
    }
})();
JS

success "Responsive shell JavaScript created."

###############################################################################
# 5. BLADE COMPONENT
###############################################################################

info "[5/12] Creating reusable Blade shell component..."

mkdir -p "$(dirname "$BLADE_FILE")"

cat > "$BLADE_FILE" <<'BLADE'
@props([
    'brand' => 'SHAHEEN OS',
    'logo' => '/brand/logo/shaheen-os-symbol.svg',
    'homeUrl' => '/',
    'navigation' => [],
    'primaryLabel' => null,
    'primaryUrl' => null,
])

<div {{ $attributes->merge(['class' => 'shaheen-shell']) }}>

    <header class="shaheen-shell-header">

        <div class="shaheen-shell-container">

            <div class="shaheen-shell-header-inner">

                <a
                    href="{{ $homeUrl }}"
                    class="shaheen-shell-brand"
                    aria-label="{{ $brand }}"
                >
                    <span class="shaheen-shell-brand-symbol">
                        <img
                            src="{{ $logo }}"
                            alt=""
                            width="32"
                            height="32"
                            loading="eager"
                            decoding="async"
                        >
                    </span>

                    <span class="shaheen-shell-brand-name">
                        {{ $brand }}
                    </span>
                </a>

                @if(count($navigation))
                    <nav
                        class="shaheen-shell-nav"
                        aria-label="{{ $brand }} navigation"
                    >
                        @foreach($navigation as $item)
                            <a
                                href="{{ $item['url'] ?? '#' }}"
                                class="shaheen-shell-nav-link"
                                @if(!empty($item['active']))
                                    aria-current="page"
                                @endif
                            >
                                {{ $item['label'] ?? '' }}
                            </a>
                        @endforeach
                    </nav>
                @endif

                <div class="shaheen-shell-actions">

                    @if($primaryLabel && $primaryUrl)
                        <a
                            href="{{ $primaryUrl }}"
                            class="shaheen-shell-button shaheen-shell-button-primary"
                        >
                            {{ $primaryLabel }}
                        </a>
                    @endif

                    <button
                        type="button"
                        class="shaheen-shell-menu-toggle"
                        data-shaheen-menu-toggle
                        aria-expanded="false"
                        aria-controls="shaheen-mobile-navigation"
                        aria-label="Open navigation"
                    >
                        <span aria-hidden="true">☰</span>
                    </button>

                </div>

            </div>

            @if(count($navigation))
                <nav
                    id="shaheen-mobile-navigation"
                    class="shaheen-shell-mobile"
                    data-shaheen-mobile-menu
                    aria-label="{{ $brand }} mobile navigation"
                >
                    <div class="shaheen-shell-mobile-inner">

                        @foreach($navigation as $item)
                            <a
                                href="{{ $item['url'] ?? '#' }}"
                                class="shaheen-shell-mobile-link"
                                @if(!empty($item['active']))
                                    aria-current="page"
                                @endif
                            >
                                {{ $item['label'] ?? '' }}
                            </a>
                        @endforeach

                    </div>
                </nav>
            @endif

        </div>

    </header>

    <main class="shaheen-shell-main">
        {{ $slot }}
    </main>

    <footer class="shaheen-shell-footer">

        <div class="shaheen-shell-footer-inner">

            <span>
                © {{ date('Y') }} {{ $brand }}
            </span>

            <span>
                Premium Digital Experience
            </span>

        </div>

    </footer>

</div>
BLADE

success "Reusable Blade component created."

###############################################################################
# 6. REGISTER ASSETS
###############################################################################

info "[6/12] Registering shell assets..."

APP_CSS="resources/css/app.css"
APP_JS="resources/js/app.js"

if [[ -f "$APP_CSS" ]]; then

    if ! grep -Fq '@import "./shaheen-os-shell.css";' "$APP_CSS"; then
        printf '\n@import "./shaheen-os-shell.css";\n' >> "$APP_CSS"
        success "Premium shell CSS registered."
    else
        success "Premium shell CSS already registered."
    fi

else
    fail "resources/css/app.css not found."
fi

if [[ -f "$APP_JS" ]]; then

    if ! grep -Fq 'import "./shaheen-os-shell.js";' "$APP_JS"; then
        printf '\nimport "./shaheen-os-shell.js";\n' >> "$APP_JS"
        success "Premium shell JS registered."
    else
        success "Premium shell JS already registered."
    fi

else
    fail "resources/js/app.js not found."
fi

###############################################################################
# 7. SYNTAX VALIDATION
###############################################################################

info "[7/12] Validating generated files..."

if bash -n "$0"; then
    success "Bash syntax valid."
else
    fail "Bash syntax validation failed."
fi

if node --check "$JS_FILE"; then
    success "Shell JavaScript syntax valid."
else
    fail "Shell JavaScript syntax validation failed."
fi

###############################################################################
# 8. VERIFY REQUIRED ASSETS
###############################################################################

info "[8/12] Verifying SHAHEEN OS assets..."

REQUIRED_FILES=(
    "$CSS_FILE"
    "$JS_FILE"
    "$BLADE_FILE"
    "resources/css/shaheen-os.css"
    "resources/css/shaheen-os-motion.css"
    "resources/css/shaheen-os-global.css"
    "resources/js/shaheen-os-motion.js"
    "resources/js/shaheen-os-global.js"
)

for FILE in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$FILE" ]]; then
        success "$FILE"
    else
        fail "Missing: $FILE"
    fi
done

###############################################################################
# 9. CHECK OLD BRAND REFERENCES
###############################################################################

info "[9/12] Checking SHAHEEN OS branding..."

if grep -RIl \
    --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=.git \
    "SHAHEEN ON" \
    public/brand resources 2>/dev/null \
    | head -20 \
    | grep -q .; then

    printf '⚠ Old SHAHEEN ON references detected in active UI files.\n'
else
    success "No SHAHEEN ON references detected in active UI assets."
fi

###############################################################################
# 10. LARAVEL CACHE
###############################################################################

info "[10/12] Rebuilding Laravel cache..."

if php artisan optimize:clear; then
    success "Laravel caches cleared."
else
    fail "Laravel optimize:clear failed."
fi

if php artisan optimize; then
    success "Laravel cache rebuilt."
else
    fail "Laravel optimize failed."
fi

###############################################################################
# 11. FRONTEND BUILD
###############################################################################

info "[11/12] Building SHAHEEN OS frontend..."

if npm run build; then
    success "Vite production build completed."
else
    fail "Vite production build failed."
fi

###############################################################################
# 12. FINAL VERIFICATION
###############################################################################

info "[12/12] Final verification..."

if [[ -f "public/build/manifest.json" ]]; then
    success "Vite manifest exists."
else
    fail "Vite manifest missing."
fi

if [[ -f "$CSS_FILE" ]]; then
    success "Premium shell CSS installed."
fi

if [[ -f "$JS_FILE" ]]; then
    success "Premium shell JS installed."
fi

if [[ -f "$BLADE_FILE" ]]; then
    success "Reusable Blade shell installed."
fi

printf '\n'
printf '%s\n' '============================================================'

if [[ "$ERRORS" -eq 0 ]]; then

    printf '%s\n' '          SHAHEEN OS PREMIUM SHELL COMPLETE'
    printf '%s\n' '============================================================'
    printf '\n'

    echo "Project:"
    echo "  SHAHEEN OS"
    echo

    echo "Premium CSS:"
    echo "  $PROJECT_DIR/$CSS_FILE"
    echo

    echo "Premium JS:"
    echo "  $PROJECT_DIR/$JS_FILE"
    echo

    echo "Blade Component:"
    echo "  $PROJECT_DIR/$BLADE_FILE"
    echo

    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo

    echo "✓ Responsive desktop layout installed."
    echo "✓ Tablet layout installed."
    echo "✓ Mobile navigation installed."
    echo "✓ Premium glass UI installed."
    echo "✓ Safe-area support installed."
    echo "✓ RTL/LTR support installed."
    echo "✓ Accessibility focus states installed."
    echo "✓ Reduced-motion support installed."
    echo "✓ Laravel cache rebuilt."
    echo "✓ Vite production build completed."
    echo
    echo "Next stage can start."

else

    printf '%s\n' '          SHAHEEN OS PREMIUM SHELL FAILED'
    printf '%s\n' '============================================================'
    printf '\n'

    echo "Errors: $ERRORS"
    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo

    exit 1
fi
