# Architecture (the shape, not the secrets)

A deliberately generic view of how the pieces fit. Specific hosts, addresses, paths,
and credentials are left out on purpose. They belong to a private deployment, not to a
public description of the pattern.

```
                       +-----------------------------+
                       |   Canonical memory (Git)    |
                       |   plain Markdown, one truth |
                       +--------------+--------------+
                                      |
                        +-------------+-------------+
                        |      Tool server (MCP)    |
                        |  read/write (trusted) +   |
                        |  read-only (public) ends  |
                        +-------------+-------------+
                                      |  every write is a Git commit
        +---------------+------------+------------+---------------+
        |               |            |            |               |
   +----+---+      +----+---+   +----+---+   +----+----+    +------+-----+
   | Agent A|      | Agent B|   | Agent C|   | Agent D |    | local model|
   |frontier|      | daily  |   | daily  |   | creative|    | fallback   |
   +--------+      +--------+   +--------+   +---------+    +------------+
        +------------ one shared operating policy (AGENTS.md) ----------+
                      one shared health check (agent-doctor)
```

## Principles

- One canonical source. Memory is plain Markdown under Git, not a database, not a
  vendor format, not a knowledge graph. Plain text that both humans and agents can
  read, with a full commit-by-commit audit trail.
- Storage is commodity, governance is not. The storage, retrieval, and sync layer is
  intentionally boring and replaceable. The differentiated part is the operating policy
  and the checks on top.
- Provider-agnostic policy. One operating policy is the canonical source, and each agent
  runtime is an installation target, not the source of truth. A new agent means linking
  the policy, registering the connectors, and running the health check.
- Cheap by default, frontier on purpose. Routing and a budget gate keep ordinary work on
  cheap tiers and reserve frontier models for where they change the outcome. See
  [cost-routing.md](cost-routing.md).
- Mechanical, not hopeful. Any rule that structure can't enforce gets an automated
  assert. See [drift-prevention.md](drift-prevention.md).
- Secrets never live in the repo. Credentials are referenced from the environment and
  tracked in a non-sensitive registry. The only acceptable in-repo form is an encrypted
  archive.

## What this description leaves out on purpose

Hostnames, IPs, tunnels, container topology, token flows, exact provider and plan
choices, and any operational content. The pattern is the part that transfers. The
deployment is not, and publishing it would be a liability with no upside.
