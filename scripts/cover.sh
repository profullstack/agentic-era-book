#!/usr/bin/env bash
# Renders assets/cover.html (title type over assets/cover-art.png) to assets/cover.jpg.
# Only needed when the cover changes; the build uses the committed cover.jpg.
set -euo pipefail
cd "$(dirname "$0")/../assets"
CHROME=$(command -v google-chrome || command -v chromium || command -v chromium-browser)
"$CHROME" --headless=new --no-sandbox --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1024,1792 --virtual-time-budget=8000 \
  --screenshot="$PWD/cover.jpg" "file://$PWD/cover.html"
