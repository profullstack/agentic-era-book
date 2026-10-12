# Compute on Tap {#compute}

Every agent runs on somebody's GPU. Usually that somebody is a model provider, the bill arrives monthly, and nobody on the team could tell you which task burned which dollar.

That works for a while. Then you have a fleet, and inference stops being a rounding error. It becomes the biggest variable cost in engineering, bigger than hosting, and it moves every time someone adds an agent or changes a model.

This chapter is about treating compute like any other resource: see it, choose it, and route it.

## See the spend first

You cannot manage a cost you do not measure, and agent spend hides well. It is spread across sessions, engines, retries and sub-agents, and the provider's dashboard shows a daily total with no idea which task caused it.

::: tool
**Tool: moshcode**

moshcode is a metal wrapper CLI for agentic coding. It installs and drives the agents you already use (Claude Code, Codex, opencode, Gemini, Kimi, aider and more) instead of replacing them. `moshcode cost` shows spend per session, so a runaway task is visible while it is running, not at the end of the month.

```bash
curl -fsSL https://moshcoding.com/install.sh | sh
moshcode cost
```
:::

Look at it daily for a week. You will find at least one task that loops, one agent using a frontier model to rename variables, and one sub-agent nobody remembers starting.

## Pick the model per task, not per company

The worst compute decision is choosing one model for everything. Tasks are not equal:

| Task | What it needs | What to use |
|---|---|---|
| Architecture, tricky debugging, security review | Deep reasoning, long context | Your strongest model |
| Feature work on a known codebase | Solid coding, good tool use | A strong mid-tier model |
| Renames, formatting, boilerplate, test scaffolds | Speed, low cost | Small, fast model |
| Summaries, classification, triage | Cheap and many | Small model or open weights |
| Bulk batch jobs that can wait | Lowest cost per token | Open models on spare GPUs |

The engineer's job is to route, the same way you would not put a principal engineer on data entry. Because moshcode drives several engines, switching is a flag, not a migration, and `moshcode handoff` moves a conversation from one engine to another when a task changes shape mid-flight.

::: tip
**Tip**

Start every new kind of task on a small model. Move up only when it fails. You will be surprised how much of the work never needs the big one.
:::

## Idle GPUs are everywhere

Meanwhile, the world is full of GPUs doing nothing: gaming rigs overnight, workstations on weekends, a lab cluster between jobs, a Mac Studio idling under a desk. That is the opportunity Infernet exists for.

::: tool
**Tool: Infernet Protocol**

Infernet is a peer-to-peer GPU marketplace for inference and training. Operators put hardware on the network and earn. Developers send jobs and pay for what they use. It runs as a plugin on c0mpute, and it offers managed endpoints for teams that want a stable target instead of picking nodes.

```bash
curl -fsSL https://c0mpute.com/install.sh | sh
```

Site: [infernetprotocol.com](https://infernetprotocol.com). The free Infernet book covers running a node and building on it: [infernetprotocol.com/book](https://infernetprotocol.com/book).
:::

We use Infernet ourselves as a fallback inference provider for the fleet, and we run CPU nodes on our own boxes. That fallback matters more than it sounds. When a primary provider rate-limits you, has an outage, or changes its pricing, a fleet with one provider stops. A fleet with a fallback slows down and keeps shipping.

### What belongs on open GPUs

Not every job should leave your primary provider. A good rule of thumb:

- **Good fits:** batch summarization, embeddings, classification, transcription, image generation, anything that can retry and does not hold secrets.
- **Think twice:** anything carrying customer data or credentials. A peer network is someone else's machine. Send it work you would be fine seeing in a log.
- **Keep on primary:** the reasoning-heavy loop where your senior engineer is steering in real time and latency is felt.

## c0mpute: the layer underneath

::: tool
**Tool: c0mpute**

c0mpute is a decentralized, CLI-first compute network written in Rust. It ships three modules: **transcode** (FFmpeg jobs), **coinpay** (DID identity and escrow, so work and payment are tied together), and **infernet** (AI inference). It keeps itself current from GitHub releases.

```bash
curl -fsSL https://c0mpute.com/install.sh | sh
```

Site: [c0mpute.com](https://c0mpute.com)
:::

The design point is that compute, identity and payment travel together. A job has a requester with an identity, an operator with an identity, and an escrow that pays when the work comes back. That is the same pattern from the money and identity chapters, applied to GPU time, and it is what makes a market between strangers workable.

## Finding boxes and moving data

Sometimes the answer is not a marketplace but a plain server: a VPS for an agent's sandbox, a GPU box for a week of batch work, bare metal for the fleet. Shopping for one is tedious, and agents are good at tedious if the data is structured.

::: tool
**Tool: r4ck.dev**

r4ck.dev is the server search engine built for agents. Search VPS, GPU and bare-metal offers with the same parameters on the web, an API, a CLI and an MCP server, so an agent can compare offers the same way you would. Note that results carry affiliate links.

```bash
npm i -g @profullstack/r4ck
```

Site: [r4ck.dev](https://r4ck.dev)
:::

Once you have the box, the data has to get there: models, datasets, media, backups.

::: tool
**Tool: diskpush**

diskpush wraps rsync in a desktop app, a CLI and a TUI, for moving data between machines without memorizing flags.

```bash
curl -fsSL https://diskpush.com/install.sh | sh
```

Site: [diskpush.com](https://diskpush.com)
:::

## A compute policy you can write on a card

1. Measure spend per session, every day (`moshcode cost`).
2. Default to the smallest model that passes the task.
3. Reserve the strongest model for reasoning and review.
4. Keep a fallback provider configured and tested, not just planned.
5. Send batch and non-sensitive work to cheaper GPUs.
6. Never send secrets to a machine you do not control.

::: rule
**House rule**

Every agent task has a model choice someone made on purpose. "Whatever the default is" is not a choice, it is a bill.
:::

Compute is now a line item that engineering owns. The teams that treat it like hosting (measured, routed, with failover) will ship more for less. The teams that treat it like weather will keep being surprised by the invoice.
