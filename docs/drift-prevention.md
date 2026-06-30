# Drift prevention: assert-or-it-drifts

A rule that structure can't enforce needs an automated assert, or it's just prose you
hope gets followed.

## Why prose rots

In a multi-agent setup, a lot of configuration can be made canonical and self-healing:
a shared policy file linked into each runtime, generated config, deduplicated skills.
Structure enforces those, and if they drift, the next sync repairs them.

But some rules live as arguments inside each agent's own config, and those can't be
linked. For example: the browser connector must attach to a shared debugging endpoint
and must never run headless. There's no symlink that guarantees it. It lives as flags
inside four different config files, in three different formats.

Rules like that, written only as prose, drift quietly. The incident that named this rule:
two agents ran headless for weeks because nothing checked the flag. The policy existed,
but only as a sentence someone hoped would be honored.

## The rule

Every operating rule that structure doesn't enforce needs an automated assertion in a
health check. If you can't link it, you assert it. No exceptions for "it's obviously
followed," because obvious-but-unchecked is exactly how things drift.

## The subtler trap: check structure, not text

A first health check can pass for the wrong reason. A naive check that greps the whole
config file for a connector's name reports it present if the name appears anywhere,
including in a log or a comment, even when the connector isn't actually configured. That
false pass hides a real gap. The fix is to read structure: parse the config and inspect
the actual keys (the `mcpServers` or `mcp` object, the `[mcp_servers.*]` sections), not
the raw text. `agent-doctor` in this kit does exactly that.

## Make it cheap to run, and run it

- A health check is only useful if it runs. Make it one command with a one-line summary
  and a non-zero exit on any failure.
- Wire it into a periodic sync, a pre-commit hook, or CI.
- Alert only on a new or persisting failure, never on a routine green report, which just
  trains people to ignore it.

## The general move

This is the same principle as tiered routing and session checkpoints: take something you'd
otherwise just hope holds, and make it mechanical. A symlink where you can, an assert
where you can't.
