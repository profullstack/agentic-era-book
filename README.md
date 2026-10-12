# Software Engineering in the Agentic Era

<img src="assets/cover.jpg" alt="Book cover" width="260" align="right">

**How one engineer and a fleet of AI agents ship real software.**

A free, open-source field guide from [Profullstack](https://profullstack.com): what changed when code got cheap, the workbench (terminal, browser, pairing, stack), the loop that turns a request into a release, running a fleet for real (keys, money, identity, compute), and what it all means for engineers.

## Read it

- **Online:** [profullstack.com/book](https://profullstack.com/book)
- **Download:** HTML, PDF and EPUB from the [latest release](https://github.com/profullstack/agentic-era-book/releases/latest)

## Build it

The source is Markdown in [`book/chapters/`](book/chapters), assembled in filename order. [pandoc](https://pandoc.org) builds every format:

```bash
# needs pandoc 3.x and WeasyPrint (for the PDF)
bash scripts/build.sh
ls dist/
# software-engineering-in-the-agentic-era.{html,pdf,epub}
```

| Output | How |
|---|---|
| HTML | `pandoc --standalone --embed-resources` with `styles/template.html` + `styles/book.css` |
| EPUB | `pandoc` with `styles/epub.css` and the cover image |
| PDF  | `pandoc --pdf-engine=weasyprint` with `styles/print.css` (6×9 in pages) |

CI builds all three on every push, and tagging `v*` publishes them to a GitHub release.

The cover is `assets/cover.html` (type) over `assets/cover-art.png` (art), rendered to `assets/cover.jpg` by `scripts/cover.sh`.

## Contribute

Found a mistake, a stale command or a better way? Open a pull request. Callout boxes in the Markdown use pandoc fenced divs:

```markdown
::: tool
**Tool: name**

What it does and how to install it.
:::
```

`::: rule` is a house rule and `::: tip` is a tip. Please keep prose free of em dashes.

## License

Text and cover © 2026 Profullstack, Inc., licensed [CC BY-SA 4.0](LICENSE). Share it, translate it, remix it. Keep the attribution and the license.
