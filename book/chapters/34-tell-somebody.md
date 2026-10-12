# Tell Somebody {#promote}

Engineers love to believe good software spreads on its own. It does not. A tool nobody has heard of is indistinguishable from a tool that does not exist.

In our loop, promotion is a phase of shipping. Not a marketing department's job, not something we will get to later, not a nice-to-have. The ninth phase of ASDLC is promote, and a release is not finished until it has been announced.

::: rule
**House rule**

Every ship ends with an announcement. Packages, features, meaningful fixes. If it was worth releasing, it is worth one post saying what changed and where to get it.
:::

This used to feel like overhead. With agents, it is the cheapest phase of the whole loop. The agent that wrote the change knows exactly what it does, read every line of the diff and wrote the release notes. Writing three sentences about it for humans is trivial. The only reason it does not happen is that nobody made it part of the process.

## Myna: social from the terminal

We wanted promotion to live where the work already lives: in the terminal, scriptable, callable by an agent at the end of a release. So we built it.

::: tool
**Tool: myna**

myna is a terminal social media manager built on hqtui. It posts to every network you connect with per-network tailoring, runs a scheduling daemon with pacing, reads engagement back, keeps a follow graph, publishes to blog targets (htmlblog, gitblog, dev.to) and sends newsletters. It writes AI drafts but never auto-posts them; a draft waits for a human or an explicit command. It also ships an MCP server, `@profullstack/myna-mcp`, so any agent can drive it.

```bash
curl -fsSL https://mynaposter.com/install.sh | sh
# or
npm i -g @profullstack/myna
```

More at [mynaposter.com](https://mynaposter.com).
:::

The release phase and the promote phase become two adjacent commands:

```bash
gh release create v1.4.0 --generate-notes
myna post --to all "sh1pt 1.4.0: openapi diff now fails the build on removed fields. https://sh1pt.com"
```

`--to all` means every network we post to: Bluesky, LinkedIn, Mastodon and the tsbb board. We dropped X. That was a decision, not an outage, and we have not missed it.

### Pacing beats blasting

Posting forty announcements in one afternoon because forty PRs merged is a great way to get muted. Myna's scheduling daemon (`myna run`) paces the queue, so a busy shipping day becomes a steady week of posts.

```bash
myna run    # the daemon: works through the queue at a sane pace
```

::: tip
**Tip**

If you need to change the copy of something already queued, edit the queue. Do not cancel and re-post: you lose the slot it was scheduled into and it goes to the back of the line.
:::

### Drafts, not autopilot

The AI drafts feature is deliberately conservative. An agent can write a post. It cannot publish one without either a human approving it or an explicit post command in a script you wrote. Your public voice is the one thing in the loop where a confident mistake is permanent and searchable.

## Canonical URL everywhere

When you syndicate (cross-post a blog article to dev.to, mirror it to a newsletter, quote it on a community board), the copy should point back at the original with `rel=canonical`, everywhere the platform supports it.

```html
<link rel="canonical" href="https://profullstack.com/blog/agentic-era-book">
```

On dev.to that is the `canonical_url` front matter field. On your own pages it is the link tag above. Without it, the syndicated copy can outrank the original, and every link anyone shares points at somebody else's site. With it, every copy adds weight to the one page you own.

This is one of those rules an agent will follow perfectly once it is written down and forget every single time it is not. Write it down.

## Blog the big stuff only

Not every merge deserves a blog post. A typo fix gets a release note. A new command gets a social post. A blog post is for a major feature: something that changes what the product can do, or why someone would use it.

We cap automated posts on the blog, because an agent with a blog tool and no limit will happily write one post per commit, and a blog that publishes eleven times a day reads like spam even when every post is accurate. Quality of signal is the whole game. Ten good posts beat a hundred adequate ones.

A useful test before writing one: could you explain in the first sentence why a stranger should care? If the honest answer is "they wouldn't, but we shipped it," it is a release note.

## Feeds are for agents too

Promotion is not only about humans scrolling. Agents read the web now, and they read it best through structured, open surfaces: RSS, OPML, JSON, MCP. A blog with a feed is a blog an agent can subscribe to, summarise and cite.

::: tool
**Tool: RSS Amplifier**

RSS Amplifier is an open, agent-first directory of independent blogs and feeds: the small web, not the platforms. Anyone can submit a feed and anyone can read the directory, with JSON, OPML and plain-text surfaces plus an MCP server, so an agent can search topics, find who writes about something and read the posts directly.

```bash
npm i -g @profullstack/rssamplifier
```

Browse or submit at [rssamplifier.com](https://rssamplifier.com).
:::

Submit your engineering blog's feed. It costs nothing and it puts your posts where agents doing research will find them. Then go the other way: when you need to know how other people solved something, search the small web before you search the platforms. Independent engineers write the most honest post-mortems.

## What a good announcement says

Agents write announcements that sound like press releases unless you tell them otherwise. Give them a template instead. A good post answers four things in this order: what changed, who it is for, how to get it, and where to read more.

```text
sh1pt 1.4.0: `sh1pt openapi diff` now fails the build when a response field disappears.
For anyone shipping a public API with agents in the loop.
npm i -g @profullstack/sh1pt
https://sh1pt.com
```

No adjectives doing the work of facts. No "excited to announce." A version number, a concrete change, an install line and a link. Readers who care will click; readers who do not will scroll past without feeling sold to, which is exactly the reputation you want when you post every week.

## The full loop, one more time

Here is the whole of Part III as one sequence an agent can run:

```bash
# frame: written by the engineer
# fan out
moshcode swarm "implement FRAME.md"
# gate locally
pnpm test && pnpm typecheck && pnpm lint
# merge
gh pr merge --squash --delete-branch
# release
gh release create "v1.4.0" --generate-notes   # sh1pt fans it out to every channel
# verify live
curl -sI https://example.com/new-thing | head -1
# ratchet: add the check that would have caught today's escape
# promote
myna post --to all "new-thing is live: https://example.com/new-thing"
```

Nine phases. Most of them are one command. The engineer's work happens in two places: writing the frame at the top and reading the diff in the middle. Everything else is a loop the fleet runs on its own.

That is what software engineering looks like now. The next part is about what happens when you run that loop across a hundred repositories at once.
