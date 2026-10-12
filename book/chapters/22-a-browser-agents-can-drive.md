# A Browser Agents Can Drive {#browser}

The terminal gets an agent most of the way. Then it needs to see a web page. It needs to check that the page it just deployed actually renders, that a form submits, that a login flow works, that the competitor's pricing page says what you think it says. Plain HTTP fetches miss half of the modern web, which is rendered by JavaScript, gated behind consent banners and shaped by the client.

So the agent needs a browser. Not a screenshot service, not a headless toy, but a real browser it can drive, with a profile it does not share with your personal tabs.

## The requirements

A browser for agents has an odd list of requirements:

- **Scriptable from the command line and from MCP**, so any agent can use it without custom glue.
- **Isolated**, so an agent's sessions, cookies and extensions do not mix with yours.
- **Private by default**, because agents visit a lot of pages and you do not want that trail sold.
- **Compatible with the real web**, meaning Chromium rendering and Chrome extensions.
- **Usable by a human too**, because sometimes you need to take the wheel.

## TronBrowser

We built TronBrowser to meet that list.

::: tool
**Tool: TronBrowser**

TronBrowser is a privacy-first, AI-native browser built on Ungoogled Chromium, with no telemetry and Chrome extension compatibility. The `tron` CLI is designed for agents as much as people:

- `tron mcp` and `tron automate` expose an MCP server over the Chrome DevTools Protocol, with tools like `fetch_page` and `screenshot_page`. A hosted relay is available at tronbrowser.dev for agents that cannot run a local browser.
- `tron --tor` routes through Tor for a quick privacy hop (it is not a substitute for Tor Browser's full hardening).
- It resolves Moshpit names (more on those below) with a one-click toggle, and runs its own Web Push service.

```bash
curl -fsSL https://tronbrowser.dev/install.sh | sh
tron automate
```

It is also on Homebrew, Scoop, AUR and Chocolatey.
:::

A note on honesty: the long-term plan is a fully compiled fork. Today, `tron` runs the Ungoogled Chromium engine in an isolated profile, with de-googling handled by a bundled extension. For agent work that is exactly what you want: a real engine, a clean profile and a stable automation surface.

## What agents use a browser for

In practice, our agents use a browser for five jobs.

**Verify live.** After a deploy, load the page and confirm the change is there. Not the API response, the rendered page. This catches CDN caching, client bundle errors and CSS that only breaks in production.

**Reproduce bugs.** A customer reports that a button does nothing. The agent opens the page, clicks the button, reads the console and network log, and has a reproduction before a human looks at it.

**Accessibility and SEO checks.** Load the page, run the audit, open a PR with the fixes.

**Research.** Read documentation, changelogs and issue threads, including the ones that only render with JavaScript.

**Fill the gaps in APIs.** Some services have no API for the thing you need. A browser can bridge that, carefully and politely. Throttle it, respect lockouts, keep a ledger of attempts, and never retry into a lock.

::: rule
**House rule**

Every site automation keeps an attempt ledger and respects lockouts. If a site says stop, stop.
:::

## What your site looks like to an agent

There is another side to this. Your own websites are now being read by agents, from search engines' answer bots to coding assistants checking your docs. What they see is often not what a human sees. Content rendered only on the client may be invisible. A robots policy may block the bot you wanted and admit the one you did not.

::: tool
**Tool: CrawlProof**

CrawlProof runs an answer-engine optimization (AEO) audit that shows what LLM crawlers and answer engines can see on a given URL. It also offers a tracker (`stats.js`) that separates human visitors from bots, so your analytics stop counting crawlers as customers, and a GitHub App that can open fix pull requests for what the audit finds.

```bash
npm install -g @profullstack/crawlproof
```
:::

Run an AEO audit on your most important pages, then give the findings to an agent as a frame. The acceptance check writes itself: the audit passes.

## A new namespace

One more thing lives in the browser chapter because it lives in the address bar. Moshpit is an alternative namespace for the web with endings like `.hacker` and `.eggs`, registered through pit.moshcode.sh. It is a playground for agent-run sites and internal tools that do not need a traditional domain. `moshcode dns enable` resolves Moshpit names machine-wide, and TronBrowser resolves them with a toggle.

It is a small experiment, and a useful reminder that the web's plumbing is not fixed. When agents are building and visiting sites at machine speed, naming, certificates and discovery are all up for reinvention.

## The takeaway

Give every agent fleet a real, isolated, scriptable browser. Use it to verify every deploy. And check what your own sites look like to the agents reading them, because more and more of your audience is not human.
