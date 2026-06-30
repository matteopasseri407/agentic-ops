# Cost routing

Objective: maximum verified quality per scarce frontier token. Don't ship mediocre work
to save money, and don't burn frontier budget on work a cheaper tier can do safely.

Running several models without a routing rule has two failure modes. Put everything on
frontier and you go broke. Put everything on cheap and quality collapses where it
matters. The fix is to make routing an explicit, repeatable decision.

## Tiers

A practical tier ladder. The exact models are yours to choose; the shape is what
transfers.

| Tier | Use for |
|---|---|
| L0 deterministic | Shell, search, formatters, tests, static checks. No model at all when a command will do. |
| L1 bulk | Extraction, classification, summarization, log and file scans, mechanical transforms, throwaway drafts. |
| L2 daily | Normal reversible coding, repo analysis, medium debugging, first-pass patches. |
| L3 specialist | Long-context, multimodal, or domain tasks a daily model handles poorly. |
| L4 frontier | Architecture, final judgment, security and secrets, taste, hard debugging, irreversible edits. |

Day-to-day rule: ordinary work starts at L2, not at L4 and not at L1. L1 is bulk only.
L4 is reserved.

## The budget gate

Before any non-trivial task, classify it:

- `frontier-required`: high ambiguity or impact, security, auth, secrets, architecture,
  critical behavior, risky third-party fixes, UI and design quality, or irreversible
  actions.
- `cheap-first`: scans, logs, inventory, extraction, summarization, config inspection,
  repetitive transforms, first-pass diagnosis, mechanical refactors.
- `hybrid`: a cheap tier gathers evidence or drafts a patch, then frontier reviews risk,
  architecture, and final acceptance.

## Escalation, not blind retry

Escalate a tier after two failed attempts at the same level, low-confidence output,
anything touching secrets or irreversible state, UI and design taste, or a genuinely
high-impact edit. Don't retry blindly at a cheap tier to dodge paying for frontier; that
wastes more than it saves.

## The counter-rule

Cost discipline is a means, not the goal. It must never turn into passivity, refusal to
take initiative, or one-line coldness on work that deserves real engagement. A cheap
agent that does the wrong thing cheaply is the most expensive outcome of all. Route for
quality per token, not for the lowest token count.
