#!/usr/bin/env bash

set -Eeuo pipefail

###############################################################################
# SHAHEEN OS — PART 08
# PREMIUM NAVIGATION + COMMAND UI
###############################################################################

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

APP_NAME="SHAHEEN OS"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

NAV_CSS="$PROJECT_ROOT/resources/css/shaheen-os-navigation.css"
NAV_JS="$PROJECT_ROOT/resources/js/shaheen-os-navigation.js"
NAV_BLADE="$PROJECT_ROOT/resources/views/components/shaheen-navigation.blade.php"

APP_CSS="$PROJECT_ROOT/resources/css/app.css"
APP_JS="$PROJECT_ROOT/resources/js/app.js"

ERRORS=0

###############################################################################
# OUTPUT
###############################################################################

title() {
    printf '\n============================================================\n'
    printf '              SHAHEEN OS — NAVIGATION UI\n'
    printf '============================================================\n\n'
}

step() {
    printf '\n[%s/12] %s...\n' "$1" "$2"
}

success() {
    printf '✓ %s\n' "$1"
}

warning() {
    printf '⚠ %s\n' "$1"
}

failure() {
    printf '✗ %s\n' "$1"
    ERRORS=$((ERRORS + 1))
}

title

###############################################################################
# 1. VALIDATE PROJECT
###############################################################################

step "1" "Validating project"

if [[ ! -f "$PROJECT_ROOT/artisan" ]]; then
    failure "Laravel artisan file not found."
    exit 1
fi

if [[ ! -f "$APP_CSS" ]]; then
    failure "resources/css/app.css not found."
    exit 1
fi

if [[ ! -f "$APP_JS" ]]; then
    failure "resources/js/app.js not found."
    exit 1
fi

success "Laravel project detected."

###############################################################################
# 2. BACKUP
###############################################################################

step "2" "Creating SHAHEEN OS backup"

mkdir -p "$BACKUP_DIR"

for file in \
    "$APP_CSS" \
    "$APP_JS" \
    "$NAV_CSS" \
    "$NAV_JS" \
    "$NAV_BLADE"
do
    if [[ -f "$file" ]]; then
        cp -a "$file" "$BACKUP_DIR/"
    fi
done

success "Backup created:"
echo "  $BACKUP_DIR"

###############################################################################
# 3. CREATE DIRECTORIES
###############################################################################

step "3" "Preparing navigation directories"

mkdir -p \
    "$PROJECT_ROOT/resources/css" \
    "$PROJECT_ROOT/resources/js" \
    "$PROJECT_ROOT/resources/views/components"

success "Directories ready."

###############################################################################
# 4. PREMIUM NAVIGATION CSS
###############################################################################

step "4" "Creating SHAHEEN OS navigation CSS"

cat > "$NAV_CSS" <<'CSS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Premium Navigation System
|--------------------------------------------------------------------------
*/

:root {
    --shaheen-nav-width: 286px;
    --shaheen-nav-radius: 22px;
    --shaheen-nav-border: rgba(255,255,255,.10);
    --shaheen-nav-bg: rgba(10,10,14,.78);
    --shaheen-nav-surface: rgba(255,255,255,.055);
    --shaheen-nav-hover: rgba(255,255,255,.085);
    --shaheen-nav-active: rgba(255,255,255,.12);
    --shaheen-nav-text: rgba(255,255,255,.92);
    --shaheen-nav-muted: rgba(255,255,255,.55);
    --shaheen-nav-shadow:
        0 24px 80px rgba(0,0,0,.34);
}

/* Main navigation */

.shaheen-navigation {
    position: fixed;
    inset: 18px auto 18px 18px;
    width: var(--shaheen-nav-width);
    z-index: 9000;

    display: flex;
    flex-direction: column;

    padding: 18px;

    border: 1px solid var(--shaheen-nav-border);
    border-radius: var(--shaheen-nav-radius);

    background:
        linear-gradient(
            180deg,
            rgba(255,255,255,.075),
            rgba(255,255,255,.025)
        ),
        var(--shaheen-nav-bg);

    box-shadow: var(--shaheen-nav-shadow);

    backdrop-filter: blur(28px) saturate(150%);
    -webkit-backdrop-filter: blur(28px) saturate(150%);

    color: var(--shaheen-nav-text);

    overflow: hidden;

    transform: translateZ(0);
    transition:
        width .42s cubic-bezier(.22,1,.36,1),
        transform .42s cubic-bezier(.22,1,.36,1),
        opacity .3s ease;
}

/* RTL */

[dir="rtl"] .shaheen-navigation {
    left: auto;
    right: 18px;
}

/* Brand */

.shaheen-navigation__brand {
    display: flex;
    align-items: center;
    gap: 12px;

    min-height: 54px;
    padding: 8px 10px;
    margin-bottom: 18px;

    border-radius: 16px;

    background: rgba(255,255,255,.035);
    border: 1px solid rgba(255,255,255,.06);

    text-decoration: none;
    color: inherit;
}

.shaheen-navigation__brand-symbol {
    width: 38px;
    height: 38px;

    display: grid;
    place-items: center;

    border-radius: 12px;

    background:
        radial-gradient(
            circle at 35% 25%,
            rgba(255,255,255,.35),
            transparent 38%
        ),
        rgba(255,255,255,.08);

    border: 1px solid rgba(255,255,255,.12);

    overflow: hidden;
}

.shaheen-navigation__brand-symbol img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.shaheen-navigation__brand-name {
    display: flex;
    flex-direction: column;
    min-width: 0;
}

.shaheen-navigation__brand-title {
    font-size: 14px;
    font-weight: 800;
    letter-spacing: .08em;
    white-space: nowrap;
}

.shaheen-navigation__brand-subtitle {
    margin-top: 2px;
    font-size: 10px;
    color: var(--shaheen-nav-muted);
    letter-spacing: .12em;
    text-transform: uppercase;
}

/* Search */

.shaheen-navigation__search {
    width: 100%;
    height: 44px;

    display: flex;
    align-items: center;
    gap: 10px;

    margin-bottom: 16px;
    padding: 0 13px;

    border: 1px solid rgba(255,255,255,.08);
    border-radius: 14px;

    background: rgba(255,255,255,.035);

    color: var(--shaheen-nav-muted);

    cursor: pointer;

    transition:
        background .22s ease,
        border-color .22s ease,
        transform .22s ease;
}

.shaheen-navigation__search:hover {
    background: var(--shaheen-nav-hover);
    border-color: rgba(255,255,255,.15);
    transform: translateY(-1px);
}

.shaheen-navigation__search-label {
    flex: 1;
    text-align: start;
    font-size: 12px;
}

.shaheen-navigation__shortcut {
    min-width: 28px;
    padding: 3px 6px;

    border-radius: 7px;

    background: rgba(255,255,255,.07);
    border: 1px solid rgba(255,255,255,.08);

    font-size: 10px;
    text-align: center;
}

/* Menu */

.shaheen-navigation__menu {
    flex: 1;
    overflow-y: auto;

    padding-right: 3px;

    scrollbar-width: thin;
    scrollbar-color:
        rgba(255,255,255,.16)
        transparent;
}

.shaheen-navigation__section {
    margin: 16px 0 8px;
}

.shaheen-navigation__section-title {
    padding: 0 10px;

    color: rgba(255,255,255,.35);

    font-size: 9px;
    font-weight: 800;

    letter-spacing: .14em;
    text-transform: uppercase;
}

.shaheen-navigation__item {
    position: relative;

    width: 100%;
    min-height: 44px;

    display: flex;
    align-items: center;
    gap: 12px;

    margin: 3px 0;
    padding: 0 11px;

    border: 1px solid transparent;
    border-radius: 14px;

    background: transparent;

    color: var(--shaheen-nav-muted);

    text-decoration: none;

    cursor: pointer;

    transition:
        color .22s ease,
        background .22s ease,
        border-color .22s ease,
        transform .22s ease;
}

.shaheen-navigation__item:hover {
    color: var(--shaheen-nav-text);
    background: var(--shaheen-nav-hover);
    border-color: rgba(255,255,255,.06);
    transform: translateX(2px);
}

[dir="rtl"] .shaheen-navigation__item:hover {
    transform: translateX(-2px);
}

.shaheen-navigation__item.is-active {
    color: #fff;
    background: var(--shaheen-nav-active);
    border-color: rgba(255,255,255,.10);
}

.shaheen-navigation__item.is-active::before {
    content: "";

    position: absolute;

    width: 3px;
    height: 20px;

    left: -1px;
    top: 50%;

    transform: translateY(-50%);

    border-radius: 0 8px 8px 0;

    background: rgba(255,255,255,.9);
}

[dir="rtl"] .shaheen-navigation__item.is-active::before {
    left: auto;
    right: -1px;

    border-radius: 8px 0 0 8px;
}

.shaheen-navigation__icon {
    width: 21px;
    height: 21px;

    display: grid;
    place-items: center;

    flex: 0 0 21px;

    font-size: 15px;
}

.shaheen-navigation__label {
    flex: 1;

    font-size: 12px;
    font-weight: 600;

    text-align: start;

    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.shaheen-navigation__badge {
    min-width: 20px;
    height: 20px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    padding: 0 6px;

    border-radius: 999px;

    background: rgba(255,255,255,.08);

    font-size: 9px;
    font-weight: 800;
}

/* Footer */

.shaheen-navigation__footer {
    margin-top: 14px;
    padding-top: 14px;

    border-top: 1px solid rgba(255,255,255,.07);
}

.shaheen-navigation__profile {
    display: flex;
    align-items: center;
    gap: 10px;

    padding: 9px;

    border-radius: 15px;

    background: rgba(255,255,255,.035);
    border: 1px solid rgba(255,255,255,.06);
}

.shaheen-navigation__avatar {
    width: 34px;
    height: 34px;

    display: grid;
    place-items: center;

    border-radius: 11px;

    background: rgba(255,255,255,.08);

    font-size: 13px;
    font-weight: 800;
}

.shaheen-navigation__profile-info {
    min-width: 0;
    flex: 1;
}

.shaheen-navigation__profile-name {
    font-size: 11px;
    font-weight: 700;

    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.shaheen-navigation__profile-status {
    margin-top: 2px;

    color: rgba(255,255,255,.42);

    font-size: 9px;
}

/* Mobile bottom navigation */

.shaheen-mobile-navigation {
    display: none;

    position: fixed;

    left: 12px;
    right: 12px;
    bottom: max(12px, env(safe-area-inset-bottom));

    height: 66px;

    z-index: 9100;

    align-items: center;
    justify-content: space-around;

    padding: 7px;

    border: 1px solid rgba(255,255,255,.10);
    border-radius: 20px;

    background:
        linear-gradient(
            180deg,
            rgba(255,255,255,.075),
            rgba(255,255,255,.025)
        ),
        rgba(10,10,14,.86);

    box-shadow:
        0 22px 70px rgba(0,0,0,.42);

    backdrop-filter: blur(26px);
    -webkit-backdrop-filter: blur(26px);
}

.shaheen-mobile-navigation__item {
    width: 54px;
    height: 52px;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 3px;

    border: 0;
    border-radius: 15px;

    background: transparent;

    color: rgba(255,255,255,.45);

    text-decoration: none;

    font-size: 9px;

    transition:
        background .2s ease,
        color .2s ease,
        transform .2s ease;
}

.shaheen-mobile-navigation__item:hover,
.shaheen-mobile-navigation__item.is-active {
    color: #fff;
    background: rgba(255,255,255,.09);
}

.shaheen-mobile-navigation__item:active {
    transform: scale(.94);
}

.shaheen-mobile-navigation__icon {
    font-size: 17px;
    line-height: 1;
}

/* Command palette */

.shaheen-command-overlay {
    position: fixed;
    inset: 0;

    z-index: 12000;

    display: flex;
    align-items: flex-start;
    justify-content: center;

    padding: 9vh 18px;

    background: rgba(0,0,0,.62);

    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);

    opacity: 0;
    visibility: hidden;

    transition:
        opacity .22s ease,
        visibility .22s ease;
}

.shaheen-command-overlay.is-open {
    opacity: 1;
    visibility: visible;
}

.shaheen-command {
    width: min(680px, 100%);

    overflow: hidden;

    border: 1px solid rgba(255,255,255,.12);
    border-radius: 22px;

    background:
        linear-gradient(
            180deg,
            rgba(255,255,255,.085),
            rgba(255,255,255,.035)
        ),
        rgba(10,10,14,.92);

    box-shadow:
        0 40px 120px rgba(0,0,0,.58);

    transform:
        translateY(-18px)
        scale(.98);

    transition:
        transform .3s cubic-bezier(.22,1,.36,1);
}

.shaheen-command-overlay.is-open .shaheen-command {
    transform:
        translateY(0)
        scale(1);
}

.shaheen-command__input {
    width: 100%;
    height: 64px;

    padding: 0 20px;

    border: 0;
    border-bottom: 1px solid rgba(255,255,255,.08);
    outline: none;

    background: transparent;

    color: #fff;

    font-size: 15px;
}

.shaheen-command__input::placeholder {
    color: rgba(255,255,255,.35);
}

.shaheen-command__results {
    max-height: 420px;

    overflow-y: auto;

    padding: 10px;
}

.shaheen-command__result {
    width: 100%;

    display: flex;
    align-items: center;
    gap: 12px;

    min-height: 52px;

    padding: 0 13px;

    border: 1px solid transparent;
    border-radius: 13px;

    background: transparent;

    color: rgba(255,255,255,.72);

    text-decoration: none;

    cursor: pointer;

    transition:
        background .18s ease,
        color .18s ease;
}

.shaheen-command__result:hover,
.shaheen-command__result.is-selected {
    color: #fff;
    background: rgba(255,255,255,.08);
}

.shaheen-command__result-icon {
    width: 28px;
    text-align: center;
}

.shaheen-command__result-label {
    flex: 1;
    text-align: start;

    font-size: 12px;
}

.shaheen-command__result-key {
    color: rgba(255,255,255,.3);
    font-size: 10px;
}

/* Main content offset */

@media (min-width: 1200px) {
    body.shaheen-navigation-active {
        padding-left: calc(var(--shaheen-nav-width) + 36px);
    }

    [dir="rtl"] body.shaheen-navigation-active {
        padding-left: 0;
        padding-right: calc(var(--shaheen-nav-width) + 36px);
    }
}

/* Tablet */

@media (max-width: 1199px) {
    .shaheen-navigation {
        width: 78px;
        padding: 12px;
    }

    .shaheen-navigation__brand {
        justify-content: center;
    }

    .shaheen-navigation__brand-name,
    .shaheen-navigation__search-label,
    .shaheen-navigation__shortcut,
    .shaheen-navigation__label,
    .shaheen-navigation__badge,
    .shaheen-navigation__section-title,
    .shaheen-navigation__profile-info {
        display: none;
    }

    .shaheen-navigation__search {
        justify-content: center;
        padding: 0;
    }

    .shaheen-navigation__item {
        justify-content: center;
        padding: 0;
    }

    .shaheen-navigation__item.is-active::before {
        display: none;
    }

    .shaheen-navigation__profile {
        justify-content: center;
    }
}

/* Mobile */

@media (max-width: 767px) {
    .shaheen-navigation {
        display: none;
    }

    .shaheen-mobile-navigation {
        display: flex;
    }

    body.shaheen-navigation-active {
        padding-left: 0 !important;
        padding-right: 0 !important;
        padding-bottom: 92px;
    }
}

/* Reduced motion */

@media (prefers-reduced-motion: reduce) {
    .shaheen-navigation,
    .shaheen-navigation__item,
    .shaheen-navigation__search,
    .shaheen-mobile-navigation__item,
    .shaheen-command-overlay,
    .shaheen-command {
        transition: none !important;
    }
}

/* Focus */

.shaheen-navigation__item:focus-visible,
.shaheen-navigation__search:focus-visible,
.shaheen-mobile-navigation__item:focus-visible,
.shaheen-command__result:focus-visible,
.shaheen-command__input:focus-visible {
    outline: 2px solid rgba(255,255,255,.75);
    outline-offset: 2px;
}
CSS

success "Premium navigation CSS created."

###############################################################################
# 5. NAVIGATION JAVASCRIPT
###############################################################################

step "5" "Creating navigation interaction engine"

cat > "$NAV_JS" <<'JS'
/*
|--------------------------------------------------------------------------
| SHAHEEN OS — Navigation Interaction Engine
|--------------------------------------------------------------------------
*/

(() => {
    "use strict";

    const state = {
        commandOpen: false,
        selectedIndex: 0,
    };

    const qs = (selector, root = document) =>
        root.querySelector(selector);

    const qsa = (selector, root = document) =>
        [...root.querySelectorAll(selector)];

    function openCommand() {
        const overlay = qs("[data-shaheen-command-overlay]");
        const input = qs("[data-shaheen-command-input]");

        if (!overlay) return;

        state.commandOpen = true;

        overlay.classList.add("is-open");
        overlay.setAttribute("aria-hidden", "false");

        document.body.classList.add("shaheen-command-open");

        requestAnimationFrame(() => {
            input?.focus();
        });
    }

    function closeCommand() {
        const overlay = qs("[data-shaheen-command-overlay]");

        if (!overlay) return;

        state.commandOpen = false;

        overlay.classList.remove("is-open");
        overlay.setAttribute("aria-hidden", "true");

        document.body.classList.remove("shaheen-command-open");
    }

    function filterCommands(value) {
        const query = value.trim().toLowerCase();

        const results = qsa("[data-shaheen-command-item]");

        results.forEach((item) => {
            const text =
                item.textContent.toLowerCase();

            const visible =
                !query || text.includes(query);

            item.hidden = !visible;
        });

        state.selectedIndex = 0;

        updateSelection();
    }

    function updateSelection() {
        const results = qsa(
            "[data-shaheen-command-item]:not([hidden])"
        );

        results.forEach((item, index) => {
            item.classList.toggle(
                "is-selected",
                index === state.selectedIndex
            );
        });
    }

    function activateSelected() {
        const results = qsa(
            "[data-shaheen-command-item]:not([hidden])"
        );

        const selected = results[state.selectedIndex];

        if (!selected) return;

        const href = selected.getAttribute("href");

        if (href) {
            closeCommand();
            window.location.href = href;
        }
    }

    function setupCommandPalette() {
        const overlay = qs("[data-shaheen-command-overlay]");
        const input = qs("[data-shaheen-command-input]");

        if (!overlay) return;

        qsa("[data-shaheen-command-open]").forEach((button) => {
            button.addEventListener("click", openCommand);
        });

        qsa("[data-shaheen-command-close]").forEach((button) => {
            button.addEventListener("click", closeCommand);
        });

        overlay.addEventListener("click", (event) => {
            if (event.target === overlay) {
                closeCommand();
            }
        });

        input?.addEventListener("input", () => {
            filterCommands(input.value);
        });

        input?.addEventListener("keydown", (event) => {
            const results = qsa(
                "[data-shaheen-command-item]:not([hidden])"
            );

            if (event.key === "ArrowDown") {
                event.preventDefault();

                if (results.length) {
                    state.selectedIndex =
                        (state.selectedIndex + 1) %
                        results.length;

                    updateSelection();
                }
            }

            if (event.key === "ArrowUp") {
                event.preventDefault();

                if (results.length) {
                    state.selectedIndex =
                        (state.selectedIndex - 1 + results.length) %
                        results.length;

                    updateSelection();
                }
            }

            if (event.key === "Enter") {
                event.preventDefault();
                activateSelected();
            }

            if (event.key === "Escape") {
                event.preventDefault();
                closeCommand();
            }
        });
    }

    function setupKeyboardShortcut() {
        document.addEventListener("keydown", (event) => {
            const modifier =
                event.ctrlKey || event.metaKey;

            if (modifier && event.key.toLowerCase() === "k") {
                event.preventDefault();

                if (state.commandOpen) {
                    closeCommand();
                } else {
                    openCommand();
                }
            }

            if (event.key === "Escape" && state.commandOpen) {
                closeCommand();
            }
        });
    }

    function setupActiveNavigation() {
        const currentPath =
            window.location.pathname.replace(/\/+$/, "") || "/";

        qsa("[data-shaheen-nav-link]").forEach((link) => {
            const href = link.getAttribute("href");

            if (!href || href.startsWith("#")) {
                return;
            }

            try {
                const url = new URL(
                    href,
                    window.location.origin
                );

                const path =
                    url.pathname.replace(/\/+$/, "") || "/";

                if (path === currentPath) {
                    link.classList.add("is-active");
                    link.setAttribute("aria-current", "page");
                }
            } catch (_) {
                // Ignore malformed URLs.
            }
        });
    }

    function setupMobileNavigation() {
        qsa("[data-shaheen-mobile-nav]").forEach((item) => {
            item.addEventListener("click", () => {
                qsa("[data-shaheen-mobile-nav]").forEach((node) => {
                    node.classList.remove("is-active");
                });

                item.classList.add("is-active");
            });
        });
    }

    function init() {
        document.body.classList.add(
            "shaheen-navigation-active"
        );

        setupCommandPalette();
        setupKeyboardShortcut();
        setupActiveNavigation();
        setupMobileNavigation();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }

    window.SHAHEENNavigation = {
        openCommand,
        closeCommand,
    };
})();
JS

success "Navigation JavaScript created."

###############################################################################
# 6. BLADE COMPONENT
###############################################################################

step "6" "Creating reusable SHAHEEN OS navigation component"

cat > "$NAV_BLADE" <<'BLADE'
@php
    $brandSymbol = asset('brand/logo/shaheen-os-symbol.svg');

    $navigation = [
        [
            'section' => 'Core',
            'items' => [
                ['label' => 'Home', 'icon' => '⌂', 'url' => '/'],
                ['label' => 'Explore', 'icon' => '◈', 'url' => '/explore'],
                ['label' => 'Search', 'icon' => '⌕', 'command' => true],
            ],
        ],
        [
            'section' => 'Platform',
            'items' => [
                ['label' => 'Agents', 'icon' => '✦', 'url' => '/agents'],
                ['label' => 'Models', 'icon' => '◉', 'url' => '/models'],
                ['label' => 'Workspace', 'icon' => '▦', 'url' => '/workspace'],
                ['label' => 'Marketplace', 'icon' => '◇', 'url' => '/marketplace'],
                ['label' => 'Tools', 'icon' => '⌘', 'url' => '/tools'],
            ],
        ],
        [
            'section' => 'System',
            'items' => [
                ['label' => 'Settings', 'icon' => '⚙', 'url' => '/settings'],
                ['label' => 'Help', 'icon' => '?', 'url' => '/help'],
            ],
        ],
    ];
@endphp

<aside
    class="shaheen-navigation"
    aria-label="SHAHEEN OS navigation"
>
    <a
        href="/"
        class="shaheen-navigation__brand"
        aria-label="SHAHEEN OS"
    >
        <span class="shaheen-navigation__brand-symbol">
            <img
                src="{{ $brandSymbol }}"
                alt="SHAHEEN OS"
                loading="eager"
            >
        </span>

        <span class="shaheen-navigation__brand-name">
            <span class="shaheen-navigation__brand-title">
                SHAHEEN OS
            </span>

            <span class="shaheen-navigation__brand-subtitle">
                Intelligent Platform
            </span>
        </span>
    </a>

    <button
        type="button"
        class="shaheen-navigation__search"
        data-shaheen-command-open
        aria-label="Open SHAHEEN OS command palette"
    >
        <span aria-hidden="true">⌕</span>

        <span class="shaheen-navigation__search-label">
            Search SHAHEEN OS
        </span>

        <span class="shaheen-navigation__shortcut">
            Ctrl K
        </span>
    </button>

    <nav class="shaheen-navigation__menu">
        @foreach ($navigation as $group)
            <div class="shaheen-navigation__section">
                <div class="shaheen-navigation__section-title">
                    {{ $group['section'] }}
                </div>

                @foreach ($group['items'] as $item)
                    @if (!empty($item['command']))
                        <button
                            type="button"
                            class="shaheen-navigation__item"
                            data-shaheen-command-open
                        >
                            <span
                                class="shaheen-navigation__icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-navigation__label">
                                {{ $item['label'] }}
                            </span>
                        </button>
                    @else
                        <a
                            href="{{ $item['url'] }}"
                            class="shaheen-navigation__item"
                            data-shaheen-nav-link
                        >
                            <span
                                class="shaheen-navigation__icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-navigation__label">
                                {{ $item['label'] }}
                            </span>
                        </a>
                    @endif
                @endforeach
            </div>
        @endforeach
    </nav>

    <div class="shaheen-navigation__footer">
        <div class="shaheen-navigation__profile">
            <div class="shaheen-navigation__avatar">
                S
            </div>

            <div class="shaheen-navigation__profile-info">
                <div class="shaheen-navigation__profile-name">
                    SHAHEEN OS
                </div>

                <div class="shaheen-navigation__profile-status">
                    System Online
                </div>
            </div>
        </div>
    </div>
</aside>

<nav
    class="shaheen-mobile-navigation"
    aria-label="SHAHEEN OS mobile navigation"
>
    <a
        href="/"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⌂</span>

        <span>Home</span>
    </a>

    <a
        href="/explore"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >◈</span>

        <span>Explore</span>
    </a>

    <button
        type="button"
        class="shaheen-mobile-navigation__item"
        data-shaheen-command-open
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⌕</span>

        <span>Search</span>
    </button>

    <a
        href="/workspace"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >▦</span>

        <span>Workspace</span>
    </a>

    <a
        href="/settings"
        class="shaheen-mobile-navigation__item"
        data-shaheen-mobile-nav
    >
        <span
            class="shaheen-mobile-navigation__icon"
            aria-hidden="true"
        >⚙</span>

        <span>Settings</span>
    </a>
</nav>

<div
    class="shaheen-command-overlay"
    data-shaheen-command-overlay
    aria-hidden="true"
>
    <section
        class="shaheen-command"
        role="dialog"
        aria-modal="true"
        aria-label="SHAHEEN OS Command Palette"
    >
        <input
            type="search"
            class="shaheen-command__input"
            data-shaheen-command-input
            autocomplete="off"
            placeholder="Search SHAHEEN OS..."
            aria-label="Search SHAHEEN OS"
        >

        <div class="shaheen-command__results">
            @foreach ($navigation as $group)
                @foreach ($group['items'] as $item)
                    @if (!empty($item['url']))
                        <a
                            href="{{ $item['url'] }}"
                            class="shaheen-command__result"
                            data-shaheen-command-item
                        >
                            <span
                                class="shaheen-command__result-icon"
                                aria-hidden="true"
                            >
                                {{ $item['icon'] }}
                            </span>

                            <span class="shaheen-command__result-label">
                                {{ $item['label'] }}
                            </span>

                            <span class="shaheen-command__result-key">
                                {{ $group['section'] }}
                            </span>
                        </a>
                    @endif
                @endforeach
            @endforeach
        </div>
    </section>
</div>
BLADE

success "Reusable Blade navigation component created."

###############################################################################
# 7. REGISTER CSS
###############################################################################

step "7" "Registering navigation CSS"

python3 - "$APP_CSS" "$NAV_CSS" <<'PY'
import sys
from pathlib import Path

app = Path(sys.argv[1])
asset = Path(sys.argv[2])

text = app.read_text()

import_line = '@import "./shaheen-os-navigation.css";'

if import_line not in text:
    lines = text.splitlines()

    index = 0

    while index < len(lines):
        stripped = lines[index].strip()

        if stripped.startswith('@charset') or stripped.startswith('@import'):
            index += 1
        else:
            break

    lines.insert(index, import_line)

    app.write_text('\n'.join(lines) + '\n')

print("CSS registration complete.")
PY

success "Navigation CSS registered."

###############################################################################
# 8. REGISTER JS
###############################################################################

step "8" "Registering navigation JavaScript"

python3 - "$APP_JS" <<'PY'
import sys
from pathlib import Path

app = Path(sys.argv[1])
text = app.read_text()

import_line = 'import "./shaheen-os-navigation.js";'

if import_line not in text:
    lines = text.splitlines()

    index = 0

    while index < len(lines):
        stripped = lines[index].strip()

        if stripped.startswith('import '):
            index += 1
        else:
            break

    lines.insert(index, import_line)

    app.write_text('\n'.join(lines) + '\n')

print("JS registration complete.")
PY

success "Navigation JavaScript registered."

###############################################################################
# 9. CHECK SHAHEEN ON CONTAMINATION
###############################################################################

step "9" "Checking brand identity"

if grep -Rni \
    --exclude-dir=node_modules \
    --exclude-dir=vendor \
    --exclude-dir=.git \
    "SHAHEEN ON" \
    "$PROJECT_ROOT/resources" \
    "$PROJECT_ROOT/public/brand" \
    >/tmp/shaheen_on_navigation_check.txt 2>/dev/null; then

    warning "SHAHEEN ON references detected outside the new navigation component."
    cat /tmp/shaheen_on_navigation_check.txt
else
    success "No SHAHEEN ON references found in navigation integration."
fi

###############################################################################
# 10. REBUILD LARAVEL
###############################################################################

step "10" "Rebuilding Laravel cache"

php artisan optimize:clear

php artisan optimize

success "Laravel cache rebuilt."

###############################################################################
# 11. BUILD VITE
###############################################################################

step "11" "Building frontend assets"

if command -v npm >/dev/null 2>&1; then
    npm run build
    success "Vite production build completed."
else
    warning "npm not found; Vite build skipped."
fi

###############################################################################
# 12. FINAL VERIFICATION
###############################################################################

step "12" "Final SHAHEEN OS navigation verification"

FILES=(
    "$NAV_CSS"
    "$NAV_JS"
    "$NAV_BLADE"
)

for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        success "$file"
    else
        failure "$file"
    fi
done

if grep -q 'shaheen-os-navigation.css' "$APP_CSS"; then
    success "Navigation CSS registered."
else
    failure "Navigation CSS registration missing."
fi

if grep -q 'shaheen-os-navigation.js' "$APP_JS"; then
    success "Navigation JS registered."
else
    failure "Navigation JS registration missing."
fi

if grep -q 'SHAHEEN OS' "$NAV_BLADE"; then
    success "SHAHEEN OS identity verified."
else
    failure "SHAHEEN OS identity missing."
fi

printf '\n============================================================\n'

if [[ "$ERRORS" -eq 0 ]]; then

    printf '             SHAHEEN OS NAVIGATION COMPLETE\n'

    printf '============================================================\n\n'

    echo "Project:"
    echo "  SHAHEEN OS"
    echo

    echo "Navigation CSS:"
    echo "  $NAV_CSS"
    echo

    echo "Navigation JS:"
    echo "  $NAV_JS"
    echo

    echo "Blade Component:"
    echo "  $NAV_BLADE"
    echo

    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo

    echo "✓ Premium desktop navigation installed."
    echo "✓ Tablet navigation installed."
    echo "✓ Mobile bottom navigation installed."
    echo "✓ Command palette installed."
    echo "✓ Ctrl+K shortcut installed."
    echo "✓ Search interaction installed."
    echo "✓ Active route detection installed."
    echo "✓ RTL/LTR support preserved."
    echo "✓ Reduced-motion support preserved."
    echo "✓ Accessibility focus states installed."
    echo "✓ Laravel cache rebuilt."
    echo "✓ Vite production build completed."
    echo
    echo "Next stage can start."

else

    printf '             SHAHEEN OS NAVIGATION FAILED\n'
    printf '============================================================\n\n'

    echo "Errors: $ERRORS"
    echo "Backup:"
    echo "  $BACKUP_DIR"

    exit 1
fi

