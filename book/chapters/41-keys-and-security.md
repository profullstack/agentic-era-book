# Keys, Vaults and Blast Radius {#security}

Every agent you run is a process with your credentials in its environment. That is the whole security model in one sentence, and most teams have not thought about it yet.

A human engineer with a production database password is trusted because of years of context: they know which table not to drop, they hesitate before a `DELETE` without a `WHERE`, they get a bad feeling. An agent has none of that. It has a goal, a shell and whatever keys you handed it. It will use all three, quickly, and it will not get a bad feeling.

So the question is never "do we trust the agent?" The question is "if this agent does the dumbest possible thing with what it holds, how bad is the day?" That is blast radius, and managing it is the security job of the agentic era.

## Stop putting secrets in `.env`

The `.env` file is the cockroach of software engineering. It survives every rewrite, it gets committed by accident, it gets copied into a Docker image, it gets pasted into a chat window so an agent can "see the config". With a fleet of agents reading every file in the repo, a plaintext secrets file in the working tree is a secret you have already shared with every model provider you use.

We keep secrets in a team vault and pull them at runtime.

```bash
# pull the team's secrets for this project into the process, not onto disk
logicsrc teams pull
```

The vault is the source of truth. A key rotates in one place. A new box, a new agent, a new worktree gets the same keys by the same command, which means nobody improvises a copy.

::: rule
**House rule**

Secrets live in the vault, never in `.env`. If an installer or a README tells someone to "create a .env file and paste your key", that is a bug in the installer.
:::

## God Mode keys and why we still use them

Our own manifesto says it plainly: God Mode keys. Agents get real credentials with real power, because an agent that has to file a ticket to read a log is an agent that does not finish the task. We would rather move fast with full access than build an approval bureaucracy for robots.

That is a deliberate trade, and it only works if you are honest about the cost. Full access means full blast radius. So we push the safety somewhere other than "take the keys away":

- **Scope by project, not by person.** An agent working on one app pulls that app's vault, not the company vault.
- **Know which keys are shared.** One API key copied into thirteen production vaults is one spend limit and one compromise shared across thirteen products. When it leaks, it leaks everywhere at once. Count your copies.
- **Make rotation cheap.** If rotating a key means editing six servers by hand, nobody rotates it. If it means updating the vault and restarting, people actually do it.
- **Log what agents do with keys.** You cannot review what you cannot see.

::: tip
**Tip**

Run a quick audit: list every vault, and for every key, count how many vaults hold a copy. Any key with a count above one is a shared blast radius. Decide on purpose whether that is acceptable.
:::

## Watching the boxes: ThreatCrush

Agents ship more code, more often, to more servers. More surface, more logs, less human attention per line. You need something watching the boxes that does not get bored.

::: tool
**Tool: ThreatCrush**

ThreatCrush is a server security daemon. It tails nginx, auth and syslog, matches traffic against 96 OWASP CRS rules, runs an SSH guard and a DNS and connection monitor, and auto-bans offenders (run it as root so it can ban). On top of the daemon there is a fleet dashboard, teams and agent keys (`tc_agent_` prefixed, so an agent can report in without a human login), an AI red-team scanner (`ai-scan`) that probes for the OWASP LLM Top 10, and a GitHub App plus CI scan.

```bash
curl -fsSL https://threatcrush.com/install.sh | sh
# or
npm i -g @profullstack/threatcrush
```
:::

In our repos the scan is not optional. Every repo carries a `threatcrush-scan.yml` next to `ci.yml` and `codeql.yml`, so the security check runs on the same pull request as the tests. An agent that opens a PR gets security feedback in the same loop as a failing unit test, which is the only place an agent will actually read it.

### Be honest about what a scanner sees

A scanner is a set of opinions about what bad looks like. ThreatCrush's opinions come from web traffic and web stacks: OWASP rules, HTTP logs, the usual JavaScript and PHP suspects. Point it at a Go, C or Rust codebase and it will mostly have nothing useful to say, and we have measured that ourselves. That is not a failure of the tool, it is a reminder about every tool: tune it to your stack, read its output with judgment, and never treat "the scanner was quiet" as proof of safety.

The same goes for auto-ban. Anything that can block traffic can block your own traffic. We once watched a port-scan rule decide that our own upstream services looked hostile. Give auto-ban an allowlist for your own infrastructure before you give it root.

### Scan the pipeline and the AI code too

ThreatCrush watches servers. The other place agents add risk is the pipeline itself: workflow files that run with secrets, and AI-written code that looks plausible and is subtly unsafe.

::: tool
**Tool: vu1nz**

vu1nz is a security scanner for CI/CD workflows and AI-generated code. Drop it into GitHub Actions and every pull request gets checked before it merges.

```yaml
- uses: profullstack/vu1nz-gh-actions/.github/actions/vu1nz-actions-scan@v1
```

Site: [vu1nz.com](https://vu1nz.com)
:::

::: rule
**House rule**

A green security check means "no new alerts", not "fixed". Before you report a vulnerability as resolved, prove it: reproduce the original finding, then show it gone.
:::

## One key for everything: Power Key

Blast radius has a flip side. Sometimes you want one credential to open many doors, on purpose, and you want it to be verifiable without a phone call to a central server.

::: tool
**Tool: Power Key**

Power Key is one Ed25519-signed key that opens every Profullstack property. Each site verifies the signature itself, offline, with no database lookup and no auth server in the path. Send it as `Authorization: Bearer <key>` or in the `x-power-key` header and it works the moment you have it. Lifetime keys are sold at [profullstack.com/shop](https://profullstack.com/shop), paid with crypto through CoinPay.
:::

Offline verification is the interesting part for agents. An agent holding a Power Key can hit any of our services without a login flow, a browser, a session cookie or a callback URL. It is the kind of credential machines are good at: a string, a signature, a header. And because verification is local, there is no central auth service to fall over and take every product down with it.

The trade is the one this whole chapter is about. A key that opens everything is a key with a big blast radius. Treat it like one: keep it in the vault, give it to the agents that need it, and revoke it the moment it shows up somewhere it should not.

## The checklist

Before an agent touches production, ask:

1. Which keys does it hold, and where did it get them?
2. How many other places hold a copy of each key?
3. If it runs the worst command it could run, what breaks?
4. Would you see it happen? Is there a log, a scan, a ban?
5. How long does rotating every key it held take?

If the answer to the last question is "a day of manual work", fix that before you add another agent. The fleet will grow. The blast radius grows with it unless you design it down.
