# A Stack Agents Can Read {#stack}

Ask ten agents to build the same feature in an empty directory and you will get ten different stacks. One reaches for Express, one for Fastify, one for a framework that peaked in 2019. One uses npm, one pnpm, one Bun. One stores secrets in a `.env` file it then commits. Every one of those choices is defensible, and the combination across a fleet is chaos.

Agents do not have taste. They have defaults, and their defaults come from whatever was most common in their training data. If you want consistency you have to write your taste down, in a place agents read, in a format they can follow.

## Write the stack down, once

We keep exactly one source of truth for our house stack. It renders as a web page for humans, as Markdown for agents and as JSON for tools:

```bash
curl https://profullstack.com/stack.md
curl https://profullstack.com/stack.json
```

It is organized by use case, because "the stack" is really a handful of stacks. A web app gets Next.js and React, with Hono under `/api` and Turso (libSQL) for data, styled with Tailwind and shadcn. An API service gets Hono on Bun or Node. A CLI or TUI gets commander, hqtui and an MCP bridge, installed with `npm i -g` or a `curl | sh` installer. A desktop app gets Electron with the CLI bundled inside. Mobile gets Expo inside the product monorepo. Systems work gets Rust or Go.

Around those combinations sit the shared defaults every repo inherits:

- TypeScript ESM, with runtimes pinned by mise.
- pnpm, and never two lockfiles in one repo.
- Auth by magic link and passkeys.
- Email through Resend, DNS at Porkbun.
- Secrets in the team vault, never in `.env`.
- Payments through CoinPay and x402 only.
- Tests in vitest, and every repo carries `ci.yml`, `codeql.yml` and `threatcrush-scan.yml`.
- Promotion through myna.

None of these choices is the point. The point is that the answer exists, an agent can fetch it in one request, and when we change our minds we change one file.

::: rule
**House rule**

One file owns the stack. Every other doc points at it. When a default changes, edit the source and bump its date; do not patch the copies.
:::

## Say what is not in the stack

The most useful section of our stack file is the list of things we do not use. Agents love to add dependencies. A short, explicit "not in the stack" list saves more review time than any amount of positive guidance, because the agent stops before it adds the thing instead of after.

The same goes for retired choices. If you used to deploy to a platform and moved to bare metal, say so in the stack file, or agents reading old READMEs will cheerfully write configuration for a platform you no longer pay for.

## Skills: telling agents how, not just what

A stack file says what to use. A skill says how to do a specific job: how to cut a release in this repo, how to add a migration, how to write a blog post in the house voice. Skills are plain Markdown with a short description up top so an agent can decide whether it applies.

We publish a `skill.md` at the root of profullstack.com that any agent can read, and the cli-tools installer drops the Profullstack skill into every coding agent on a machine. The OpenSkill draft at LogicSRC describes the format, so skills can move between agents and organizations.

Good skills share some traits:

- **They are short.** One job, one page.
- **They name the trap.** "BullMQ rejects a job ID with a colon" is worth more than three paragraphs of general advice.
- **They say when to use them**, in one line at the top.
- **They point at the source of truth** instead of copying it.

## Packages agents should reach for first

Agents will write a new email sender, a new referral system or a new payment client every single time unless you give them a better option. So we keep the common pieces in shared packages and tell agents to check there first.

::: tool
**Tool: @profullstack/stack**

`@profullstack/stack` is a set of shared Next.js modules exposed as subpaths: `/email` (Resend sending plus a contact form guard that blocks bots without a CAPTCHA), `/referrals`, `/coinpay`, `/crawlproof` and `/supabase`. One install, one import per feature, and the same behavior across every site in the fleet.

```bash
npm install @profullstack/stack
```
:::

The rule is simple: before adding a dependency or writing a utility, check the house packages. Reuse is not just about saving effort. Every shared module is one more place where a bug fix lands everywhere at once.

## MCP: tools agents can discover

The Model Context Protocol has become the standard way to hand an agent a tool. An MCP server describes what it can do, and any compatible agent can call it. For a fleet this means you write an integration once and every agent can use it.

::: tool
**Tool: mcp-server**

`@profullstack/mcp-server` is a generic, modular MCP server. Capabilities live in `mcp_modules` that load dynamically, so adding a new integration is a folder, not a fork. We run a hosted instance at mcp.profullstack.com.

```bash
npm install -g @profullstack/mcp-server
```
:::

Many of our products also expose their own MCP servers: TronBrowser for browsing, myna for social posting, RSS Amplifier for finding independent blogs, nichedb for public datasets. The LogicSRC OpenMCP catalog lists what is available so agents can find it.

## Make the repo explain itself

The last piece of a readable stack is the repository itself. An agent landing in a repo for the first time should find:

- A README that says what this is, how to run it and how to test it, in that order.
- An agent instructions file (such as `CLAUDE.md` or `AGENTS.md`) with the repo-specific rules: where secrets come from, how to release, what not to touch.
- A single command for the local gate: tests, types and lint in one go.
- An installer that does the whole job, with no manual steps.

If a new human could not get from clone to green tests in ten minutes, neither can an agent, and the agent will improvise. Improvisation is where stacks drift.

## The takeaway

Agents follow instructions literally and fill gaps with averages. Write down your stack, your exclusions and your skills in machine-readable form, keep one source of truth, and give agents shared packages and MCP tools so the easy path is also the right one.
