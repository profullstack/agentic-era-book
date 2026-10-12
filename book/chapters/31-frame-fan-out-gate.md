# Frame, Fan Out, Gate {#frame-fan-out-gate}

Most teams that try agents bolt them onto a process built for people. A ticket goes into a sprint, somebody picks it up on Tuesday, a PR sits for two days waiting for a reviewer who is in meetings. Then the agent writes the code in four minutes and everyone wonders why nothing got faster.

The typing was never the slow part. The waiting was. If you want the speed agents can give you, the process has to be rebuilt around them, and the process has to be written down so that an agent can follow it too.

We wrote ours down. It is called ASDLC, the Agentic Software Development Life Cycle, and it lives at [logicsrc.com/asdlc](https://logicsrc.com/asdlc) as an open spec. It has nine phases:

1. **Frame**: say what done looks like.
2. **Fan out**: split the work across agents.
3. **Gate locally**: tests, typecheck and lint pass before anything leaves the box.
4. **Merge**: into the default branch.
5. **Release**: cut it, tag it, publish it.
6. **Verify live**: prove the thing works where users touch it.
7. **Correct**: fix what verification found.
8. **Ratchet**: turn every escape into a permanent check.
9. **Promote**: tell people.

This chapter covers the first three. The rest of Part III covers the other six.

## Frame: write the spec an agent can execute

A frame is a short document that answers three questions. What is changing? How will we know it worked? What must not break?

That is it. Not a twelve-page PRD, not a Figma file with forty frames. Agents are very good at filling in the middle of a task and very bad at guessing where its edges are. The frame gives them the edges.

A good frame for an agent reads like this:

```markdown
## Goal
/book serves the ebook landing page. The diagnostic call page moves to /diagnostic.

## Done when
- GET /book returns 200 and contains the cover image
- every internal link that pointed at the old /book booking page now points at /diagnostic
- `pnpm test`, `pnpm typecheck`, `pnpm lint` pass

## Do not touch
- the contact form guard
- anything under src/app/shop
```

Notice what is missing: implementation detail. The agent can read the codebase faster than you can describe it. What it cannot read is your intent. Write the intent, the acceptance test and the blast radius, and let the agent do the rest.

::: tip
**Tip**

If you cannot write the "Done when" section, you are not ready to hand the task to anyone, human or agent. Spend the five minutes there. It is the cheapest debugging you will ever do.
:::

## Fan out: one worktree per agent

Once a task is framed, it can be split. The unit of isolation for us is the git worktree. Every agent gets its own checkout on its own branch, sharing one object store with the main repo.

```bash
git worktree add .claude/worktrees/book-page -b feat/book-page
cd .claude/worktrees/book-page
```

A worktree is cheap (no fresh clone, no duplicated history) and it means two agents never fight over the same working directory. When the branch merges, remove it:

```bash
git worktree remove .claude/worktrees/book-page
```

Do not skip the cleanup. A scratch checkout that outlives its session is disk you will be hunting for later, usually at the worst possible moment.

### The stash trap

Here is the one that bites everybody once. `git stash` is not per worktree. It is one stack per repository, shared by every worktree attached to it. Two agents in two worktrees both run `git stash` and `git stash pop`, and one of them pops the other one's changes. Edits vanish and somebody else's edits appear in their place. Nothing errors.

::: rule
**House rule**

Agents in worktrees do not use bare `git stash`. To set work aside, make a temporary WIP commit on your own branch. If you truly must stash, push with a unique message, capture the entry's SHA, and apply by SHA instead of popping.
:::

### Check for a sibling before a long build

When several agents run in parallel, sometimes two of them are pointed at the same feature by two different prompts. Both build it. Both open a PR. One of them wasted an hour.

Before any long build, an agent checks the open PRs and branches for the same work:

```bash
gh pr list --search "book in:title" --state open
git branch -r | grep -i book
```

Ten seconds of looking saves an hour of duplicate work and a merge conflict you then have to referee.

## Moshcode: herding the agents

Fanning out by hand works for two agents. At six it turns into tmux archaeology. That is the problem moshcode exists to solve.

::: tool
**Tool: moshcode**

moshcode is a metal wrapper CLI for agentic coding. It does not replace your agents. It installs and drives the ones you already use (Claude Code, Codex, opencode, Gemini, Kimi, aider and others) and adds the plumbing a fleet needs: `herd` for persistent sessions, `swarm` to plan a task, fan it out across engines, verify the results and synthesise one answer, `handoff` to move a conversation from one engine to another, and `cost` to see what each session is burning.

```bash
curl -fsSL https://moshcoding.com/install.sh | sh
moshcode upgrade self
```

Source and docs: [github.com/moshcoder/moshcode](https://github.com/moshcoder/moshcode), site at [moshcoding.com](https://moshcoding.com).
:::

The commands map almost one to one onto ASDLC.

**`herd`** keeps sessions alive. An agent working through a long migration should not die because your laptop went to sleep. Herd sessions persist, so you can walk away and come back to the same conversation.

**`swarm`** is fan out plus verify. Give it one task and it plans, sends the pieces across several engines, checks their output and hands you a single synthesised answer. It is the closest thing to "ask three senior engineers and take the best answer" that you can run from a shell.

**`handoff`** matters more than it sounds. Different models are good at different things. One is a better planner, another is a faster, cheaper implementer, a third is the one you trust on tricky refactors. Handoff moves the conversation, context and all, from one engine to the next without you pasting a transcript.

**`cost`** keeps you honest. Agents burn money the way junior engineers burn time: quietly, and in proportion to how vague the instructions were. Check cost per session, and when one task costs ten times its siblings, the frame was probably bad.

```bash
moshcode swarm "add /diagnostic route and move the booking page there"
moshcode cost
```

## Gate locally: nothing leaves the box red

The last phase before merge is the local gate, and it is non-negotiable. Tests, typecheck and lint run on the agent's machine before a single commit goes up.

```bash
pnpm test && pnpm typecheck && pnpm lint && git push
```

Why locally, when CI will run the same thing in two minutes? Because CI is shared, and a red push wastes everyone's queue and everyone's attention. Because an agent that sees its own failure immediately fixes it in the same context, while an agent that sees it ten minutes later in a CI log has to rebuild that context first. And because "CI will catch it" is how a fleet of agents learns to push garbage and let the robots sort it out.

::: rule
**House rule**

The local gate runs before every push, even for one-line changes, even in a hurry. If the gate is too slow to run every time, the gate is the bug. Make it faster, do not skip it.
:::

### What the gate is not

The gate is not proof. A green local run on a dirty tree tells you nothing about the commit you actually pushed, which is a whole topic in the next chapter. It is the floor, not the ceiling. Its job is to make sure the expensive part of the loop, human review, is spent on questions of judgement and not on a missing semicolon.

## Putting it together

A real afternoon in our shop looks like this. One engineer writes four frames. Each goes to an agent in its own worktree, some through `moshcode swarm` when the answer is uncertain enough to want a second and third opinion. Each agent checks for siblings, builds, runs the local gate and pushes. The engineer's attention goes where it belongs: reading the changes and deciding what merges.

That is the subject of the next chapter, because it turns out reviewing is the job now.
