# The Terminal Is Back {#terminal}

For two decades the trend in developer tools ran toward heavier graphical environments. Then agents arrived, and agents live in the terminal. They read text, they write text, they run commands and parse output. The shell is their native habitat, and if you want to direct them well, it needs to become yours again.

This is not nostalgia. A terminal session is scriptable, inspectable, loggable and reachable over SSH from anywhere. Everything an agent does in a terminal can be replayed, diffed and audited. That is exactly what you want from a fleet.

## Your agents, under one roof

Most engineers end up using more than one coding agent. One is better at large refactors, another is cheaper for routine fixes, a third has a longer context window or a tool you need. Juggling separate installs, configs, sessions and bills gets old quickly.

::: tool
**Tool: moshcode**

moshcode wraps the agents you already use and gives them a common set of verbs:

- `herd` keeps persistent sessions you can return to.
- `swarm` plans a task, fans it out across engines, verifies the results and synthesizes one answer.
- `handoff` moves a conversation from one engine to another without losing context.
- `cost` shows spend per session, so the expensive habits are visible.
- `oneshot` runs a single non-interactive task, ideal for scripts and cron.

It also installs MCP servers and skills across every agent on the box, so one `moshcode` command configures all of them.

```bash
curl -fsSL https://moshcoding.com/install.sh | sh
moshcode swarm "add a /health endpoint with a test"
moshcode cost
```
:::

`swarm` deserves a closer look. Fanning the same frame out to several models and comparing the results is one of the cheapest ways to catch a confident wrong answer. If three engines agree and the tests pass, you can merge with more confidence. If they disagree, the disagreement itself tells you where to look.

## Sessions that survive

Agents run for a long time. A real task can take an hour of work, tool calls and test runs. If that session lives on your laptop, it dies when the lid closes or the coffee shop Wi-Fi drops. So the serious work moves to a remote box, and the question becomes how to keep a session to that box alive.

::: tool
**Tool: hqsh and hqterm**

hqsh is a terminal session that survives disconnects, in the spirit of mosh, but it carries the raw byte stream so inline images (Kitty graphics, iTerm2, sixel) survive too. It runs over plain SSH, is written in Go, and keeps a numbered resume buffer so you can scroll back through what happened while you were gone.

hqterm is a session manager TUI built on top of it: a list of your remote agent sessions, one keypress to attach. It is early software, and we use it daily.

```bash
curl -fsSL https://hqterm.sh/install | sh
```
:::

The pattern we recommend: one long-lived remote machine for agent work, each agent session in its own worktree on that machine, and a resilient terminal to reach them. Your laptop becomes a window, not a server.

## Interfaces worth looking at

Agents are better with good tools, and so are you. A lot of operational work is watching things: CI runs, queue depths, error rates, spend. The terminal used to be a bad place for dashboards. It is not anymore.

::: tool
**Tool: hqtui**

hqtui is a "High Quality Terminal UI" library for building btop-grade dashboards: one import, zero runtime dependencies, mouse support, Kitty HD images, and icon and emoji packs. It has ports in Rust, Go, Python, Zig, C++, Ruby, PHP and Perl, so the same look works across your fleet regardless of language.

```bash
npx @profullstack/hqtui-demo
```
:::

Our house rule is that every product ships a TUI, a CLI, an MCP server and an API. That sounds like a lot until you notice they share one core. The CLI is what agents call. The MCP server is how agents discover it. The API is what everything else integrates with. The TUI is what the human watches. Build the core once and the four surfaces are thin.

## Reading what agents write

Agents produce a lot of Markdown: plans, specs, summaries, changelogs, reports. Reading those in a raw editor is tolerable. Reading them rendered, with code highlighted and tables aligned, is better.

::: tool
**Tool: readm3**

readm3 is a terminal Markdown reader and editor built on hqtui. Point it at a file and it renders. It also handles pastes with language detection and has a web viewer (`readm3.com/viewer?url=...`) for sharing a rendered document by link.

```bash
npx @profullstack/readm3 PLAN.md
```
:::

## The fleet toolbelt

Finally, every fleet accumulates small commands that do one job well. Ours live in one repository and install in one line.

::: tool
**Tool: cli-tools**

cli-tools is about fifty commands we use across the fleet, including:

- `websearch`, which fuses five search engines, and `ask-web`.
- `gh-prs` and `gh-prs-merge`, which list and squash-merge every green PR across your orgs.
- `wcag` for accessibility checks and `keywords` for SEO.
- `domainfree` for domain availability.
- `mail` and `cal`.

The installer also drops the Profullstack skill into every coding agent on the box, so your agents know the house stack from their first session.

```bash
curl -fsSL https://raw.githubusercontent.com/profullstack/cli-tools/master/install.sh | sh
```
:::

`gh-prs-merge` is a good example of the kind of tool that matters in the agentic era. Agents produce many pull requests. The one-by-one merge button is a bottleneck. A command that merges everything that is green, across every repository, turns an hour of clicking into one line.

## A minimal terminal setup

If you take nothing else from this chapter, set up the following:

1. A remote Linux box with enough RAM for several agent sessions and their builds.
2. A resilient terminal to reach it (hqsh or similar).
3. A wrapper that standardizes how you start, resume and pay for agent sessions (moshcode).
4. A scratch directory per job that is deleted when the job ends. Never let agents clone into a shared `/tmp`.
5. A small, versioned toolbelt of commands your agents are allowed to call.

The terminal is where agents work. Make it a place you enjoy working too.
