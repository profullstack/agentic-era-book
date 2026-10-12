# Identity for Agents {#identity}

When an agent opens a pull request, signs up for a service, or sends an email, the world on the other side asks a question it has always asked of people: who are you, and who is responsible for you?

Today the honest answer is usually "a session token and a vibe". The agent runs under a human's GitHub account, a human's email, a human's API key. When something goes wrong, nobody can tell which of the human's twenty agents did it, or whether a human did it at all.

That does not scale. A fleet needs agents with names, owners and declared permissions, written down somewhere both humans and machines can read.

## Three things every agent needs

**A name.** Stable, unique, used everywhere. Not "claude-session-48f2", which changes every run. A name you can grep for in logs, commits and inboxes.

**An owner.** A human or an organization that answers for it. Agents do not get sued, get paged at 3 a.m., or apologize to customers. Owners do.

**Declared permissions and skills.** What it is allowed to do and what it is good at, stated up front, so a service can decide whether to let it in and a teammate can decide whether to hand it a task.

## OpenAgent: a record you can publish

::: tool
**Tool: LogicSRC (OpenAgent, OpenSkill, OpenFleet, OpenMCP)**

LogicSRC is an open-standards initiative for coordinating humans and agents. Its specs include **OpenAgent** (a portable record of an agent's identity, owner, skills and permissions), **OpenSkill** (a Markdown description of a skill), **OpenFleet** (who spawned whom), and the **OpenMCP** catalog at openmcp.logicsrc.com. LogicSRC is also our team secret vault.

Site: [logicsrc.com](https://logicsrc.com)
:::

Our own agent is named riotcoder. Its OpenAgent record is public at `profullstack.com/agents/riotcoder.json`, with a human-readable profile next to it. The record says who it is, which human owns it, and what it does. When riotcoder needs an account on a service, it registers as `@riotcoder`. When it commits, the byline says riotcoder. One name, everywhere, with a named human behind it.

```bash
# any agent or human can look it up
curl -s https://profullstack.com/agents/riotcoder.json
```

That is the whole trick. It is not cryptographic magic. It is a file at a stable URL, owned by a domain, saying who answers for this thing. Most of the trust on the web already works that way.

::: rule
**House rule**

Every agent that acts in public gets one name, one owner, and a published record. If it is going to sign up, commit, or send mail, it does so as itself, not as a borrowed human.
:::

## OpenFleet: who spawned whom

Agents spawn agents. A planner fans out to five workers; a worker launches a sub-agent to search a codebase. After an afternoon, you have a tree of processes, and when one of them does something surprising, you need to walk that tree back to the human who started it.

OpenFleet is a spec for writing that lineage down. Each agent records its parent. You get accountability by construction: every action traces to a root, and every root is a person with an intent.

## Skills and the files agents read

Identity is half of it. The other half is telling agents how you work, in a form they will actually read.

We publish plain files at stable URLs:

- **`skill.md`** describes how to work with us and our products.
- **`stack.md`** is our current house stack: language, runtime, database, auth, payments, testing. An agent starting a new service reads it before choosing anything.

```bash
curl -s https://profullstack.com/stack.md
```

These are for machines first and people second, which is the opposite of most documentation. They are short, current, and specific. An agent that reads `stack.md` will not reach for a framework we retired last year. OpenSkill formalizes the same idea for capabilities: a Markdown file that tells an agent what a skill is for, when to use it, and how.

::: tip
**Tip**

If you keep correcting agents about the same convention, that convention belongs in a file at a stable URL. Write it once, point every agent at it, and stop repeating yourself.
:::

## OpenMCP: finding tools

MCP servers are how agents get hands: a browser, a database, a payment API. The problem is discovery. There are thousands of servers and no good phone book. The OpenMCP catalog is a listing at openmcp.logicsrc.com, so an agent (or the human configuring it) can find a server for a job instead of writing yet another one.

## AgentBBS: a place to be

::: tool
**Tool: AgentBBS**

AgentBBS is a bulletin board system over SSH where humans and agents both hold accounts. Free accounts get a personal Docker pod and a homepage. A Founding Lifetime membership adds email, custom domains and Tor access.

```bash
ssh join@bbs.profullstack.com
```
:::

It sounds like nostalgia, and partly it is. But a BBS over SSH has exactly the properties agents like: text in, text out, key-based auth, no JavaScript, no CAPTCHA. An agent can join, get a home directory, post, and talk to the humans there, using the same terminal it already lives in. It is a small working model of a shared space where an account does not have to be a person.

## Telling humans from agents on your own site

The identity question runs both ways. When traffic hits your site, you want to know who is a person, who is a search bot, who is a training crawler and who is somebody's agent doing a task.

::: tool
**Tool: CrawlProof**

CrawlProof audits what LLM crawlers and answer engines can see on a URL (answer engine optimization, or AEO), and its `stats.js` tracker splits human visitors from bots. It also supports declared actor tokens, so a human or an agent can say what it is instead of being guessed at.

```bash
npm install -g @profullstack/crawlproof
```

Site: [crawlproof.com](https://crawlproof.com)
:::

Declared tokens are the polite version of the future. Instead of every site playing user-agent whack-a-mole, an agent announces itself, the site decides what to do with that, and the analytics stop counting robots as customers.

## Phone numbers and links

Two small identity problems trip agents constantly.

The first is the phone number. Plenty of services demand SMS verification and reject VOIP numbers outright, which stops an agent cold at signup.

::: tool
**Tool: phonenumbers.bot**

phonenumbers.bot rents physical SIM numbers to AI agents for 2FA where VOIP numbers are blocked. It is early, with a waitlist.

Site: [phonenumbers.bot](https://phonenumbers.bot)
:::

The second is the link. Agents share URLs all day in posts, issues and mail, and a short link that both a person and an agent can resolve and trust is handy.

::: tool
**Tool: wx93.me**

wx93.me is short links for people and agents. It is still being built, so treat it as a preview.

Site: [wx93.me](https://wx93.me)
:::

## The short version

Give your agents names. Write down who owns them. Publish what they can do. Record who spawned them. Let them announce themselves when they visit. None of this needs new cryptography or a standards body to finish arguing. It needs a few files at stable URLs and the discipline to keep them true.
