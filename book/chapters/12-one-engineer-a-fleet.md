# One Engineer, a Fleet {#fleet}

Profullstack calls itself an agentic engineering firm. The phrase means something specific: one senior engineer directs a fleet of AI coding agents on a codebase, and every change ships through review, tests and CI. It is how we price our work, and it is how this book was made.

This chapter is about what that feels like from the chair.

## The conductor, not the soloist

Picture a normal morning. Overnight, a few agents worked through a queue: a dependency bump that needed a code change, a flaky test, a customer bug report forwarded from email, a new page for a marketing site. By the time the engineer sits down there are pull requests waiting, each with a description of what changed and a green or red CI badge.

The engineer's first hour is reading, not writing. Which of these is correct? Which passed CI but tested the wrong thing? Which one touched a file it had no business touching? Some get merged and released on the spot. Some get a one-line correction and go back to the agent. One gets closed because the request itself was wrong.

The second hour is framing. Three new pieces of work, each written as a frame with a goal, constraints, an acceptance check and an exit. Each goes to an agent in its own isolated worktree, so they cannot trample each other. Then the engineer goes and does the thing only a human can do: talk to a customer, make a call about pricing, decide what not to build.

That is the job. It is closer to an editor or a film director than to the lone programmer of popular imagination.

## What a fleet actually is

A fleet is not a magic swarm. It is a set of agent sessions, each with:

- **A task**, framed so it can finish.
- **A sandbox**: a git worktree, a container, a scratch directory that dies with the job.
- **Credentials** scoped to what the task needs, pulled from a vault and never pasted into a prompt.
- **A gate**: tests and checks the agent must pass before anything it made reaches a human.
- **A trail**: who started it, what it ran, what it changed.

Some sessions are long-lived and some are one-shot. Some run on your laptop, some on a remote box that keeps going when your laptop sleeps. Some use one model and some fan the same task across several and compare. The tooling to manage all of this is what Part II is about.

::: tool
**Tool: moshcode**

moshcode is a metal wrapper CLI for agentic coding. It does not replace your agents. It installs and drives the ones you already use (Claude Code, Codex, opencode, Gemini, Kimi, aider and others) and adds the things a fleet needs: persistent sessions (`herd`), plan-then-fan-out runs that synthesize one verified answer (`swarm`), moving a conversation between engines (`handoff`) and per-session spend (`cost`).

```bash
curl -fsSL https://moshcoding.com/install.sh | sh
```
:::

## The economics

Here is the uncomfortable math. An agent session that runs for an hour costs a few dollars in tokens. The engineer directing it costs a great deal more. So the scarce resource is the engineer's attention, and the whole system should be designed to spend it only where it matters.

That has practical consequences:

- **Make agents do their own checking.** Every minute an engineer spends discovering that tests fail is a minute the agent should have spent.
- **Make review fast.** Small diffs, clear descriptions, a link to the live preview. If a PR takes twenty minutes to understand, the frame was too big.
- **Never make a human ask permission for routine work.** If tests pass and nobody raised a real question, merge it and release it. Waiting is a cost too.
- **Batch the human decisions.** A list of five yes-or-no questions answered in two minutes beats five interruptions spread across a day.

This is why we price our build work per agent hour rather than per engineer hour. What a client buys is directed agent throughput with a senior engineer accountable for every merge.

## What changes for teams

If you lead a team, the agentic era changes three things about how you run it.

**Seniority compresses toward judgment.** A junior engineer with good agents can produce code at a senior rate. They cannot yet judge it at a senior rate. Your job is to give them the gates that catch what they miss, and the review habits that teach them to see it.

**Coordination costs drop, then spike.** Fewer humans means fewer meetings. But many agents working in parallel on one codebase will collide: two sessions shipping the same feature, one session's stash popped by another, a migration written twice. The fix is boring infrastructure: isolation per task, a check for sibling work before starting, and clear ownership of every branch.

**Documentation becomes executable.** Agents read your docs literally and act on them. A stale README is no longer a minor embarrassment, it is a bug that ships. The best teams treat files like `stack.md` and `skill.md` as code, with owners and reviews.

::: rule
**House rule**

Never make someone ask "should I release?" If checks are green and nobody raised a real question, merge, release and promote. The default is ship.
:::

## The shape of the rest of this book

A fleet needs a workbench, a loop and an operating model. The workbench is where the engineer and the agents meet: the terminal, the browser, the shared screen and the stack definition they both read. The loop is how a frame becomes a release. The operating model covers the parts that make a fleet safe to run for real: keys, money, identity and compute.

Before any of that, though, you need a clear view of how agents fail. That is next.
