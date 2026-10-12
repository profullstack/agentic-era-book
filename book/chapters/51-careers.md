# Careers in the Agentic Era {#careers}

Every engineer we talk to asks some version of the same question: is this job going away?

The typing part is. The judgment part is getting more valuable every month. The work moved, and careers move with it. If your value was "I can produce a lot of correct code quickly", an agent now does that for a few dollars an hour. If your value is "I know what should be built, I can tell when it is wrong, and I can get it to production safely", you just got a team of tireless juniors for free.

## The engineer as director

At Profullstack one senior engineer directs a fleet of AI coding agents across roughly 170 active repositories. That number is only possible because the engineer does not write most of the code. The job looks like this instead:

- **Framing.** Turning a fuzzy request into a task an agent can finish: a clear goal, constraints, the files that matter, what done looks like.
- **Fanning out.** Splitting work so several agents run in parallel without stepping on each other.
- **Reviewing.** Reading what came back, fast and skeptically, and deciding what merges.
- **Operating.** Releasing, verifying in production, reading the logs, catching what tests missed.
- **Ratcheting.** Turning every escaped bug into a permanent check so it never escapes twice.

That is closer to a film director or an editor than a typist. You are responsible for the whole result, and you touch every part of it, but your hands are mostly on the steering, not the keyboard.

## What to learn if you are early

Juniors have it hardest and easiest at once. The entry-level tasks that used to train you (small bugs, boilerplate, CRUD screens) are exactly what agents do best. But you also have something no previous generation had: an infinitely patient pair who will explain any line of any codebase, any time.

Spend your learning here:

### Read more code than you write

Reviewing is the job now. Read open source. Read your agents' diffs line by line until you can predict what they will get wrong. A junior who can read a 400-line PR and find the one broken assumption is worth more than one who can write the PR.

### Learn to write specs

An agent does what you said, not what you meant. The skill of saying exactly what you mean (inputs, outputs, edge cases, non-goals) used to belong to senior engineers and product managers. Now it is the core of the job at every level.

### Learn the machine underneath

Operating systems, networking, processes, file permissions, DNS, TLS. Agents are confidently wrong about infrastructure in ways that take down production. The engineer who knows why a service cannot bind a port, or why a file is unreadable after a deploy, fixes in minutes what an agent loops on for an hour.

### Learn security as a default

Agents hold keys and run commands. You need to look at a change and ask: what can this leak, what can this delete, who can call this? Read the OWASP Top 10, and the OWASP LLM Top 10 too.

### Develop taste

Taste is knowing which of three working solutions is the right one: the one that is simpler, that the next person can read, that does not add a dependency for a ten-line function. Agents produce working solutions in volume. Taste picks.

::: tip
**Tip**

Keep a log of every mistake your agents make that you caught in review. After a month, you will have a personal checklist, and the beginning of a set of automated checks.
:::

## What changes if you are senior

Seniors tend to underrate how much leverage they just got and overrate how much their old workflow still matters.

- **Stop doing the typing.** If you still write most of your code by hand, you are spending your most expensive hours on the cheapest work.
- **Get good at parallelism.** One agent at a time is a faster keyboard. Five agents in five worktrees is a team. Learn to run the team.
- **Own the gates.** Tests, CI, security scans, release automation. These are now the main way your judgment scales. Every rule you encode is a review you never have to repeat.
- **Teach in files.** Write down your conventions where agents read them. Your taste becomes infrastructure.

## Getting work: ugig.net

The market is moving too. Clients increasingly do not care whether a human or an agent wrote the code. They care whether it works, whether it shipped, and whether someone answers for it.

::: tool
**Tool: ugig.net**

ugig.net is a marketplace for AI-assisted engineers and for agents. It lists gigs and bounties, pays in crypto, and gives agents their own API keys. It publishes an `openapi.json` and a `skill.md`, so an agent can read the rules, sign up and bid on work without a human clicking through forms.

Site: [ugig.net](https://ugig.net)
:::

That last part is the point. On ugig the worker can be you, you plus your agents, or an agent with an owner. A bounty gets funded, someone delivers, the escrow pays. Your portfolio is what you shipped, and your speed is a function of how well you direct your fleet.

Job hunting is getting the same treatment. Both sides already use agents to screen and apply, so the board might as well be built for them.

::: tool
**Tool: agenticjobs.work**

agenticjobs.work is a self-hosted, federated job board where agents on both sides act for real people: one represents the candidate, one represents the employer, and humans make the calls that matter.

```bash
curl -fsSL https://agenticjobs.work/install.sh | sh
```
:::

And if you would rather have an app built than build one yourself, chovy.com is our agent-built apps service. It sits behind a sign-in and is still taking shape, so look at it as a preview of where this is going.

## Hiring for judgment

If you are hiring, the old filters are broken. A take-home exercise measures whether the candidate has an agent. Leetcode measures something agents now do in seconds.

What still separates people:

- **Give them a broken PR and ask them to review it.** Plant a real bug, a security hole, and a needless dependency. See what they catch.
- **Give them a vague request and ask for a spec.** Watch whether they ask the right questions before writing anything.
- **Pair on a live system.** Something in production is slow. Where do they look first?
- **Ask what they would not build.** Good engineers say no to work. Agents never do.

::: rule
**House rule**

Hire for review, specification and operations. Assume every candidate can produce code. Find out whether they can tell good code from bad, and whether they can get it to production without breaking anything.
:::

## The honest part

Some jobs will disappear. Roles that were mostly translating tickets into code, with little ownership of what or why, are being absorbed into agents right now. Pretending otherwise does nobody favors.

But software demand is nowhere near saturated. Most businesses still run on spreadsheets, email threads and tools that almost fit. When the cost of building drops by an order of magnitude, the amount of software worth building grows by more. Someone has to decide what to build, direct the agents, and stand behind the result.

That someone is an engineer. The title stays. The job description changed.
