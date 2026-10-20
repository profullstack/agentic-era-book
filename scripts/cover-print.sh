#!/usr/bin/env bash
# Renders the KDP paperback wraparound cover (back + spine + front, 0.125in bleed) to
# dist/<slug>-print-cover-<paper>.pdf, one per paper stock, sized from the print interior's
# page count. Run scripts/build.sh first. Fails if any type leaves the safe areas.
# Spine width per page (KDP): white 0.002252in, cream 0.0025in.
set -euo pipefail
cd "$(dirname "$0")/.."
SLUG=software-engineering-in-the-agentic-era
INTERIOR="dist/$SLUG-print-interior.pdf"
CHROME=$(command -v google-chrome || command -v chromium || command -v chromium-browser)
PAGES=$(python3 -c "import pypdf,sys; print(len(pypdf.PdfReader(sys.argv[1]).pages))" "$INTERIOR")
URL_BASE="file://$PWD/assets/cover-print.html"
CHROME_ARGS=(--headless=new --no-sandbox --hide-scrollbars --virtual-time-budget=10000)

for PAPER in white cream; do
  case $PAPER in white) PER=0.002252 ;; cream) PER=0.0025 ;; esac
  SPINE=$(python3 -c "print(round($PAGES * $PER, 4))")
  URL="$URL_BASE?spine=$SPINE"
  TITLE=$("$CHROME" "${CHROME_ARGS[@]}" --dump-dom "$URL" 2>/dev/null | grep -o '<title>[^<]*' | sed 's/<title>//')
  echo "$PAPER: $PAGES pages, spine ${SPINE}in, $TITLE"
  [[ $TITLE == "PREFLIGHT OK" ]] || { echo "cover preflight failed" >&2; exit 1; }
  "$CHROME" "${CHROME_ARGS[@]}" --no-pdf-header-footer \
    --print-to-pdf="$PWD/dist/$SLUG-print-cover-$PAPER.pdf" "$URL" 2>/dev/null
  python3 - "dist/$SLUG-print-cover-$PAPER.pdf" "$SPINE" <<'PY'
import pypdf, sys
r = pypdf.PdfReader(sys.argv[1]); spine = float(sys.argv[2])
w, h = (float(x) / 72 for x in r.pages[0].mediabox[2:])
want = 2 * .125 + 2 * 6 + spine
print(f'  {len(r.pages)} page, {w:.4f} x {h:.4f}in (want {want:.4f} x 9.25)')
assert len(r.pages) == 1 and abs(w - want) < .01 and abs(h - 9.25) < .01, 'wrong cover size'
PY
done
