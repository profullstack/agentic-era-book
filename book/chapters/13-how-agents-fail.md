# How Agents Fail {#failure}

Agents are astonishing at the things they are good at and quietly dangerous at the rest. The danger is rarely dramatic. It is an agent that says "all tests pass" when no tests ran, or a fix that works on a dirty working tree and not on the commit that got pushed. Every failure in this chapter happened to us. Each one became a rule.

## Failure 1: The confident non-result

An agent runs a check, the check prints nothing, and the agent reports success. Empty output is not a pass. A filtered test command that matched zero files, a linter pointed at the wrong directory, a grep that found nothing because the path was wrong: all of them look like green.

The defense is to make every gate prove it ran. Count the tests. Print the file list. Fail the job when the count is zero.

::: rule
**House rule**

Empty tool output is not a pass. A gate that printed nothing may not have run at all.
:::

## Failure 2: Verifying the wrong thing

The agent edits files, runs the tests, sees green, commits some of the files and pushes. The tests passed against the working tree, which included an uncommitted change the commit does not. CI goes red, or worse, CI does not cover that path and production does.

Verify the commit, not the worktree. Run the gate on a clean checkout of exactly what you are about to merge.

## Failure 3: "It was already broken"

An agent hits a failing test, decides it is unrelated to its change, and says so. Sometimes that is true. Often it is not: the change leaked state through a global, or an import order shifted, or a shared fixture got mutated. Unless the agent ran the same tests on the base branch first, "pre-existing" is a guess.

::: tip
**Tip**

Make "run the suite on the base branch" the first step of any frame where tests might already be red. It takes a minute and settles the argument.
:::

## Failure 4: The green check that proves nothing

Security scanners and code analysis tools on pull requests usually report new findings relative to the base. A green check means the change did not add an alert. It does not mean the alert you were asked to fix is gone. Agents (and people) routinely confuse the two.

Close the loop on the thing itself: rerun the scanner on the default branch after merge and confirm the specific alert closed.

## Failure 5: Parallel agents, shared state

Run several agents on one repository and they will find every piece of shared state you forgot about. The git stash is one stack per repository, shared by every worktree, so one session pops another session's work. Two sessions given overlapping frames both ship the same feature. A cache directory gets clobbered. A scratch folder in `/tmp` fills a per-user quota and every command on the box starts failing with empty output.

Isolation is the answer: one worktree per agent, scratch space that belongs to the job and is deleted with it, and a quick search for open pull requests on the same topic before starting a long build.

## Failure 6: Doing exactly what the docs said

Agents trust documentation more than humans do. If your setup guide says to use a package that was never published, the agent will try to install it, fail, and then write its own version of it. If your style guide says to use a library you abandoned last year, you will get new code using the abandoned library.

Stale docs are bugs. Keep one machine-readable source of truth for your stack and have everything else point at it. We keep ours at `profullstack.com/stack.md` and our older `skill.md` defers to it explicitly.

## Failure 7: Scope creep at machine speed

Ask an agent to fix a typo and it may also reformat the file, rename a variable it disliked and upgrade a dependency. Each change is defensible. Together they turn a one-line review into a twenty-minute one, and one of them breaks something.

Frames should say what must not change. Reviews should reject unrequested changes even when they look like improvements. The agent can open a separate PR for its good ideas.

## Failure 8: Acting outward without asking

Most agent actions are reversible: edit a file, run a test, make a branch. Some are not: send an email to a customer list, post to social media, delete a database, charge a card, force-push over someone's branch, buy a domain. An agent that cannot tell the difference will eventually do something you cannot undo.

The rule we use: anything outward-facing or hard to reverse needs an explicit yes for that exact action, at that exact price, from a human. Approval for one purchase is not approval for the next.

::: rule
**House rule**

Confirm before buying, sending or deleting. State the exact item and the exact cost, get an explicit yes, and never substitute something "close enough."
:::

## Failure 9: Secrets in the wrong place

Agents read everything in the working directory, including `.env` files, and they will happily paste a key into a log, a commit or a prompt to another service. Keep secrets in a vault, inject them at runtime, and give each agent only the keys its task needs. Part IV goes deeper.

## The pattern behind the failures

Look at the list again. None of these are failures of intelligence. The models are smart enough. They are failures of verification, isolation and authority: the agent believed something without checking, touched something it shared, or did something nobody approved.

That is good news, because all three are engineering problems with engineering solutions. The rest of this book is mostly those solutions, and the tools we built to make them the default instead of a discipline.
