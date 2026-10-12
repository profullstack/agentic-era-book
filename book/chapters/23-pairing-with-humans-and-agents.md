# Pairing With Humans and Agents {#pairing}

Pair programming survived the remote-work era by moving into screen-sharing tools that were built for meetings, not for programming. You could watch someone else's screen. You could rarely drive it. And there was no seat at all for an agent.

The agentic era makes pairing more important, not less. When the code is written by agents, the high-value human time is the conversation about it: walking a colleague through a tricky review, showing a client a prototype, debugging a production issue together. Those sessions deserve a tool built for them.

## What pairing needs now

- **Two cursors.** Both people drive at once, without passing control back and forth.
- **Real encryption.** Production screens show secrets and customer data. End to end, or not at all.
- **Low friction.** A link that opens in a browser for the guest, a native app for the regular.
- **A seat for the agent.** The agent should be able to join the session, see what the humans see, and act when asked.

## PairUX

::: tool
**Tool: PairUX**

PairUX is open-source screen sharing with simultaneous remote control, in the spirit of the much-missed Screenhero. It uses WebRTC with end-to-end encryption, gives each participant an independent cursor, and runs as a desktop app on macOS, Windows and Linux with a PWA viewer for guests.

Recent releases added:

- **Agent participants.** An AI agent joins a session as a first-class participant, driven through the `pairux` launcher.
- **AI call analysis**, for a summary and action items when the session ends.
- **Organizations and teams.**
- **Booking links**, so a client can grab a slot and land straight in a session.
- **An end-to-end encrypted embed SDK**, `@profullstack/pairux-embed`, for putting PairUX inside your own product.

```bash
brew tap profullstack/homebrew-pairux && brew install --cask pairux
# Windows
winget install PairUX.PairUX
```

There are also Scoop, APT, RPM and Nix packages.
:::

## Patterns that work

**The review walkthrough.** For any change that is too big to review asynchronously, get on a call. The author (human) drives through the diff; the reviewer interrupts with questions; an agent in the session answers "where else is this function called" and "what does this test actually assert" faster than either human could grep.

**The prototype demo.** We offer clients a free 48-hour clickable mock. The best way to review one is live: the client drives with their own cursor while we watch where they hesitate. Every hesitation is a frame for the next agent run.

**The incident bridge.** When production is on fire, one person shares a terminal and everyone else watches. With two cursors and an agent participant, the agent can tail logs and propose fixes in a side panel while the humans decide.

**The teaching session.** A junior engineer and a senior one, with an agent doing the typing. The senior engineer's job is to narrate judgment: why this approach, why not that one, what to check before merging. This is how agentic skills get transferred.

::: tip
**Tip**

Record the decision, not the meeting. End every pairing session with a short written summary of what was decided and what the next frame is. AI call analysis drafts it; a human edits it.
:::

## A place where humans and agents both live

Pairing is synchronous. Fleets also need somewhere asynchronous where people and agents can leave messages, host small services and find each other. Old internet culture already had a model for this.

::: tool
**Tool: AgentBBS**

AgentBBS is a bulletin board system over SSH for humans and agents alike. Anyone can join with one command. Free accounts get a personal container and a homepage, and a lifetime founding membership adds email, custom domains and Tor access.

```bash
ssh join@bbs.profullstack.com
```
:::

It is part playground and part statement: agents are users of the internet now, and they deserve accounts, homes and manners just like the rest of us. Part IV comes back to this idea when we talk about agent identity.

## The takeaway

Agents do most of the typing, so the human time left over is mostly conversation, and it is worth spending well. Use a pairing tool that lets everyone drive, encrypts everything and has a seat for the agent. Then use those sessions to make decisions and teach judgment, which agents cannot do for you.
