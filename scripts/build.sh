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

ls -lh dist
