#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

PROJECT_NAME="SHAHEEN OS"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

CSS_FILE="resources/css/shaheen-os-home.css"
JS_FILE="resources/js/shaheen-os-home.js"
COMPONENT_FILE="resources/views/components/shaheen-home.blade.php"

BRAND_DIR="public/brand"
HOME_DIR="public/brand/home"

ERRORS=0

printf '\n'
printf '%s\n' '=============================================================='
printf '%s\n' '             SHAHEEN OS — PREMIUM HOMEPAGE'
printf '%s\n' '=============================================================='
printf '\n'

###############################################################################
# 1. VALIDATE PROJECT
###############################################################################

printf '%s\n' '[1/12] Validating SHAHEEN OS project...'

if [[ ! -f "$PROJECT_ROOT/artisan" ]]; then
    echo "ERROR: Laravel artisan was not found."
    exit 1
fi

if [[ ! -d "$PROJECT_ROOT/resources" ]]; then
    echo "ERROR: resources directory was not found."
    exit 1
fi

if [[ ! -d "$PROJECT_ROOT/public" ]]; then
    echo "ERROR: public directory was not found."
    exit 1
fi

echo "✓ Laravel project detected."
echo "✓ SHAHEEN OS project root validated."

###############################################################################
# 2. CREATE BACKUP
###############################################################################

printf '\n%s\n' '[2/12] Creating backup...'

mkdir -p "$BACKUP_DIR"

for FILE in \
    "$CSS_FILE" \
    "$JS_FILE" \
    "$COMPONENT_FILE"
do
    if [[ -f "$FILE" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$FILE")"
        cp -a "$FILE" "$BACKUP_DIR/$FILE"
    fi
done

echo "✓ Backup created:"
echo "  $BACKUP_DIR"

###############################################################################
# 3. CREATE DIRECTORIES
###############################################################################

printf '\n%s\n' '[3/12] Creating premium UI directories...'

mkdir -p \
    resources/css \
    resources/js \
    resources/views/components \
    "$BRAND_DIR" \
    "$HOME_DIR"

echo "✓ UI directories ready."

###############################################################################
# 4. PREMIUM HOMEPAGE CSS
###############################################################################

printf '\n%s\n' '[4/12] Creating SHAHEEN OS premium homepage CSS...'

cat > "$CSS_FILE" <<'CSS'
:root {
    --shaheen-bg: #050507;
    --shaheen-bg-soft: #0a0b0f;
    --shaheen-panel: rgba(255, 255, 255, 0.045);
    --shaheen-panel-strong: rgba(255, 255, 255, 0.075);
    --shaheen-border: rgba(255, 255, 255, 0.11);
    --shaheen-text: #ffffff;
    --shaheen-text-soft: rgba(255, 255, 255, 0.68);
    --shaheen-text-muted: rgba(255, 255, 255, 0.45);
    --shaheen-gold: #e5c158;
    --shaheen-gold-soft: rgba(229, 193, 88, 0.18);
    --shaheen-radius-xl: 32px;
    --shaheen-radius-lg: 24px;
    --shaheen-radius-md: 18px;
    --shaheen-shadow: 0 30px 90px rgba(0, 0, 0, 0.45);
}

.shaheen-home {
    position: relative;
    isolation: isolate;
    overflow: hidden;
    min-height: 100vh;
    background:
        radial-gradient(
            circle at 82% 8%,
            rgba(229, 193, 88, 0.12),
            transparent 28%
        ),
        radial-gradient(
            circle at 12% 34%,
            rgba(255, 255, 255, 0.045),
            transparent 25%
        ),
        var(--shaheen-bg);
    color: var(--shaheen-text);
}

.shaheen-home::before {
    content: "";
    position: absolute;
    inset: 0;
    z-index: -2;
    pointer-events: none;
    background-image:
        linear-gradient(
            rgba(255,255,255,0.025) 1px,
            transparent 1px
        ),
        linear-gradient(
            90deg,
            rgba(255,255,255,0.025) 1px,
            transparent 1px
        );
    background-size: 56px 56px;
    mask-image: linear-gradient(
        to bottom,
        black,
        transparent 85%
    );
}

.shaheen-home::after {
    content: "";
    position: absolute;
    width: 520px;
    height: 520px;
    top: 80px;
    right: -220px;
    border-radius: 50%;
    border: 1px solid rgba(229, 193, 88, 0.16);
    box-shadow:
        0 0 0 80px rgba(229, 193, 88, 0.025),
        0 0 0 160px rgba(229, 193, 88, 0.018);
    pointer-events: none;
    z-index: -1;
}

.shaheen-home-shell {
    width: min(1400px, calc(100% - 48px));
    margin-inline: auto;
}

.shaheen-home-hero {
    position: relative;
    min-height: 780px;
    display: grid;
    align-items: center;
    padding: 110px 0 90px;
}

.shaheen-home-hero-grid {
    display: grid;
    grid-template-columns: minmax(0, 1.05fr) minmax(360px, 0.95fr);
    gap: 70px;
    align-items: center;
}

.shaheen-home-eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 9px 14px;
    border: 1px solid var(--shaheen-border);
    border-radius: 999px;
    background: rgba(255,255,255,0.035);
    color: var(--shaheen-text-soft);
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    backdrop-filter: blur(18px);
}

.shaheen-home-eyebrow::before {
    content: "";
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--shaheen-gold);
    box-shadow: 0 0 18px rgba(229,193,88,0.85);
}

.shaheen-home-title {
    max-width: 850px;
    margin: 24px 0 0;
    font-size: clamp(48px, 7vw, 104px);
    line-height: 0.96;
    letter-spacing: -0.055em;
    font-weight: 850;
}

.shaheen-home-title-accent {
    color: var(--shaheen-gold);
}

.shaheen-home-description {
    max-width: 690px;
    margin: 30px 0 0;
    color: var(--shaheen-text-soft);
    font-size: clamp(17px, 2vw, 21px);
    line-height: 1.8;
}

.shaheen-home-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
    margin-top: 38px;
}

.shaheen-home-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 54px;
    padding: 0 24px;
    border: 1px solid transparent;
    border-radius: 16px;
    text-decoration: none;
    font-size: 14px;
    font-weight: 800;
    transition:
        transform 260ms ease,
        border-color 260ms ease,
        background 260ms ease,
        box-shadow 260ms ease;
}

.shaheen-home-button:hover {
    transform: translateY(-3px);
}

.shaheen-home-button-primary {
    color: #050507;
    background: var(--shaheen-gold);
    box-shadow: 0 14px 40px rgba(229,193,88,0.18);
}

.shaheen-home-button-primary:hover {
    box-shadow: 0 20px 55px rgba(229,193,88,0.27);
}

.shaheen-home-button-secondary {
    color: var(--shaheen-text);
    background: rgba(255,255,255,0.035);
    border-color: var(--shaheen-border);
    backdrop-filter: blur(16px);
}

.shaheen-home-button-secondary:hover {
    background: rgba(255,255,255,0.075);
    border-color: rgba(255,255,255,0.2);
}

.shaheen-home-metrics {
    display: flex;
    flex-wrap: wrap;
    gap: 28px;
    margin-top: 48px;
}

.shaheen-home-metric {
    min-width: 120px;
}

.shaheen-home-metric-value {
    display: block;
    font-size: 24px;
    font-weight: 850;
    letter-spacing: -0.03em;
}

.shaheen-home-metric-label {
    display: block;
    margin-top: 5px;
    color: var(--shaheen-text-muted);
    font-size: 12px;
}

.shaheen-home-orbit {
    position: relative;
    width: min(100%, 560px);
    aspect-ratio: 1;
    margin-inline: auto;
    display: grid;
    place-items: center;
}

.shaheen-home-orbit-ring {
    position: absolute;
    inset: 8%;
    border: 1px solid rgba(255,255,255,0.10);
    border-radius: 50%;
}

.shaheen-home-orbit-ring:nth-child(2) {
    inset: 19%;
    border-color: rgba(229,193,88,0.22);
}

.shaheen-home-orbit-ring:nth-child(3) {
    inset: 31%;
    border-style: dashed;
    border-color: rgba(255,255,255,0.10);
}

.shaheen-home-core {
    position: relative;
    width: 42%;
    aspect-ratio: 1;
    display: grid;
    place-items: center;
    border: 1px solid rgba(229,193,88,0.35);
    border-radius: 50%;
    background:
        radial-gradient(
            circle,
            rgba(229,193,88,0.19),
            rgba(255,255,255,0.025) 58%,
            rgba(255,255,255,0.01)
        );
    box-shadow:
        0 0 80px rgba(229,193,88,0.12),
        inset 0 0 60px rgba(255,255,255,0.025);
    backdrop-filter: blur(22px);
}

.shaheen-home-core-symbol {
    font-size: clamp(42px, 7vw, 76px);
    font-weight: 900;
    letter-spacing: -0.08em;
    color: var(--shaheen-gold);
}

.shaheen-home-orbit-dot {
    position: absolute;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: var(--shaheen-gold);
    box-shadow: 0 0 22px rgba(229,193,88,0.9);
}

.shaheen-home-orbit-dot-one {
    top: 12%;
    left: 50%;
}

.shaheen-home-orbit-dot-two {
    right: 15%;
    bottom: 25%;
}

.shaheen-home-orbit-dot-three {
    left: 17%;
    bottom: 29%;
}

.shaheen-home-section {
    padding: 110px 0;
}

.shaheen-home-section-header {
    display: flex;
    justify-content: space-between;
    align-items: end;
    gap: 30px;
    margin-bottom: 42px;
}

.shaheen-home-section-kicker {
    color: var(--shaheen-gold);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.16em;
    text-transform: uppercase;
}

.shaheen-home-section-title {
    max-width: 760px;
    margin: 10px 0 0;
    font-size: clamp(34px, 5vw, 62px);
    line-height: 1;
    letter-spacing: -0.045em;
}

.shaheen-home-section-description {
    max-width: 620px;
    color: var(--shaheen-text-soft);
    line-height: 1.8;
}

.shaheen-home-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 18px;
}

.shaheen-home-card {
    position: relative;
    min-height: 280px;
    padding: 28px;
    overflow: hidden;
    border: 1px solid var(--shaheen-border);
    border-radius: var(--shaheen-radius-lg);
    background: linear-gradient(
        145deg,
        rgba(255,255,255,0.065),
        rgba(255,255,255,0.018)
    );
    box-shadow: var(--shaheen-shadow);
    transition:
        transform 320ms ease,
        border-color 320ms ease,
        background 320ms ease;
}

.shaheen-home-card:hover {
    transform: translateY(-8px);
    border-color: rgba(229,193,88,0.28);
    background: linear-gradient(
        145deg,
        rgba(229,193,88,0.08),
        rgba(255,255,255,0.025)
    );
}

.shaheen-home-card-number {
    color: var(--shaheen-gold);
    font-size: 12px;
    font-weight: 900;
    letter-spacing: 0.14em;
}

.shaheen-home-card-icon {
    width: 56px;
    height: 56px;
    margin: 36px 0 24px;
    display: grid;
    place-items: center;
    border: 1px solid var(--shaheen-border);
    border-radius: 17px;
    background: rgba(255,255,255,0.04);
    font-size: 22px;
}

.shaheen-home-card-title {
    margin: 0;
    font-size: 23px;
    letter-spacing: -0.025em;
}

.shaheen-home-card-description {
    margin: 12px 0 0;
    color: var(--shaheen-text-soft);
    line-height: 1.7;
}

.shaheen-home-showcase {
    display: grid;
    grid-template-columns: 0.8fr 1.2fr;
    gap: 22px;
}

.shaheen-home-showcase-main {
    min-height: 480px;
    padding: 42px;
    border-radius: var(--shaheen-radius-xl);
    border: 1px solid rgba(229,193,88,0.18);
    background:
        radial-gradient(
            circle at 80% 20%,
            rgba(229,193,88,0.14),
            transparent 34%
        ),
        linear-gradient(
            145deg,
            rgba(255,255,255,0.065),
            rgba(255,255,255,0.018)
        );
    box-shadow: var(--shaheen-shadow);
}

.shaheen-home-showcase-side {
    display: grid;
    gap: 22px;
}

.shaheen-home-mini-card {
    min-height: 229px;
    padding: 30px;
    border: 1px solid var(--shaheen-border);
    border-radius: var(--shaheen-radius-lg);
    background: var(--shaheen-panel);
}

.shaheen-home-mini-card strong {
    display: block;
    font-size: 19px;
}

.shaheen-home-mini-card p {
    margin: 12px 0 0;
    color: var(--shaheen-text-soft);
    line-height: 1.7;
}

.shaheen-home-cta {
    position: relative;
    overflow: hidden;
    padding: 70px;
    border: 1px solid rgba(229,193,88,0.25);
    border-radius: var(--shaheen-radius-xl);
    background:
        radial-gradient(
            circle at 85% 20%,
            rgba(229,193,88,0.18),
            transparent 30%
        ),
        rgba(255,255,255,0.035);
    text-align: center;
    box-shadow: var(--shaheen-shadow);
}

.shaheen-home-cta h2 {
    max-width: 820px;
    margin: 0 auto;
    font-size: clamp(38px, 6vw, 72px);
    line-height: 1;
    letter-spacing: -0.05em;
}

.shaheen-home-cta p {
    max-width: 650px;
    margin: 24px auto 0;
    color: var(--shaheen-text-soft);
    line-height: 1.8;
}

.shaheen-home-cta .shaheen-home-actions {
    justify-content: center;
}

.shaheen-home-footer {
    padding: 38px 0;
    border-top: 1px solid var(--shaheen-border);
}

.shaheen-home-footer-inner {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
}

.shaheen-home-footer-brand {
    font-weight: 850;
    letter-spacing: 0.08em;
}

.shaheen-home-footer-copy {
    color: var(--shaheen-text-muted);
    font-size: 12px;
}

@media (max-width: 1100px) {
    .shaheen-home-hero-grid {
        grid-template-columns: 1fr;
        gap: 35px;
    }

    .shaheen-home-hero {
        min-height: auto;
    }

    .shaheen-home-orbit {
        max-width: 470px;
    }

    .shaheen-home-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .shaheen-home-showcase {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 700px) {
    .shaheen-home-shell {
        width: min(100% - 28px, 1400px);
    }

    .shaheen-home-hero {
        padding: 72px 0 60px;
    }

    .shaheen-home-title {
        font-size: clamp(43px, 15vw, 72px);
    }

    .shaheen-home-description {
        font-size: 16px;
        line-height: 1.75;
    }

    .shaheen-home-actions {
        flex-direction: column;
    }

    .shaheen-home-button {
        width: 100%;
    }

    .shaheen-home-metrics {
        gap: 20px;
    }

    .shaheen-home-section {
        padding: 75px 0;
    }

    .shaheen-home-section-header {
        display: block;
    }

    .shaheen-home-section-description {
        margin-top: 20px;
    }

    .shaheen-home-grid {
        grid-template-columns: 1fr;
    }

    .shaheen-home-showcase-main {
        min-height: 380px;
        padding: 28px;
    }

    .shaheen-home-mini-card {
        min-height: 190px;
    }

    .shaheen-home-cta {
        padding: 48px 24px;
    }

    .shaheen-home-footer-inner {
        flex-direction: column;
        text-align: center;
    }
}

@media (prefers-reduced-motion: reduce) {
    .shaheen-home *,
    .shaheen-home *::before,
    .shaheen-home *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}
CSS

echo "✓ Premium homepage CSS created."

###############################################################################
# 5. PREMIUM HOMEPAGE JAVASCRIPT
###############################################################################

printf '\n%s\n' '[5/12] Creating homepage interaction layer...'

cat > "$JS_FILE" <<'JS'
(function () {
    "use strict";

    const root = document.querySelector(".shaheen-home");

    if (!root) {
        return;
    }

    const reducedMotion = window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;

    if (reducedMotion) {
        return;
    }

    const orbit = root.querySelector(".shaheen-home-orbit");

    if (orbit) {
        let frame = null;

        root.addEventListener("pointermove", function (event) {
            if (frame) {
                cancelAnimationFrame(frame);
            }

            frame = requestAnimationFrame(function () {
                const rect = root.getBoundingClientRect();

                const x =
                    ((event.clientX - rect.left) / rect.width - 0.5) * 2;

                const y =
                    ((event.clientY - rect.top) / rect.height - 0.5) * 2;

                orbit.style.transform =
                    "perspective(900px) rotateX(" +
                    (-y * 3) +
                    "deg) rotateY(" +
                    (x * 4) +
                    "deg)";
            });
        });

        root.addEventListener("pointerleave", function () {
            orbit.style.transform =
                "perspective(900px) rotateX(0deg) rotateY(0deg)";
        });
    }

    const cards = root.querySelectorAll(".shaheen-home-card");

    cards.forEach(function (card) {
        card.addEventListener("pointermove", function (event) {
            const rect = card.getBoundingClientRect();

            const x =
                ((event.clientX - rect.left) / rect.width - 0.5) * 2;

            const y =
                ((event.clientY - rect.top) / rect.height - 0.5) * 2;

            card.style.transform =
                "perspective(900px) rotateX(" +
                (-y * 2) +
                "deg) rotateY(" +
                (x * 2) +
                "deg) translateY(-8px)";
        });

        card.addEventListener("pointerleave", function () {
            card.style.transform = "";
        });
    });
})();
JS

echo "✓ Homepage interaction layer created."

###############################################################################
# 6. PREMIUM BLADE COMPONENT
###############################################################################

printf '\n%s\n' '[6/12] Creating SHAHEEN OS premium homepage component...'

cat > "$COMPONENT_FILE" <<'BLADE'
@php
    $shaheenHomeFeatures = [
        [
            'number' => '01',
            'icon' => '✦',
            'title' => 'Marketplace',
            'description' => 'A premium marketplace experience for discovering, buying and selling products with a clean local-first flow.',
        ],
        [
            'number' => '02',
            'icon' => '◈',
            'title' => 'Smart Discovery',
            'description' => 'Organize categories, listings and recommendations into a fast interface designed for modern devices.',
        ],
        [
            'number' => '03',
            'icon' => '⌘',
            'title' => 'Powerful Workspace',
            'description' => 'A flexible foundation ready for tools, services, integrations and future SHAHEEN OS modules.',
        ],
    ];
@endphp

<section
    class="shaheen-home"
    dir="rtl"
    data-shaheen-home
>
    <div class="shaheen-home-shell">

        {{-- HERO --}}
        <section class="shaheen-home-hero">
            <div class="shaheen-home-hero-grid">

                <div
                    data-shaheen-reveal="fade-up"
                    data-shaheen-stagger
                >
                    <span class="shaheen-home-eyebrow">
                        SHAHEEN OS · NEXT GENERATION PLATFORM
                    </span>

                    <h1 class="shaheen-home-title">
                        تجربة رقمية
                        <span class="shaheen-home-title-accent">
                            بمستوى عالمي
                        </span>
                        .
                    </h1>

                    <p class="shaheen-home-description">
                        SHAHEEN OS منصة رقمية حديثة تجمع التجارة والخدمات
                        والأدوات والتجارب الذكية داخل واجهة واحدة مصممة
                        لتكون سريعة، فخمة، مرنة وقابلة للتوسع.
                    </p>

                    <div class="shaheen-home-actions">
                        <a
                            href="#shaheen-explore"
                            class="shaheen-home-button shaheen-home-button-primary"
                            data-shaheen-motion
                        >
                            استكشف SHAHEEN OS
                        </a>

                        <a
                            href="#shaheen-features"
                            class="shaheen-home-button shaheen-home-button-secondary"
                            data-shaheen-motion
                        >
                            اكتشف المنصة
                        </a>
                    </div>

                    <div class="shaheen-home-metrics">
                        <div class="shaheen-home-metric">
                            <span class="shaheen-home-metric-value">01</span>
                            <span class="shaheen-home-metric-label">
                                منصة موحدة
                            </span>
                        </div>

                        <div class="shaheen-home-metric">
                            <span class="shaheen-home-metric-value">∞</span>
                            <span class="shaheen-home-metric-label">
                                قابلية التوسع
                            </span>
                        </div>

                        <div class="shaheen-home-metric">
                            <span class="shaheen-home-metric-value">RTL</span>
                            <span class="shaheen-home-metric-label">
                                Arabic First
                            </span>
                        </div>
                    </div>
                </div>

                <div
                    class="shaheen-home-orbit"
                    data-shaheen-reveal="zoom"
                    aria-hidden="true"
                >
                    <span class="shaheen-home-orbit-ring"></span>
                    <span class="shaheen-home-orbit-ring"></span>
                    <span class="shaheen-home-orbit-ring"></span>

                    <span class="shaheen-home-orbit-dot shaheen-home-orbit-dot-one"></span>
                    <span class="shaheen-home-orbit-dot shaheen-home-orbit-dot-two"></span>
                    <span class="shaheen-home-orbit-dot shaheen-home-orbit-dot-three"></span>

                    <div class="shaheen-home-core">
                        <span class="shaheen-home-core-symbol">S</span>
                    </div>
                </div>

            </div>
        </section>

        {{-- FEATURES --}}
        <section
            id="shaheen-features"
            class="shaheen-home-section"
        >
            <div class="shaheen-home-section-header">
                <div>
                    <div class="shaheen-home-section-kicker">
                        SHAHEEN OS
                    </div>

                    <h2 class="shaheen-home-section-title">
                        أكثر من واجهة.
                        <br>
                        منظومة كاملة.
                    </h2>
                </div>

                <p class="shaheen-home-section-description">
                    تم بناء الهوية والواجهة لتكون أساسًا لمنصة كبيرة،
                    وليس مجرد صفحة تسويقية. كل عنصر قابل للتوسع وإعادة الاستخدام.
                </p>
            </div>

            <div class="shaheen-home-grid">
                @foreach ($shaheenHomeFeatures as $feature)
                    <article
                        class="shaheen-home-card"
                        data-shaheen-reveal="fade-up"
                        data-shaheen-stagger
                    >
                        <div class="shaheen-home-card-number">
                            {{ $feature['number'] }}
                        </div>

                        <div class="shaheen-home-card-icon">
                            {{ $feature['icon'] }}
                        </div>

                        <h3 class="shaheen-home-card-title">
                            {{ $feature['title'] }}
                        </h3>

                        <p class="shaheen-home-card-description">
                            {{ $feature['description'] }}
                        </p>
                    </article>
                @endforeach
            </div>
        </section>

        {{-- SHOWCASE --}}
        <section
            id="shaheen-explore"
            class="shaheen-home-section"
        >
            <div class="shaheen-home-showcase">

                <div
                    class="shaheen-home-showcase-main"
                    data-shaheen-reveal="fade-right"
                >
                    <div class="shaheen-home-section-kicker">
                        THE SHAHEEN EXPERIENCE
                    </div>

                    <h2 class="shaheen-home-section-title">
                        كل ما تحتاجه
                        <span class="shaheen-home-title-accent">
                            في مكان واحد.
                        </span>
                    </h2>

                    <p class="shaheen-home-section-description">
                        واجهة مرنة يمكن أن تستوعب التجارة الإلكترونية،
                        الخدمات، الأدوات، المتجر، الحسابات، المساحات الشخصية
                        والمكونات المستقبلية لمنظومة SHAHEEN OS.
                    </p>

                    <div class="shaheen-home-actions">
                        <a
                            href="#shaheen-start"
                            class="shaheen-home-button shaheen-home-button-primary"
                        >
                            ابدأ الآن
                        </a>
                    </div>
                </div>

                <div class="shaheen-home-showcase-side">

                    <article
                        class="shaheen-home-mini-card"
                        data-shaheen-reveal="fade-left"
                    >
                        <strong>واجهة موحدة</strong>

                        <p>
                            تجربة متناسقة عبر الهاتف والتابلت وسطح المكتب
                            والشاشات الكبيرة.
                        </p>
                    </article>

                    <article
                        class="shaheen-home-mini-card"
                        data-shaheen-reveal="fade-left"
                    >
                        <strong>تصميم متجاوب</strong>

                        <p>
                            تخطيط مرن يتكيف مع جميع المقاسات دون التضحية
                            بالتفاصيل البصرية.
                        </p>
                    </article>

                </div>
            </div>
        </section>

        {{-- CTA --}}
        <section
            id="shaheen-start"
            class="shaheen-home-section"
        >
            <div
                class="shaheen-home-cta"
                data-shaheen-reveal="zoom"
            >
                <h2>
                    مستقبل المنصة
                    <span class="shaheen-home-title-accent">
                        يبدأ هنا.
                    </span>
                </h2>

                <p>
                    SHAHEEN OS — هوية رقمية فاخرة، تجربة سلسة،
                    وبنية قابلة للنمو إلى منظومة عالمية.
                </p>

                <div class="shaheen-home-actions">
                    <a
                        href="#top"
                        class="shaheen-home-button shaheen-home-button-primary"
                    >
                        العودة إلى الأعلى
                    </a>
                </div>
            </div>
        </section>

    </div>

    <footer class="shaheen-home-footer">
        <div class="shaheen-home-shell">
            <div class="shaheen-home-footer-inner">
                <div class="shaheen-home-footer-brand">
                    SHAHEEN OS
                </div>

                <div class="shaheen-home-footer-copy">
                    © {{ date('Y') }} SHAHEEN OS · All Rights Reserved
                </div>
            </div>
        </div>
    </footer>
</section>
BLADE

echo "✓ Premium Blade component created."

###############################################################################
# 7. CREATE BRAND METADATA
###############################################################################

printf '\n%s\n' '[7/12] Creating homepage brand metadata...'

cat > "$HOME_DIR/README.md" <<'EOF'
# SHAHEEN OS — Premium Homepage

This directory contains SHAHEEN OS homepage brand assets.

Project:
SHAHEEN OS

Identity:
Premium / Futuristic / Minimal / Responsive

Primary language:
Arabic RTL

Supported:
Mobile
Tablet
Desktop
Large Screens
Reduced Motion
