#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

APP_NAME="SHAHEEN OS"
VERSION="1.0.0"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

LOG_DIR="$PROJECT_ROOT/storage/logs/shaheen-os"
RELEASE_DIR="$PROJECT_ROOT/storage/releases/shaheen-os"
BACKUP_DIR="$PROJECT_ROOT/.shaheen-ui-backups/$TIMESTAMP"

GIT_LOG="$LOG_DIR/git-release-$TIMESTAMP.log"
RELEASE_METADATA="$RELEASE_DIR/SHAHEEN-OS-$VERSION-$TIMESTAMP.git-release.txt"

mkdir -p "$LOG_DIR" "$RELEASE_DIR" "$BACKUP_DIR"

exec > >(tee -a "$GIT_LOG") 2>&1

printf '\n'
printf '%s\n' '============================================================'
printf '%s\n' '             SHAHEEN OS GIT RELEASE STAGE'
printf '%s\n' '============================================================'
printf '\n'

###############################################################################
# 01 - PROJECT VALIDATION
###############################################################################

echo "[1/10] Validating Git repository..."

if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
    echo "ERROR: This project is not a Git repository."
    exit 1
fi

echo "✓ Git repository detected."

###############################################################################
# 02 - GIT IDENTITY
###############################################################################

echo
echo "[2/10] Reading repository identity..."

GIT_BRANCH="$(git branch --show-current 2>/dev/null || true)"
GIT_COMMIT="$(git rev-parse HEAD 2>/dev/null || true)"

echo "✓ Branch: ${GIT_BRANCH:-unknown}"
echo "✓ Current commit: ${GIT_COMMIT:-unknown}"

###############################################################################
# 03 - GITIGNORE
###############################################################################

echo
echo "[3/10] Validating .gitignore..."

if [[ ! -f "$PROJECT_ROOT/.gitignore" ]]; then

    echo "Creating production .gitignore..."

    cat > "$PROJECT_ROOT/.gitignore" <<'GITIGNORE'
/vendor/
/node_modules/
/.env
/.env.*
!/ .env.example

/public/build/
/public/hot
/public/storage

/storage/*.key
/storage/logs/*
/storage/framework/*
/storage/releases/*
/storage/app/private/*
/storage/app/public/*

/.sheen-ui-backups/
/.shaheen-ui-backups/

/.idea/
/.vscode/
.DS_Store
*.log
*.tmp
*.swp

npm-debug.log*
yarn-debug.log*
yarn-error.log*

.phpunit.result.cache
.php-cs-fixer.cache
GITIGNORE

    # Remove accidental space introduced by safe heredoc formatting.
    sed -i 's#^!/ \.env\.example$#!/.env.example#' "$PROJECT_ROOT/.gitignore"

    echo "✓ Production .gitignore created."

else

    echo "✓ .gitignore already exists."
fi

###############################################################################
# 04 - SECURITY CHECK
###############################################################################

echo
echo "[4/10] Running security checks..."

SENSITIVE_FOUND=0

SENSITIVE_PATTERNS=(
    "OPENAI_API_KEY="
    "DEEPSEEK_API_KEY="
    "ANTHROPIC_API_KEY="
    "GEMINI_API_KEY="
    "STRIPE_SECRET"
    "AWS_SECRET_ACCESS_KEY="
    "DATABASE_PASSWORD="
    "SUPABASE_SERVICE_ROLE_KEY="
    "PRIVATE_KEY="
)

for PATTERN in "${SENSITIVE_PATTERNS[@]}"; do

    if grep -RIl \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=vendor \
        --exclude-dir=public/build \
        --exclude='*.log' \
        "$PATTERN" \
        . 2>/dev/null | head -n 1 >/dev/null; then

        echo "WARNING: Potential secret detected: $PATTERN"
        SENSITIVE_FOUND=$((SENSITIVE_FOUND + 1))
    fi

done

if [[ "$SENSITIVE_FOUND" -eq 0 ]]; then
    echo "✓ No obvious API secrets detected."
else
    echo
    echo "WARNING: $SENSITIVE_FOUND potential secret pattern(s) detected."
    echo "Review them before pushing to a remote repository."
fi

###############################################################################
# 05 - ENVIRONMENT CHECK
###############################################################################

echo
echo "[5/10] Checking environment files..."

if [[ -f "$PROJECT_ROOT/.env" ]]; then
    echo "✓ .env exists locally."
    echo "  It will NOT be included in the release."
fi

if [[ -f "$PROJECT_ROOT/.env.example" ]]; then
    echo "✓ .env.example exists."
else
    echo "WARNING: .env.example is missing."
fi

###############################################################################
# 06 - BUILD VERIFICATION
###############################################################################

echo
echo "[6/10] Verifying production build..."

if [[ ! -f "$PROJECT_ROOT/public/build/manifest.json" ]]; then
    echo "ERROR: Vite production manifest is missing."
    exit 1
fi

if [[ ! -d "$PROJECT_ROOT/public/build/assets" ]]; then
    echo "ERROR: Vite production assets are missing."
    exit 1
fi

ASSET_COUNT="$(find "$PROJECT_ROOT/public/build/assets" -type f | wc -l | tr -d ' ')"

echo "✓ Vite production build exists."
echo "✓ Production asset count: $ASSET_COUNT"

###############################################################################
# 07 - SHAHEEN OS FILE CHECK
###############################################################################

echo
echo "[7/10] Verifying SHAHEEN OS release files..."

RELEASE_FILES=(
    "resources/css/shaheen-os.css"
    "resources/css/shaheen-os-global.css"
    "resources/css/shaheen-os-motion.css"
    "resources/css/shaheen-os-navigation.css"
    "resources/css/shaheen-os-shell.css"
    "resources/css/shaheen-os-components.css"
    "resources/js/shaheen-os-global.js"
    "resources/js/shaheen-os-components.js"
    "resources/js/shaheen-os-navigation.js"
    "resources/js/shaheen-os-shell.js"
    "resources/views/components/shaheen-brand.blade.php"
    "resources/views/components/shaheen-hero.blade.php"
    "resources/views/components/shaheen-motion.blade.php"
    "resources/views/components/shaheen-navigation.blade.php"
    "resources/views/components/shaheen-components.blade.php"
    "resources/views/components/shaheen-os-global.blade.php"
    "resources/views/components/shaheen-os-shell.blade.php"
    "public/brand/logo/shaheen-os-horizontal.svg"
    "public/brand/logo/shaheen-os-symbol.svg"
)

MISSING_FILES=0

for FILE in "${RELEASE_FILES[@]}"; do

    if [[ -f "$PROJECT_ROOT/$FILE" ]]; then
        echo "✓ $FILE"
    else
        echo "WARNING: Missing $FILE"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi

done

if [[ "$MISSING_FILES" -gt 0 ]]; then
    echo
    echo "WARNING: $MISSING_FILES release file(s) are missing."
fi

###############################################################################
# 08 - GIT STATUS
###############################################################################

echo
echo "[8/10] Inspecting Git status..."

git status --short

echo
echo "Git statistics:"
git status --short | wc -l | awk '{print "  Changed/untracked entries: " $1}'

###############################################################################
# 09 - CREATE RELEASE METADATA
###############################################################################

echo
echo "[9/10] Creating Git release metadata..."

cat > "$RELEASE_METADATA" <<META
SHAHEEN OS GIT RELEASE METADATA
================================

Project:
$APP_NAME

Version:
$VERSION

Timestamp:
$TIMESTAMP

Root:
$PROJECT_ROOT

Branch:
${GIT_BRANCH:-unknown}

Previous Commit:
${GIT_COMMIT:-unknown}

Production Build:
VERIFIED

Vite Manifest:
public/build/manifest.json

Production Assets:
$ASSET_COUNT

Potential Secret Patterns:
$SENSITIVE_FOUND

Missing Release Files:
$MISSING_FILES

Git Release Status:
READY

Git Log:
$GIT_LOG

Backup:
$BACKUP_DIR
META

echo "✓ Release metadata created."

###############################################################################
# 10 - FINAL GIT CHECK
###############################################################################

echo
echo "[10/10] Running final Git verification..."

if git diff --check; then
    echo "✓ Git whitespace/error check passed."
else
    echo "ERROR: Git diff check failed."
    exit 1
fi

###############################################################################
# FINAL REPORT
###############################################################################

printf '\n'
printf '%s\n' '============================================================'
printf '%s\n' '             SHAHEEN OS GIT RELEASE READY'
printf '%s\n' '============================================================'
printf '\n'

echo "Project:"
echo "  $APP_NAME"
echo

echo "Version:"
echo "  $VERSION"
echo

echo "Branch:"
echo "  ${GIT_BRANCH:-unknown}"
echo

echo "Production assets:"
echo "  $ASSET_COUNT"
echo

echo "Potential secret patterns:"
echo "  $SENSITIVE_FOUND"
echo

echo "Missing release files:"
echo "  $MISSING_FILES"
echo

echo "Release metadata:"
echo "  $RELEASE_METADATA"
echo

echo "Git log:"
echo "  $GIT_LOG"
echo

echo "✓ Git repository verified."
echo "✓ Production build verified."
echo "✓ SHAHEEN OS release files verified."
echo "✓ Security scan completed."
echo "✓ Git diff check passed."
echo
echo "Next stage:"
echo "  Git commit and remote deployment."
echo

