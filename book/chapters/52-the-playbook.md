# The Playbook {#playbook}

Everything in this book, compressed into checklists. Print it, pin it, paste it into your agent's instructions. These are the lists we actually run.

## Day one: set up the workbench

Install the tools once, on every machine you or your agents work from.

```bash
# the agent wrapper: drives Claude Code, Codex, opencode, Gemini and more
curl -fsSL https://moshcoding.com/install.sh | sh

# the fleet command kit: search, PR merging, mail, audits and more
curl -fsSL https://raw.githubusercontent.com/profullstack/cli-tools/master/install.sh | sh

# sessions that survive sleep and network changes
curl -fsSL https://hqterm.sh/install | sh

# an agent-drivable browser with an MCP server
curl -fsSL https://tronbrowser.dev/install.sh | sh

# screen sharing with two cursors (macOS shown; also winget, Scoop, APT, RPM, Nix)
brew tap profullstack/homebrew-pairux && brew install --cask pairux
```

Then:

- [ ] Secrets in a team vault, pulled with `logicsrc teams pull`. Delete every `.env` you find.
- [ ] Read the house stack: `curl -s https://profullstack.com/stack.md`.
- [ ] Give your agent a name, an owner and a published record.
- [ ] Turn on `moshcode cost` and look at it tomorrow.
- [ ] Every repo has `ci.yml`, `codeql.yml` and a security scan before an agent pushes to it.

## The per-task loop

For every piece of work, from a one-line fix to a new product:

1. **Frame.** Write the goal, the constraints, the files that matter and what done looks like. If you cannot write it in a paragraph, split the task.
2. **Check for siblings.** Is another agent or another PR already doing this? Look before you build.
3. **Isolate.** New git worktree, new branch, one agent per worktree. Never share a stash.
4. **Fan out.** Independent pieces go to parallel agents. Dependent pieces wait.
5. **Gate locally.** Tests, typecheck, lint. Run the baseline on the base branch before you call a failure pre-existing.
6. **Review.** Read the diff. All of it. Verify the commit, not the dirty worktree.
7. **Merge.** Green and no real question means merge. Do not park PRs.
8. **Release.** A merged change reaches nobody until the release is cut.
9. **Verify live.** Hit the real URL, run the real command. "CI passed" is not "it works".
10. **Ratchet.** If anything escaped, add the check that would have caught it, and prove it fails without the fix.
11. **Promote.** Tell people. Shipping in silence is half shipping.

## The merge checklist

Before anything merges:

- [ ] The diff does what the task said, and nothing else.
- [ ] Tests exist for the new behaviour, and they fail without the change.
- [ ] No secrets, tokens or `.env` files in the diff.
- [ ] No new dependency where a house package or ten lines would do.
- [ ] The security scan is green, and you know green means "no new alerts", not "safe".
- [ ] Migrations are written and will actually run in production.
- [ ] Someone (you) could explain every changed line to a customer.

## The release checklist

- [ ] Version bumped in every file that holds it.
- [ ] Release cut and published to every channel (`sh1pt` does it in one command).
- [ ] Installers do the whole job: no "now edit this config by hand" step.
- [ ] Verified live: the page loads, the command runs, the new version answers.
- [ ] Announced through myna (`myna post --to all`), with a blog post if it is a major feature.

## The weekly fleet review

Thirty minutes, every week. Agents do not notice slow drift; you have to.

- [ ] **Spend.** Which sessions, models and agents cost the most? Anything looping?
- [ ] **Keys.** Any key copied into more vaults than last week? Anything to rotate?
- [ ] **Security.** New ThreatCrush findings? Anything auto-banned that should not be?
- [ ] **Escapes.** Every bug that reached production this week has a ratchet check.
- [ ] **Stale work.** PRs older than a day, worktrees nobody is using, scratch directories that outlived their session. Merge, close or delete.
- [ ] **Docs agents read.** Is `stack.md` still true? Did a convention change that agents keep getting wrong?
- [ ] **Fallbacks.** Has the backup inference provider actually been tested this week?

::: rule
**House rule**

If you did it by hand twice, automate it the third time. The fleet grows only as fast as the boring parts disappear.
:::

## Hire the fleet

If you read this far and thought "we should work like this, but we do not have time to build it": that is what we do for a living.

Profullstack is an agentic engineering firm. One senior engineer directs a fleet of AI coding agents on your codebase, and every change ships through review, tests and CI. No agency headcount, no template sites, no six-month timeline before you see something real.

Here is how to start, cheapest first:

- **Free 30-minute diagnostic.** We look at your project, name the biggest technical risks, and tell you straight whether we are the right fit. Book it at [profullstack.com/diagnostic](https://profullstack.com/diagnostic).
- **Free 48-hour clickable mock.** Describe the product; within two days you can click through it.
- **Paid trial task.** One real task on your real codebase, hard capped at 5 hours at $100 per hour per agent. You see exactly how the fleet works before you commit to anything.
- **The build.** $100 per hour per agent, or $100 per hour for human intervention, directed by a senior engineer, shipped through your review, your tests and your CI.
- **Monthly retainer.** $2,500 a month for up to 25 hours at $100 per hour per agent, for teams that want hours on tap.
- **Fixed-price security audit.** We audit your code and deliver the fixes as pull requests, not a PDF of warnings.

Details and pricing: [profullstack.com/plans](https://profullstack.com/plans).

Or do it yourself. Every tool in this book is real, installable and documented. Take the playbook, set up the workbench, and start directing.

Either way: welcome to the agentic era. Go ship something.
