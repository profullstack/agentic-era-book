#!/usr/bin/env bash
# Renders the KDP wraparound covers (back + spine + front) from assets/cover-print.html,
# sized from the print interior's page count. Run scripts/build.sh first.
#   dist/<slug>-print-cover-{white,cream}.pdf      paperback, 0.125in bleed
#   dist/<slug>-hardcover-cover-{white,cream}.pdf  hardcover (case laminate), 0.591in wrap
# Upload the one matching the paper chosen in KDP. Fails if any type leaves a safe area.
# Dimensions match KDP's cover calculator (kdp.amazon.com/cover-calculator, 6x9):
#   paperback spine = pages x 0.002252in (white) / 0.0025in (cream)
#   hardcover spine = the same + 0.189in; boards 6.197 x 9.236in
set -euo pipefail
cd "$(dirname "$0")/.."
SLUG=software-engineering-in-the-agentic-era
INTERIOR="dist/$SLUG-print-interior.pdf"
CHROME=$(command -v google-chrome || command -v chromium || command -v chromium-browser)
PAGES=$(python3 -c "import pypdf,sys; print(len(pypdf.PdfReader(sys.argv[1]).pages))" "$INTERIOR")
CHROME_ARGS=(--headless=new --no-sandbox --hide-scrollbars --virtual-time-budget=10000)

for BINDING in paperback hardcover; do
  for PAPER in white cream; do
    case $PAPER in white) PER=0.002252 ;; cream) PER=0.0025 ;; esac
    case $BINDING in
      paperback) EXTRA=0;     EDGE=0.125; TW=6;     TH=9;     OUT=print-cover ;;
      hardcover) EXTRA=0.189; EDGE=0.591; TW=6.197; TH=9.236; OUT=hardcover-cover ;;
    esac
    SPINE=$(python3 -c "print(round($PAGES * $PER + $EXTRA, 4))")
    URL="file://$PWD/assets/cover-print.html?binding=$BINDING&spine=$SPINE"
    FILE="dist/$SLUG-$OUT-$PAPER.pdf"
    TITLE=$("$CHROME" "${CHROME_ARGS[@]}" --dump-dom "$URL" 2>/dev/null | grep -o '<title>[^<]*' | sed 's/<title>//')
    echo "$BINDING $PAPER: $PAGES pages, spine ${SPINE}in, $TITLE"
    [[ $TITLE == "PREFLIGHT OK" ]] || { echo "cover preflight failed" >&2; exit 1; }
    "$CHROME" "${CHROME_ARGS[@]}" --no-pdf-header-footer --print-to-pdf="$PWD/$FILE" "$URL" 2>/dev/null
    python3 - "$FILE" "$SPINE" "$EDGE" "$TW" "$TH" <<'PY'
import pypdf, sys
f, spine, edge, tw, th = sys.argv[1], *map(float, sys.argv[2:])
r = pypdf.PdfReader(f)
w, h = (float(x) / 72 for x in r.pages[0].mediabox[2:])
want_w, want_h = 2 * edge + 2 * tw + spine, 2 * edge + th
print(f'  {len(r.pages)} page, {w:.4f} x {h:.4f}in (want {want_w:.4f} x {want_h:.4f})')
assert len(r.pages) == 1 and abs(w - want_w) < .01 and abs(h - want_h) < .01, 'wrong cover size'
PY
  done
done
