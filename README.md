# The Vault 2.0 project

I'm not a pure software engineer, and I don't pitch myself as one. What I do well
is turn messy operations into systems that actually run. Lately that means getting
six AI models, across four CLIs and two machines, to behave like one team instead
of six separate tools. This repo explains how that layer is built, and why it's
shaped the way it is.

## The problem

I run up to eight agents at once, on my own, split between a Linux laptop and a
Windows desktop: Claude Code, Codex, an Antigravity runtime, OpenCode, and a local
fallback model. Getting one of them to work was never the hard part. Keeping all of
them aligned was. Configs drifted between the two machines, the same MCP server got
written four different ways, and the shared memory turned into a fight over who
wrote what.

## The idea

One source of truth for everything, and nothing else gets edited by hand. Behaviour,
tool config, skills, and memory each have a single canonical file in a Git-backed
vault. Whatever lands on a given CLI or machine is generated from that source and
treated as read only. A provisioner regenerates the derivatives on a schedule; when
something needs to change, it changes at the source and propagates everywhere. The
collisions I used to fight all came from editing the copy instead of the source, so
I stopped allowing the copy to be a place you write.

## How it's built

Three planes, because they have different shapes and don't take the same tool:

- behaviour: one operating policy (`AGENTS.md`) linked into every runtime, plus skills;
- config: an abstract MCP manifest compiled into each CLI's own dialect by a small generator;
- memory: a plain-Markdown vault, written through a single serialized path.

```
        Canonical sources (Git, one truth)
        behaviour · MCP manifest · skills · hooks
                        |  generated, read-only
        +---------------+---------------+
     Laptop                          Desktop
     4 CLIs + local model      (same layer, both machines)
                        |  git pull (mirror) · MCP read/write (serialized)
              Private cloud hub: Git bare repo + memory tool server
```

Writes go through one door per kind of thing. Knowledge notes are written only
through the memory tool server, which serializes with a lock and an expected-hash
check, so two agents can't clobber each other. Infrastructure files go through a
separate publish step with a clean rebase and a hard stop on real conflicts. What
used to cause the fights was a second, silent path: a filesystem watchdog that
auto-committed every minute. I removed it. One door per kind of write.

The long version, with the reasoning behind each decision, is in the vault case
study: [agentic knowledge vault (MCP)](case-studies/agentic-knowledge-vault-mcp.md).

## Shared tools

The agents share more than memory. A few services run once, and every agent reaches
them the same way over MCP instead of each one wiring its own:

- Semantic search over the vault: a self-hosted retrieval layer (static embeddings
  via model2vec, plus BM25 and a title boost, with rank fusion) running CPU-only on a
  private VPS. The knowledge base stays searchable by meaning without sending anything
  to a cloud model, and the agents query it as a tool.
- Scraping and web search: a self-hosted Firecrawl instance, reached over a private
  tunnel, as the default read-only lane. Off-machine, no local browser, nothing
  authenticated.
- A shared browser: for anything interactive, a form, a login, checking a page, the
  agents attach to my real, visible Chrome over the DevTools protocol and work in the
  window I can see. Never headless behind my back. State-changing browser work is
  something we do together, not something an agent does quietly and reports afterward.

## Governance (the part worth stealing)

The storage isn't the interesting bit. The rules that keep a fleet of agents cheap
and honest are.

- Cost routing: each task goes to the cheapest tier that can do it well, and frontier
  models are kept for ambiguity, architecture, security, and anything irreversible.
  Routing is by task, not "start cheap and fail upward."
- Assert-or-it-drifts: any rule that structure can't enforce gets an automated check,
  or it's just prose you hope gets followed. The rule that taught me this is the browser
  one above, "attach to the shared visible Chrome, never headless." Two agents ignored it
  and ran headless for weeks because nothing checked the flag. Now a health check parses
  the actual config and fails if any agent is set up to run hidden.
- Mechanical checkpoints: a session hook re-grounds an agent when it resumes and nudges
  it to save what it learned before the context is compressed, so a root cause doesn't
  vanish with the session.

Details: [`docs/architecture.md`](docs/architecture.md) ·
[`docs/cost-routing.md`](docs/cost-routing.md) ·
[`docs/drift-prevention.md`](docs/drift-prevention.md)

## What's runnable

`governance-kit/` holds the generic, runnable pieces: a structural health check
(`agent-doctor`) that parses the real config keys instead of grepping text, an
operating-policy template, and the session checkpoint hook. No secrets, no
infrastructure, nothing tied to my deployment.

## What I deliberately didn't build

I didn't write a memory engine. Markdown, Git, and a tool server already give durable,
auditable memory that humans and agents can both read, and off-the-shelf projects do
storage and retrieval well. There's no per-user identity, no agent-to-agent review, no
CRDT or second database. It's one person, so that machinery would be cost with no
payback. The effort went into the layer above storage, which is the part actually
worth writing down.

## Related proof

- [n8n Lead Qualifier](https://github.com/matteopasseri407/n8n-demo): a 65-node workflow
  for B2B intake, LLM scoring, and CRM handoff with fallback and recovery paths.
- [HP EliteBook Ryzen tuning](https://github.com/matteopasseri407/hp-elitebook-845-g8-ryzen-tuning):
  a public Linux tool with code, CI, releases, and Fedora packaging, where you can read
  the source, not just a description of it.

## Operations case studies

The same systems thinking applied to business operations, sanitized:

- [Self-hosted n8n automation layer](case-studies/self-hosted-n8n-automation-layer.md)
- [Custom 3D-printing ERP](case-studies/custom-3d-printing-erp.md)
- [AI-assisted lead qualification funnel](case-studies/ai-enabled-ops-funnel.md)
- [3D services website](case-studies/3d-services-website.md)

## How I share proof

The real deployment stays private: hostnames, tunnels, tokens, container layout, and any
operational content never go in a repo. What's public is the pattern and clean, generic
implementations of it. See [`SANITIZATION-CHECKLIST.md`](SANITIZATION-CHECKLIST.md).

## Sintesi in italiano

Come faccio comportare sei modelli AI, su quattro CLI e due macchine, come un sistema
solo. Una fonte di verità per ogni cosa nel vault Git, il resto è generato e in sola
lettura: cambi la fonte e si propaga ovunque, invece di mettere mano a mano su ogni
copia. Tre piani separati (comportamento, config MCP, memoria) e una sola porta di
scrittura per tipo. Gli agenti condividono anche i tool via MCP: ricerca semantica
self-hosted sul vault (model2vec più BM25, CPU-only), Firecrawl self-hosted per lo
scraping read-only, e il browser Chrome reale e visibile via DevTools, mai headless di
nascosto. Sopra ci sta la governance che conta: routing per costo, controlli automatici
al posto delle regole sperate, checkpoint di sessione. Non ho costruito un memory engine
né un database: è solo Matteo, il valore è nel layer di regole sopra lo storage. Il
deployment reale resta privato, qui c'è il metodo.

## Contact

- LinkedIn: [matteo-passeri-me3d](https://linkedin.com/in/matteo-passeri-me3d)
- Email: matteo.passeri.407@outlook.it
