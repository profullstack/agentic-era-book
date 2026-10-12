# The Bottleneck Moved {#bottleneck}

Every engineering process you have ever used was designed around one scarce resource: the hours it takes a skilled person to turn an idea into working code. Sprints, story points, estimation poker, code freezes, the whole ceremony of the standup. All of it exists to ration typing time.

That resource is no longer scarce. A capable coding agent will produce a plausible implementation of a well-described feature in minutes. It will do it at three in the morning. It will do it in eight repositories at once if you let it. The marginal cost of a first draft of code is now close to the cost of the tokens, and tokens keep getting cheaper.

This does not mean software got easy. It means the hard parts moved.

## Where the cost went

When writing code is cheap, four things become expensive.

**Knowing what to build.** An agent will happily build the wrong thing, quickly and well. The skill that used to be called "product sense" or "requirements" is now the first gate in the pipeline, and a vague request produces vague software at machine speed.

**Knowing whether it works.** A human who writes 200 lines a day can review their own work as they go. An agent that writes 5,000 lines before lunch cannot be trusted the same way, and you cannot read all of it. Tests, types, linters, CI and the habit of checking the live system become the actual product of your engineering team.

**Knowing what it touched.** Agents act. They run commands, edit configs, push branches, call APIs and occasionally delete things. The question "what did this change and who authorized it" used to be answered by a person's memory. Now it needs to be answered by the system.

**Getting it into the world.** A feature that is merged but not released, released but not deployed, or deployed but not announced is worth nothing. When the building is fast, the last mile becomes most of the mile.

## The new unit of work

In the old world, the unit of work was a ticket sized to a human: a few hours to a few days. In the agentic world the unit of work is a **frame**: a clear statement of what done looks like, scoped tightly enough that an agent can finish it in one session and a human can verify it in one sitting.

A good frame has four parts:

1. The goal, in one sentence a stakeholder would recognize.
2. The constraints: which repo, which stack, what must not change.
3. The acceptance check: the command, URL or test that proves it works.
4. The exit: what gets merged, released and announced when it passes.

If you cannot write the acceptance check, you are not ready to hand the work to an agent. You are not ready to hand it to a human either, but humans are better at hiding that.

::: rule
**House rule**

No acceptance check, no agent. If you cannot say how you will know it worked, write that first.
:::

## Throughput is not the point

The obvious mistake is to measure the agentic era by lines of code or pull requests per day. Those numbers go up dramatically and mean very little. We have had weeks with hundreds of merged PRs across the fleet, and the ones that mattered were the handful that closed a real customer problem or prevented the next outage.

The better measures are the ones that were always the right ones, now with less noise:

- Time from request to verified live change.
- Production escapes per release, and whether each escape became a permanent check.
- How often a human had to redo an agent's work, and why.
- Money and tokens spent per shipped outcome.

When you measure these, you find out quickly that the gains come from the loop around the agent, not from the agent itself. The model you use matters less than whether you have a gate it cannot skip.

## The engineer did not go away

There is a popular story that says engineers are about to be replaced. It is wrong in an instructive way. What is being replaced is the part of the job that was always the least interesting: transcribing a design you already understood into syntax the compiler would accept.

What remains is judgment. Which problem is worth solving. Which of three plausible implementations is correct. Whether a passing test actually tests anything. Whether this change is safe to ship on a Friday. Whether the agent that just said "done" is telling the truth. These are senior engineering skills, and the agentic era rewards them more than any era before it.

The result is a different shape of team. Not ten engineers each writing code, but one engineer directing ten agents, with the judgment of that one engineer as the bottleneck that matters. The next chapter is about what that looks like in practice.

::: tip
**Tip**

Before you adopt any agent tooling, write down your current request-to-live time for one ordinary change. Measure it again in a month. That number is the only honest benchmark.
:::
