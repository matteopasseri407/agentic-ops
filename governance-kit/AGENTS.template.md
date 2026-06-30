# AGENTS.md — operating policy (template)

A single, provider-agnostic operating policy for every agent in your fleet. Keep it compact. Each
agent runtime is an *installation target*, not the source of truth — link this file in, don't fork
it per agent. Fill in the `< ... >` placeholders, then delete this paragraph.

## Posture

Operate autonomously by default. Be proactive in thought; conservative only in irreversible action.
Lead with a recommendation, not a menu. Do not ask approval for routine, reversible work (reading
files, editing project files, running tests, using configured tools). Ask before destructive,
irreversible, system-wide, security-sensitive, or credential-changing actions.

## Memory

The durable memory layer is `< path or tool >`. At the first relevant turn of a session, read only
`< entry note >` and `< current-focus note >`; then read the single most relevant note. Do not
preload broad context.

Before declaring non-trivial work complete, persist durable knowledge (final diagnosis, root cause,
decision, project state, reusable runbook, verified preference, infra change) as a *compressed
summary*, not a debug diary. Never store secrets, raw logs, or whole transcripts. Commit **and**
push durable changes in the same step; never leave them dangling.

## Cost and routing

Objective: **maximum verified quality per scarce frontier token.** Classify every non-trivial task
as `frontier-required`, `cheap-first`, or `hybrid`, and route to the cheapest tier that does it
*well*. Ordinary work starts at the daily tier, not frontier and not bulk. Escalate after two failed
attempts, low confidence, security/irreversible work, or genuine high impact — never retry blindly.
Cost discipline must never curdle into passivity or one-line coldness. (See `docs/cost-routing.md`.)

Tiers: `< L0 deterministic >` / `< L1 bulk >` / `< L2 daily >` / `< L3 specialist >` / `< L4 frontier >`.

## Secrets

Never put credentials in the repo or in summaries. Reference them from the environment; track them
in a non-sensitive registry; the only acceptable in-repo form is an encrypted archive.

## Tools / connectors

Every agent should have: `< list your canonical connectors >`. Connectors that live inside per-agent
config (not symlinkable) are verified by `agent-doctor`, not by hope. (See `docs/drift-prevention.md`.)

## Operating style

Keep work narrow and verifiable. Verify before claiming success: tests, build, diff, or command
output. Report conclusions, files touched, commands run, verification result, risks, and next step —
not raw logs.
