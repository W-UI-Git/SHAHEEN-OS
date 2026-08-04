#!/usr/bin/env bash

###############################################################################
# SHAHEEN ON — GLOBAL BRAND ASSET BUILDER
# Version: 1.0.0
# Purpose:
#   Generate the complete SHAHEEN ON visual identity asset system
#   using ImageMagick.
###############################################################################

set -Eeuo pipefail

PROJECT_DIR="${PROJECT_DIR:-$HOME/sooq-app}"

BRAND_NAME="SHAHEEN ON"
BRAND_SLUG="shaheen-on"

BRAND_DIR="$PROJECT_DIR/public/brand"
LOGO_DIR="$BRAND_DIR/logo"
ICON_DIR="$BRAND_DIR/icons"
SOCIAL_DIR="$BRAND_DIR/social"
APP_DIR="$BRAND_DIR/app"
FAVICON_DIR="$BRAND_DIR/favicon"
OG_DIR="$BRAND_DIR/og"
SOURCE_DIR="$BRAND_DIR/source"

###############################################################################
# COLORS
###############################################################################

BLACK="#050507"
OBSIDIAN="#090A0D"
GRAPHITE="#15171B"
SILVER="#D7D9DE"
WHITE="#FFFFFF"
GOLD="#D6B45A"
GOLD_LIGHT="#F1D98A"
GOLD_DARK="#8E712B"

###############################################################################
# CHECKS
###############################################################################

echo
echo "============================================================"
echo " SHAHEEN ON — BRAND BUILDER"
echo "============================================================"
echo

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "ERROR: Project directory does not exist:"
    echo "$PROJECT_DIR"
    exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
    echo "ERROR: ImageMagick is not installed."
    echo
    echo "Install it with:"
    echo
    echo "apt update && apt install -y imagemagick"
    echo
    exit 1
fi

cd "$PROJECT_DIR"

###############################################################################
# DIRECTORIES
###############################################################################

echo "[1/10] Creating brand directories..."

mkdir -p \
    "$BRAND_DIR" \
    "$LOGO_DIR" \
    "$ICON_DIR" \
    "$SOCIAL_DIR" \
    "$APP_DIR" \
    "$FAVICON_DIR" \
    "$OG_DIR" \
    "$SOURCE_DIR"

###############################################################################
# BRAND METADATA
###############################################################################

cat > "$BRAND_DIR/brand.json" <<EOF
{
  "name": "SHAHEEN ON",
  "slug": "shaheen-on",
  "version": "1.0.0",
  "visual_style": "Luxury Futuristic",
  "primary": "#050507",
  "obsidian": "#090A0D",
  "graphite": "#15171B",
  "silver": "#D7D9DE",
  "white": "#FFFFFF",
  "gold": "#D6B45A",
  "gold_light": "#F1D98A",
  "gold_dark": "#8E712B"
}
EOF

###############################################################################
# SVG SYMBOL
###############################################################################

echo "[2/10] Creating SHAHEEN ON symbol..."

cat > "$SOURCE_DIR/shaheen-on-symbol.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg"
     width="1024"
     height="1024"
     viewBox="0 0 1024 1024">

  <defs>
    <linearGradient id="gold"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="1">
      <stop offset="0%" stop-color="#F1D98A"/>
      <stop offset="45%" stop-color="#D6B45A"/>
      <stop offset="100%" stop-color="#8E712B"/>
    </linearGradient>

    <linearGradient id="metal"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="1">
      <stop offset="0%" stop-color="#FFFFFF"/>
      <stop offset="50%" stop-color="#D7D9DE"/>
      <stop offset="100%" stop-color="#777B83"/>
    </linearGradient>
  </defs>

  <rect
      width="1024"
      height="1024"
      rx="220"
      fill="#050507"/>

  <!-- Outer ring -->
  <circle
      cx="512"
      cy="512"
      r="360"
      fill="none"
      stroke="#15171B"
      stroke-width="10"/>

  <circle
      cx="512"
      cy="512"
      r="330"
      fill="none"
      stroke="#D6B45A"
      stroke-opacity=".35"
      stroke-width="3"/>

  <!-- Abstract falcon / S geometry -->

  <path
      d="M700 270
         L540 350
         L365 330
         L285 395
         L455 430
         L600 405
         L515 470
         L325 515
         L420 560
         L605 525
         L520 625
         L360 700
         L515 675
         L700 530
         L600 500
         L700 430
         L600 390
         Z"
      fill="url(#gold)"/>

  <path
      d="M300 395
         L455 430
         L600 405
         L515 470
         L325 515"
      fill="none"
      stroke="url(#metal)"
      stroke-width="14"
      stroke-linecap="round"
      stroke-linejoin="round"/>

  <!-- Center point -->

  <circle
      cx="512"
      cy="512"
      r="9"
      fill="#FFFFFF"/>

</svg>
EOF

###############################################################################
# WORDMARK SVG
###############################################################################

echo "[3/10] Creating wordmark..."

cat > "$SOURCE_DIR/shaheen-on-wordmark.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg"
     width="1800"
     height="500"
     viewBox="0 0 1800 500">

  <defs>

    <linearGradient id="gold"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="1">
      <stop offset="0%" stop-color="#F1D98A"/>
      <stop offset="50%" stop-color="#D6B45A"/>
      <stop offset="100%" stop-color="#8E712B"/>
    </linearGradient>

  </defs>

  <rect
      width="1800"
      height="500"
      fill="#050507"/>

  <text
      x="900"
      y="285"
      text-anchor="middle"
      font-family="DejaVu Sans"
      font-size="170"
      font-weight="700"
      letter-spacing="18"
      fill="url(#gold)">
      SHAHEEN ON
  </text>

  <rect
      x="600"
      y="330"
      width="600"
      height="3"
      fill="#D6B45A"
      opacity=".55"/>

</svg>
EOF

###############################################################################
# HORIZONTAL LOGO
###############################################################################

echo "[4/10] Creating horizontal logo..."

cat > "$LOGO_DIR/shaheen-on-horizontal.svg" <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg"
     width="1800"
     height="500"
     viewBox="0 0 1800 500">

  <defs>
    <linearGradient id="gold"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="1">
      <stop offset="0%" stop-color="#F1D98A"/>
      <stop offset="50%" stop-color="#D6B45A"/>
      <stop offset="100%" stop-color="#8E712B"/>
    </linearGradient>
  </defs>

  <rect width="1800" height="500" fill="#050507"/>

  <circle
      cx="250"
      cy="250"
      r="155"
      fill="none"
      stroke="#15171B"
      stroke-width="12"/>

  <path
      d="M360 120
         L275 165
         L190 150
         L145 190
         L230 210
         L310 195
         L260 235
         L165 260
         L220 290
         L315 270
         L260 330
         L180 365
         L260 350
         L360 275
         L310 245
         L360 200
         L310 175
         Z"
      fill="url(#gold)"/>

  <text
      x="490"
      y="290"
      font-family="DejaVu Sans"
      font-size="150"
      font-weight="700"
      letter-spacing="12"
      fill="#FFFFFF">
      SHAHEEN
  </text>

  <text
      x="500"
      y="385"
      font-family="DejaVu Sans"
      font-size="78"
      font-weight="400"
      letter-spacing="25"
      fill="#D6B45A">
      ON
  </text>

</svg>
EOF

###############################################################################
# COPY SYMBOL
###############################################################################

cp "$SOURCE_DIR/shaheen-on-symbol.svg" \
   "$LOGO_DIR/shaheen-on-symbol.svg"

cp "$SOURCE_DIR/shaheen-on-wordmark.svg" \
   "$LOGO_DIR/shaheen-on-wordmark.svg"

###############################################################################
# PNG RENDERING
###############################################################################

echo "[5/10] Rendering PNG logo assets..."

magick "$SOURCE_DIR/shaheen-on-symbol.svg" \
    -background none \
    -resize 1024x1024 \
    "$LOGO_DIR/shaheen-on-symbol.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 512x512 \
    "$APP_DIR/icon-512.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 256x256 \
    "$APP_DIR/icon-256.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 192x192 \
    "$APP_DIR/icon-192.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 144x144 \
    "$APP_DIR/icon-144.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 128x128 \
    "$APP_DIR/icon-128.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 96x96 \
    "$APP_DIR/icon-96.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 72x72 \
    "$APP_DIR/icon-72.png"

###############################################################################
# FAVICONS
###############################################################################

echo "[6/10] Creating favicons..."

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 48x48 \
    "$FAVICON_DIR/favicon-48.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 32x32 \
    "$FAVICON_DIR/favicon-32.png"

magick "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 16x16 \
    "$FAVICON_DIR/favicon-16.png"

magick "$FAVICON_DIR/favicon-16.png" \
        "$FAVICON_DIR/favicon-32.png" \
        "$FAVICON_DIR/favicon-48.png" \
        "$FAVICON_DIR/favicon.ico"

###############################################################################
# SOCIAL OG
###############################################################################

echo "[7/10] Creating social media assets..."

magick \
    -size 1200x630 \
    "gradient:$BLACK-$OBSIDIAN" \
    -gravity center \
    -fill "$GOLD" \
    -font DejaVu-Sans \
    -pointsize 92 \
    -weight Bold \
    -annotate +0-20 "SHAHEEN ON" \
    -fill "$SILVER" \
    -pointsize 30 \
    -weight Normal \
    -annotate +0+85 "NEXT-GENERATION MARKETPLACE" \
    "$SOCIAL_DIR/og-image.png"

magick \
    "$SOCIAL_DIR/og-image.png" \
    -resize 1200x675^ \
    -gravity center \
    -extent 1200x675 \
    "$SOCIAL_DIR/twitter-card.png"

magick \
    "$SOCIAL_DIR/og-image.png" \
    -resize 1200x627^ \
    -gravity center \
    -extent 1200x627 \
    "$SOCIAL_DIR/linkedin.png"

###############################################################################
# PROFILE
###############################################################################

echo "[8/10] Creating profile assets..."

magick \
    "$LOGO_DIR/shaheen-on-symbol.png" \
    -resize 1080x1080^ \
    -gravity center \
    -extent 1080x1080 \
    "$SOCIAL_DIR/profile-1080.png"

###############################################################################
# WEBP
###############################################################################

echo "[9/10] Creating optimized WebP assets..."

find "$BRAND_DIR" \
    -type f \
    -name "*.png" \
    -print0 |
while IFS= read -r -d '' file; do

    output="${file%.png}.webp"

    magick "$file" \
        -quality 92 \
        "$output"

done

###############################################################################
# BRAND README
###############################################################################

cat > "$BRAND_DIR/README.md" <<EOF
# SHAHEEN ON

Global visual identity package.

## Brand

Name:
SHAHEEN ON

Style:
Luxury Futuristic Marketplace

## Colors

- Obsidian: $BLACK
- Graphite: $GRAPHITE
- Silver: $SILVER
- White: $WHITE
- Gold: $GOLD
- Gold Light: $GOLD_LIGHT
- Gold Dark: $GOLD_DARK

## Structure

- logo/
- icons/
- social/
- app/
- favicon/
- og/
- source/

Generated with ImageMagick.
EOF

###############################################################################
# PERMISSIONS
###############################################################################

echo "[10/10] Finalizing..."

chmod -R u+rwX "$BRAND_DIR"

echo
echo "============================================================"
echo " SHAHEEN ON BRAND BUILD COMPLETE"
echo "============================================================"
echo
echo "Brand directory:"
echo "$BRAND_DIR"
echo
echo "Main logo:"
echo "$LOGO_DIR/shaheen-on-horizontal.svg"
echo
echo "Symbol:"
echo "$LOGO_DIR/shaheen-on-symbol.svg"
echo
echo "Favicon:"
echo "$FAVICON_DIR/favicon.ico"
echo
echo "Social:"
echo "$SOCIAL_DIR/og-image.png"
echo
echo "App icons:"
echo "$APP_DIR"
echo
echo "============================================================"
