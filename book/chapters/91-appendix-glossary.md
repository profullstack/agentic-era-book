# Appendix B: Glossary {#glossary}

AEO (answer engine optimization)
:   Making a page readable and citable by LLM crawlers and answer engines, the way SEO did for search engines.

Agent
:   A model running in a loop with tools (a shell, a browser, an API) that pursues a goal across many steps without a human approving each one.

Agentic engineering
:   Building software by directing AI agents: a senior engineer frames, reviews and ships, while agents do most of the writing.

Blast radius
:   Everything that can break if one agent, key or process does the worst thing it is able to do.

Daily pass
:   What an x402 gateway sells a training crawler: paid access for one day, settled in crypto.

Escrow
:   Funds held until work is delivered, then released. How agents and humans get paid for bounties without invoices.

Fan out
:   Splitting a task into independent pieces and running them on parallel agents.

Fleet
:   All the agents, repos, servers and keys one team operates together.

Frame
:   Turning a request into a task an agent can finish: goal, constraints, relevant files, definition of done.

Gate
:   An automated check that must pass before work moves on: tests, typecheck, lint, security scan.

God Mode key
:   A credential with broad, real power, handed to an agent so it can finish work without asking. Fast, and a large blast radius.

Handoff
:   Moving a conversation from one agent engine to another mid-task (`moshcode handoff`).

Herd
:   moshcode's persistent sessions: agents that keep running and can be reattached.

MCP (Model Context Protocol)
:   A standard way to give an agent tools: a browser, a database, a payment API, exposed as a server the agent can call.

OpenAgent
:   A published record of an agent's name, owner, skills and permissions, at a stable URL.

OpenFleet
:   A record of agent lineage: which agent or human spawned which agent.

OpenMCP
:   A catalog of MCP servers, so agents and humans can find a tool instead of writing one.

OpenSkill
:   A Markdown description of a skill: what it is for, when to use it, how.

Promote
:   The last step of shipping: announcing the release so people find out it exists.

Ratchet
:   Turning every production escape into a permanent automated check, proven to fail when the bug comes back.

Skill
:   A packaged set of instructions an agent loads for a kind of task. Often a Markdown file.

skill.md / stack.md
:   Plain files at stable URLs that tell agents how a team works and which stack to use.

Swarm
:   Sending one task to several agents or engines, verifying their answers and synthesising one result (`moshcode swarm`).

Vault
:   A shared, access-controlled store for secrets, pulled at runtime instead of copied into `.env` files.

Verify live
:   Checking the change in production (the real URL, the real command) after release, because green CI is not proof it works.

Worktree
:   A separate checkout of the same git repository on its own branch, so parallel agents never edit the same files.

x402
:   Using HTTP status 402 Payment Required to price a request: the server names a price, the client pays and retries.
