# Review Is the Job {#review}

For forty years the scarce resource in software was the person who could write the code. Now the code is cheap. An agent will happily produce a thousand lines before you finish your coffee.

So what is scarce? Judgement. The ability to look at a change and say: yes, this ships; no, this is wrong; this is right but it is in the wrong place. In the agentic era, the senior engineer's main job is deciding what merges. Everything else in this chapter exists to make that decision fast and to make it correct.

## The engineer decides; the gate filters

There are two layers of review and they do different work.

The **gate** is automated: tests, typecheck, lint, security scans. It is fast, it is tireless and it is dumb. It answers "does this break anything we already know how to check?"

The **engineer** is the expensive layer. They answer the questions a machine cannot: is this the right change? Does it fit the architecture? Does it solve the problem in the frame, or a slightly different problem the agent found more interesting? Will this hurt us in six months?

The mistake teams make is spending engineer attention on things the gate should catch. If a human is pointing out a type error in review, your gate has a hole. Fix the gate, and the human gets to spend their time on judgement.

## CI on every repo, no exceptions

We run about 170 repositories. Every one of them carries the same three workflows:

```text
.github/workflows/ci.yml                 # tests, typecheck, lint, build
.github/workflows/codeql.yml             # static analysis
.github/workflows/threatcrush-scan.yml   # security scan
```

Not "the important repos". Every repo. The tiny CLI that nobody touches gets the same three checks as the payment system, because with agents, the repo nobody touches is exactly where a careless change sneaks through.

::: tool
**Tool: ThreatCrush**

ThreatCrush is a server security daemon and a CI scanner. On a box it tails nginx, auth and syslog against OWASP CRS rules, guards SSH, watches DNS and connections, and bans offenders automatically. In CI, `threatcrush-scan.yml` runs on every push. It also ships `ai-scan`, a red-team scanner for the OWASP LLM Top 10, which matters once your product has a model in it.

```bash
curl -fsSL https://threatcrush.com/install.sh | sh
# or
npm i -g @profullstack/threatcrush
```

More at [threatcrush.com](https://threatcrush.com).
:::

## Four lessons we paid for

Every one of these is a rule because an agent (or we) got it wrong at least once, and it was annoying enough to write down.

### Verify the commit, not the worktree

An agent runs the tests. Green. It runs typecheck. Green. It commits and pushes. CI goes red.

What happened? The agent tested the working tree, and the working tree had an uncommitted file that the commit did not include. Or a stale build artifact. Or a local change from a previous attempt. A green run on a dirty tree proves nothing about what you pushed.

::: rule
**House rule**

Before you say "tests pass", make sure the tree is clean and the thing you tested is the thing you committed. `git status` should be empty. If it is not, you tested something nobody else will ever run.
:::

```bash
git status --porcelain   # must print nothing
pnpm test
```

### Baseline before you blame "pre-existing"

The most popular excuse in agent output is "this failure is pre-existing and unrelated to my change." Sometimes true. Often not.

The only honest way to make that claim is to run the same tests on the base branch and see the same failure there. If you did not check out the base and run them, you do not know.

```bash
git worktree add ../baseline master   # a clean copy of the base, no stash needed
cd ../baseline && pnpm install && pnpm test
```

Import analysis is not a substitute. We have watched a change leak into an unrelated test through a shared global that no import graph would show. Run the tests on the base. It takes two minutes and it ends the argument.

### A green CodeQL check only means no new alerts

CodeQL's PR check compares your branch against the base. Green means "this PR introduced no new alerts." It does not mean the existing alert you were asked to fix is gone. An agent that says "fixed the SQL injection alert, CodeQL is green" may be telling you that the check passed while the alert sits there, unchanged, on the base branch and on yours.

To claim a fix, look at the alert itself and confirm it closed after the merge. The check is not evidence.

### Empty tool output is not a pass

This one is subtle and it is everywhere. You run a filtered gate:

```bash
pnpm test 2>&1 | grep FAIL
```

It prints nothing. Pass? Maybe. Or maybe `pnpm` was not on the path, the test runner never started, and grep had nothing to filter. Silence looks exactly like success.

::: tip
**Tip**

Any gate that can pass by printing nothing must also print something when it succeeds. Check the exit code, or look for a positive line ("Tests: 214 passed") rather than the absence of a negative one.
:::

## The PR is how a human reads the change

There is a tension in our own rules worth being honest about. Our public pricing page says every change ships through review, tests and CI. Our own Fleet SysOps Manifesto says agents push straight to main with `--yolo` on, test in prod, never roll back.

Both are true, and the reconciliation is the point of this chapter. The pull request is not a waiting room. It is how a human reads the change. Agents open it, the gate runs on it, and when it is green and the engineer is satisfied it merges immediately. Nobody parks a PR for two days waiting for a ritual approval. If the gate is green and there is no real question, it merges.

What the engineer looks for in that read:

- **Does it match the frame?** Agents drift. The frame said "move the booking page", the diff also renamed three components "for consistency."
- **Is the blast radius what you expected?** A one-line fix that touches 40 files is not a one-line fix.
- **Is there a test for the thing that changed?** Not for everything. For the thing that changed.
- **Would you understand this in six months?** Agents write correct code that nobody can read. That is a real cost.

When the answer is no, the fix is almost never to edit the code yourself. Write a better frame, send it back, let the agent redo it. Your time is the scarce resource. Spend it on the decision, not the keystrokes.

## Tools that make review faster

Reading 30 PRs a day across dozens of repos is its own problem. We built a few small things to make that bearable.

::: tool
**Tool: cli-tools**

cli-tools is about fifty fleet commands in one install. For review, the ones that matter are `gh-prs`, which lists open PRs across every org you belong to, and `gh-prs-merge`, which squash-merges every green PR across orgs in one go. It also installs the Profullstack skill into every coding agent on the box, so your agents know the house rules before they write a line.

```bash
curl -fsSL https://raw.githubusercontent.com/profullstack/cli-tools/master/install.sh | sh
# or, if you already have moshcode
moshcode install cli-tools
```
:::

```bash
gh-prs            # what is waiting, everywhere
gh-prs-merge      # merge everything that is green
```

That second command sounds reckless. It is not, if your gate is honest. That is the whole bargain: you can only afford to merge fast if the checks mean something. Spend the effort on the checks, and merging becomes boring. Boring is what you want.
