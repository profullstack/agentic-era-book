# Ship Everywhere {#ship}

Here is a sentence we put in our own rules because we kept forgetting it: **a merged PR reaches nobody until the release is cut.**

It sounds obvious. In practice, agents (and tired humans) treat "merged" as "done." The code is on main, the PR is closed, everyone moves on. Meanwhile the npm package is still on last week's version, the Homebrew formula points at an old tarball, and the users who reported the bug are still hitting it.

Merging is the middle of the loop, not the end.

## Release after merge, by default

::: rule
**House rule**

When checks are green and there is no real open question, merge and cut the release without asking. "Should I release this?" is never the question. The question is only "is it correct?", and the gate plus review already answered it.
:::

This rule exists because agents are trained to be polite. Left alone, an agent finishes a change and asks permission to release. Multiply that by forty changes a week and you have forty pauses where a human has to come back, read context and type "yes." That is pure waste. Default to shipping. Make the exception (a breaking change, a migration that needs a window) the thing that requires a human.

```bash
gh pr merge --squash --delete-branch
npm version minor
git push --follow-tags
gh release create "v$(node -p 'require("./package.json").version')" --generate-notes
```

## One codebase, every channel

Shipping a modern tool is not one release. It is npm, a curl installer, Homebrew, Scoop, winget, AUR, maybe Chocolatey, maybe an APT and RPM repo, maybe a Nix flake. PairUX alone ships through Homebrew, winget, Scoop, APT, RPM and Nix. Doing that by hand for every release is how projects end up with six channels on six different versions.

::: tool
**Tool: sh1pt**

sh1pt takes one codebase to every store, registry, CDN and channel. It also handles the part most release tools ignore, bare metal: `deploy-ssh` ships to your own boxes using an OpenInstall `bin/install.sh`. And `sh1pt openapi diff` checks your API spec for breaking changes before they go out, which is the kind of mistake an agent will make confidently and a human will miss in review.

```bash
curl -fsSL https://sh1pt.com/install.sh | sh
# or
npm i -g @profullstack/sh1pt
```

More at [sh1pt.com](https://sh1pt.com).
:::

```bash
sh1pt openapi diff     # fail the build on a breaking API change
```

We gate CI on that diff in production repos. An agent that renames a response field because the new name is "clearer" will break every client of that API. The diff catches it before a user does.

## Installers that do the whole job

Our rule here is short: **no manual setup steps.** If the README says "then edit this config file" or "now run these four commands," the installer is not finished.

The reason is agents. A human can follow a README with judgement. An agent following a README will do exactly what it says, and when step three silently assumes something the agent's box does not have, it fails in a way that takes an hour to diagnose. An installer that does the whole job works the same for a human, an agent and a CI runner.

Every tool in this book installs the same way:

```bash
curl -fsSL https://<product>/install.sh | sh
```

The installer detects the platform, installs dependencies, puts the binary on the path and sets up whatever background service the tool needs. Desktop apps bundle their CLI, so there is no "also install Node 22" step. One line, done.

::: tip
**Tip**

Test your installer on a fresh box, as a non-root user, every release. The most common installer bug is not a bug in the installer; it is something already on your machine that the installer quietly depends on.
:::

## Bare metal, not Kubernetes

This is where we lose some readers, so we will be brief and direct. We run our fleet on bare-metal boxes with git, rsync, systemd and nginx. No Kubernetes. We moved off the managed platforms we used to rent.

Why? Because an agent can operate a box. It can read a systemd unit, tail a journal, edit an nginx vhost and restart a service, all with tools that have been stable for a decade and are documented in everything it was trained on. A Kubernetes cluster adds a control plane, a dozen CRDs and a YAML dialect per vendor, and every one of those is a place an agent can be confidently wrong.

```bash
ssh deploy@box 'cd /srv/app && git pull && pnpm install --frozen-lockfile && pnpm build && sudo systemctl restart app'
```

If your team truly needs a cluster, run one. But try asking whether the cluster is serving your users or the other way around.

## Verify live

A deploy that succeeded is not a site that works. CI said green, the deploy log said done, and the page returns a 502 because a migration never ran, or a 403 because a file landed with the wrong permissions.

So the loop has a phase whose whole job is to look:

```bash
curl -sI https://profullstack.com/book | head -1
curl -s https://profullstack.com/book | grep -c "Agentic Era"
```

Status code first, then a string you know should be on the page. If you shipped an API, call the endpoint you changed with a real request. If you shipped a CLI, install it from the public channel on a clean box and run `--version`.

::: rule
**House rule**

Nothing is "live" until someone has requested it from the outside and seen the expected content. A tool reporting success is not the same as the user seeing the change.
:::

We learned this one from a publishing pipeline that reported "ok" on every post for weeks while the posts were served as 403s, because of a umask setting on the box. The tool was telling the truth about what it did. It just was not what we cared about.

## Correct, then ratchet

When verification finds a problem, you correct it. Fine. Every team does that.

The phase most teams skip is the ratchet: **every production escape becomes a permanent automated check, confirmed to fail when the bug is reintroduced.**

Both halves matter. "Permanent automated check" means a test, a CI step, a lint rule, a post-deploy probe, something that runs without anyone remembering to run it. "Confirmed to fail when the bug comes back" means you actually reintroduce the bug, watch the check go red, then restore the fix and watch it go green. A test that has never failed has never proved it can.

```bash
# 1. add the check, with the fix in place
pnpm test                      # must PASS
# 2. put the bug back (revert just the fix, not the test)
git show <fix-sha> -- src/ | git apply -R
pnpm test                      # must FAIL
# 3. restore the fix
git checkout -- src/
pnpm test                      # must PASS again
```

This is how a fleet gets better instead of just bigger. Agents will reproduce old mistakes; that is what pattern matching does. The ratchet means each mistake gets made in production exactly once.

## The end of the loop is not the release

You merged, released to every channel, verified live and ratcheted the escape into a check. The software is out there.

And still nobody knows. The last phase of the loop is the one engineers most like to skip, which is why it is a phase and not a suggestion. That is the next chapter.
