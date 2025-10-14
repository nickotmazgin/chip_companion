#!/usr/bin/env bash
# Open Chip Companion in Chrome/Chromium at an exact size for manual screenshots.
# Usage:
#   tools/open_preset.sh <width> <height> [route] [dpr]
# Example:
#   tools/open_preset.sh 1080 1920 /
#   tools/open_preset.sh 1920 1080 /glossary

set -euo pipefail

WIDTH=${1:-}
HEIGHT=${2:-}
ROUTE=${3:-/}
DPR=${4:-1}

if [[ -z "$WIDTH" || -z "$HEIGHT" ]]; then
  echo "Usage: $0 <width> <height> [route]" >&2
  exit 2
fi

URL="http://localhost:8080${ROUTE}"

# Find a Chrome-like browser
CHROME_BIN=${CHROME_BIN:-}
if [[ -z "${CHROME_BIN}" ]]; then
  for c in google-chrome-stable google-chrome chromium chromium-browser brave-browser; do
    if command -v "$c" >/dev/null 2>&1; then
      CHROME_BIN=$(command -v "$c")
      break
    fi
  done
fi

if [[ -z "${CHROME_BIN}" ]]; then
  echo "Could not find Chrome/Chromium (set CHROME_BIN or install chrome/chromium)." >&2
  exit 1
fi

# Isolated user-data-dir so each window is clean and sized correctly
PROFILE_DIR=$(mktemp -d -t chipcompanion_chrome_XXXXXX)

# Compute CSS viewport size from target pixels and DPR
CSS_W=$WIDTH
CSS_H=$HEIGHT
if [[ "$DPR" != "1" ]]; then
  CSS_W=$(( WIDTH / DPR ))
  CSS_H=$(( HEIGHT / DPR ))
fi

echo "Launching: $CHROME_BIN $URL (${WIDTH}x${HEIGHT} @ DPR ${DPR} -> CSS ${CSS_W}x${CSS_H})"
"$CHROME_BIN" \
  --new-window \
  --disable-session-crashed-bubble \
  --disable-restore-session-state \
  --force-device-scale-factor="${DPR}" \
  --window-size="${CSS_W},${CSS_H}" \
  --user-data-dir="$PROFILE_DIR" \
  --app="$URL" >/dev/null 2>&1 &

disown || true
echo "Hint: Take the screenshot with your OS tool; keep zoom at 100%."
