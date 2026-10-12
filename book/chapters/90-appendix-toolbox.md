# Appendix A: The Toolbox {#toolbox}

Every tool mentioned in this book, with what it does and how to get it. Versions move fast; each tool's site has the current install instructions.

## Workbench

Where you and your agents sit all day.

| Tool | What it does | Install / URL |
|---|---|---|
| moshcode | Wrapper CLI that installs and drives Claude Code, Codex, opencode, Gemini, Kimi, aider and more. Persistent sessions (herd), fan out and verify (swarm), engine handoff, per-session cost. | `curl -fsSL https://moshcoding.com/install.sh \| sh` · [moshcoding.com](https://moshcoding.com) |
| hqtui | High Quality Terminal UI library for btop-grade dashboards. One import, zero runtime dependencies, ports in many languages. | `npx @profullstack/hqtui-demo` · [hqtui.com](https://hqtui.com) |
| hqsh | Sessions that survive disconnects, like mosh, but carrying the raw stream so terminal images survive. Go, over plain ssh. | [github.com/profullstack/hqsh](https://github.com/profullstack/hqsh) |
| hqterm | Session-manager TUI on top of hqsh. Early. | `curl -fsSL https://hqterm.sh/install \| sh` · [hqterm.sh](https://hqterm.sh) |
| readm3 | Terminal Markdown reader and editor built on hqtui, plus a web viewer. | `npx @profullstack/readm3` · [readm3.com](https://readm3.com) |
| cli-tools | About fifty fleet commands: web search, PR merging, mail, accessibility and keyword audits, and more. Also installs the Profullstack skill into your coding agents. | `curl -fsSL https://raw.githubusercontent.com/profullstack/cli-tools/master/install.sh \| sh` |
| TronBrowser | Privacy-first, AI-native browser on Ungoogled Chromium with an agent-friendly CLI and an MCP server (`tron automate`). | `curl -fsSL https://tronbrowser.dev/install.sh \| sh` · [tronbrowser.dev](https://tronbrowser.dev) |
| PairUX | Open-source screen sharing with simultaneous remote control, two cursors, E2E encryption, and agent participants. | `brew tap profullstack/homebrew-pairux && brew install --cask pairux` · `winget install PairUX.PairUX` · [pairux.com](https://pairux.com) |

## Loop

Frame, build, gate, ship, tell people.

| Tool | What it does | Install / URL |
|---|---|---|
| @profullstack/stack | Shared Next.js modules by subpath: referrals, email, supabase, coinpay, crawlproof. | `npm install @profullstack/stack` |
| mcp-server | Modular MCP server that loads `mcp_modules` dynamically. | `@profullstack/mcp-server` · [mcp.profullstack.com](https://mcp.profullstack.com) |
| sh1pt | One codebase to every store, registry, CDN and channel. Deploy over SSH to bare metal, plus an OpenAPI breaking-change check. | `curl -fsSL https://sh1pt.com/install.sh \| sh` · `npm i -g @profullstack/sh1pt` |
| myna | Terminal social media manager: post everywhere with per-network tailoring, schedule, read engagement, send newsletters. MCP server included. | `curl -fsSL https://mynaposter.com/install.sh \| sh` · `npm i -g @profullstack/myna` |
| qaaas.dev | Browser QA agent driven by plain-English instructions. Files issues and opens small fix PRs. | [qaaas.dev](https://qaaas.dev) |
| demo.movie | Turns a URL into a narrated demo video. Includes an MCP server. | `npm install -g @profullstack/demomovie` · [demo.movie](https://demo.movie) |
| bl0ggers | AI publishing with a per-publication API, MCP server and CLI. | [bl0ggers.com](https://bl0ggers.com) |
| RSS Amplifier | Open, agent-first directory of independent blogs with JSON, OPML, plain text and an MCP server. | `npm i -g @profullstack/rssamplifier` · [rssamplifier.com](https://rssamplifier.com) |
| CrawlProof | AEO audit of what LLM crawlers see, a tracker that splits humans from bots, and declared actor tokens. | `npm install -g @profullstack/crawlproof` · [crawlproof.com](https://crawlproof.com) |

## Fleet

Keeping many agents and many servers safe.

| Tool | What it does | Install / URL |
|---|---|---|
| ThreatCrush | Server security daemon: OWASP CRS rules, SSH guard, connection monitor, auto-ban, fleet dashboard, agent keys, AI red-team scanner, CI scan. | `curl -fsSL https://threatcrush.com/install.sh \| sh` · `npm i -g @profullstack/threatcrush` |
| vu1nz | Security scanner for CI/CD workflows and AI-generated code, as a GitHub Action. | `uses: profullstack/vu1nz-gh-actions/.github/actions/vu1nz-actions-scan@v1` · [vu1nz.com](https://vu1nz.com) |
| AgentBBS | BBS over SSH where humans and agents both hold accounts, with personal pods and homepages. | `ssh join@bbs.profullstack.com` |
| BufferOverride | Where humans and agents debug together: a public knowledge network that tracks the versions and provenance of answers. | [bufferoverride.com](https://bufferoverride.com) |

## Data and directories

| Tool | What it does | Install / URL |
|---|---|---|
| nichedb | Public datasets with a feed API, CLI and MCP server. | `npm i -g @profullstack/nichedb` · [nichedb.dev](https://nichedb.dev) |
| pwamart | PWA app store with an MCP server. | [pwamart.com](https://pwamart.com) |
| saasrow | SaaS directory with an API and MCP server. | [saasrow.com](https://saasrow.com) |

## Money

Paying and getting paid, by machines.

| Tool | What it does | Install / URL |
|---|---|---|
| CoinPay | Multi-chain crypto payments (BTC, BCH, ETH, POL, SOL, USDC), 0.5% fee, Lightning BOLT12, escrow, non-custodial web wallet, x402 settlement, Sign in with CoinPay. | `npm install @profullstack/coinpay` · [coinpayportal.com](https://coinpayportal.com) |
| x402-gateway | One middleware, no database: people and search bots read free, training crawlers get a 402 with a daily pass. Companions: x402-client, throttle. | `npm install @profullstack/x402-gateway` |
| Power Key | One Ed25519-signed key, verified offline, that opens every Profullstack property. | [profullstack.com/shop](https://profullstack.com/shop) |

## Identity

Names, owners, skills and lineage.

| Tool | What it does | Install / URL |
|---|---|---|
| LogicSRC | Open standards for humans and agents (OpenAgent, OpenSkill, OpenFleet, OpenMCP and more), plus the team secret vault (`logicsrc teams pull`). | [logicsrc.com](https://logicsrc.com) |
| phonenumbers.bot | Rents physical SIM numbers to AI agents for 2FA where VOIP numbers are blocked. Early, waitlist. | [phonenumbers.bot](https://phonenumbers.bot) |
| wx93.me | Short links for people and agents. In progress. | [wx93.me](https://wx93.me) |

## Compute

GPUs, routing and spend.

| Tool | What it does | Install / URL |
|---|---|---|
| Infernet Protocol | Peer-to-peer GPU marketplace for inference and training, with managed endpoints. Runs as a c0mpute plugin. | `curl -fsSL https://c0mpute.com/install.sh \| sh` · [infernetprotocol.com](https://infernetprotocol.com) |
| c0mpute | Decentralized, CLI-first compute network in Rust with transcode, coinpay and infernet modules. | `curl -fsSL https://c0mpute.com/install.sh \| sh` · [c0mpute.com](https://c0mpute.com) |
| r4ck.dev | Server search engine built for agents: VPS, GPU and bare-metal offers on web, API, CLI and MCP. Results carry affiliate links. | `npm i -g @profullstack/r4ck` · [r4ck.dev](https://r4ck.dev) |
| diskpush | rsync as a desktop app, CLI and TUI for moving data between boxes. | `curl -fsSL https://diskpush.com/install.sh \| sh` · [diskpush.com](https://diskpush.com) |

## People

| Tool | What it does | Install / URL |
|---|---|---|
| ugig.net | Marketplace for AI-assisted engineers and agents: gigs, bounties, crypto pay, agent API keys, `openapi.json` and `skill.md`. | [ugig.net](https://ugig.net) |
| agenticjobs.work | Self-hosted, federated job board where agents on both sides act for real people. | `curl -fsSL https://agenticjobs.work/install.sh \| sh` |
| chovy.com | Agent-built apps service. Behind sign-in, still taking shape. | [chovy.com](https://chovy.com) |
