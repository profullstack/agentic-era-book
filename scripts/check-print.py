#!/usr/bin/env python3
"""Print preflight for the KDP interior: every page must be the 6x9 trim and no box
may be drawn into the outside 0.25in of the page (KDP's minimum outside margin), or
into the gutter's 0.5in. Usage: check-print.py book.html [pdf]"""
import sys
from weasyprint import HTML
from weasyprint.formatting_structure import boxes

TRIM_W, TRIM_H = 6 * 96, 9 * 96          # CSS px
OUTSIDE, GUTTER = .25 * 96, .5 * 96
SLACK = 1                                 # px of rounding

def walk(box):
    yield box
    for child in getattr(box, 'children', []) or []:
        yield from walk(child)

doc = HTML(sys.argv[1], base_url='.').render()
bad = 0
for n, page in enumerate(doc.pages, 1):
    if (round(page.width), round(page.height)) != (TRIM_W, TRIM_H):
        print(f'page {n}: size {page.width/96:.3f}x{page.height/96:.3f}in, not 6x9'); bad += 1
    right = n % 2 == 1                    # odd pages are rectos: gutter on the left
    left_min = GUTTER if right else OUTSIDE
    right_max = TRIM_W - (OUTSIDE if right else GUTTER)
    for b in walk(page._page_box):
        if isinstance(b, (boxes.PageBox, boxes.MarginBox)) or not hasattr(b, 'border_width'):
            continue
        x0, x1 = b.border_box_x(), b.border_box_x() + b.border_width()
        if x1 - x0 <= 0:
            continue
        if x0 < left_min - SLACK or x1 > right_max + SLACK:
            text = (getattr(b, 'text', '') or b.element_tag or '')[:50]
            print(f'page {n}: {type(b).__name__} <{b.element_tag}> x {x0/96:.2f}-{x1/96:.2f}in {text!r}'); bad += 1
print(f'{len(doc.pages)} pages, {bad} problem(s)')
sys.exit(1 if bad else 0)
