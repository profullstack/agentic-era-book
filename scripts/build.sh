#!/usr/bin/env bash
# Builds the book from Markdown with pandoc into dist/:
#   HTML (single self-contained page), EPUB, and PDF (pandoc + WeasyPrint).
# Chapters are book/chapters/*.md, assembled in filename order.
set -euo pipefail
cd "$(dirname "$0")/.."

SLUG=software-engineering-in-the-agentic-era
mkdir -p dist
cp assets/cover.jpg dist/cover.jpg

CHAPTERS=(book/chapters/*.md)
COMMON=(
  book/metadata.yaml "${CHAPTERS[@]}"
  --toc --toc-depth=1
  --resource-path=.:book:assets
  --syntax-highlighting=tango
)

echo "HTML"
pandoc "${COMMON[@]}" \
  --standalone --embed-resources \
  --template=styles/template.html \
  --css=styles/book.css \
  -o "dist/$SLUG.html"

echo "EPUB"
pandoc "${COMMON[@]}" \
  --split-level=1 \
  --css=styles/epub.css \
  --epub-cover-image=assets/cover.jpg \
  -o "dist/$SLUG.epub"

echo "PDF"
pandoc "${COMMON[@]}" \
  --template=styles/template.html \
  --css=styles/book.css \
  --css=styles/print.css \
  --variable=print \
  --pdf-engine=weasyprint \
  -o "dist/$SLUG.pdf"

# Print-on-demand (KDP) interior: same PDF without the cover page, so every page is
# exactly the 6x9 trim. The wraparound cover is a separate file (scripts/cover-print.sh).
# scripts/check-print.py fails the build if any page or box leaves KDP's margins.
echo "PDF (print interior)"
pandoc "${COMMON[@]}" \
  --standalone \
  --template=styles/template.html \
  --css=styles/book.css \
  --css=styles/print.css \
  --variable=print --variable=kdp \
  -o dist/print-interior.html
# The checker imports weasyprint, so run it on the interpreter weasyprint was installed
# into (pipx/uv venv); the shebang may carry flags such as "python -E".
read -r -a WEASYPRINT_PY <<<"$(head -1 "$(command -v weasyprint)" | sed 's/^#!//')"
[[ ${WEASYPRINT_PY[0]} == */env ]] && WEASYPRINT_PY=(python3)
"${WEASYPRINT_PY[@]}" scripts/check-print.py dist/print-interior.html
weasyprint --base-url . dist/print-interior.html "dist/$SLUG-print-interior.pdf"
rm dist/print-interior.html

ls -lh dist
