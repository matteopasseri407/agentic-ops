#!/usr/bin/env node
// Generic Claude Code session hook: brief on resume / after-compaction, and remind the
// agent to persist durable state BEFORE context is compacted.
//
// Wire it into ~/.claude/settings.json under BOTH events:
//   "hooks": {
//     "SessionStart": [ { "hooks": [ { "type": "command", "command": "node /abs/path/checkpoint.mjs", "timeout": 5 } ] } ],
//     "PreCompact":   [ { "hooks": [ { "type": "command", "command": "node /abs/path/checkpoint.mjs", "timeout": 5 } ] } ]
//   }
//
// It only injects context; it never writes, never blocks, and exits 0 on any error so it
// can never break a session. The actual save still belongs to the model — this is a nudge.

const chunks = [];
process.stdin.on("data", (c) => chunks.push(c));
process.stdin.on("end", () => {
  let event = {};
  try {
    event = JSON.parse(Buffer.concat(chunks).toString("utf8") || "{}");
  } catch {
    process.exit(0);
  }

  const name = event.hook_event_name || event.hookEventName || "";
  const source = event.source || event.trigger || "";
  let context = "";

  if (name === "SessionStart") {
    // Brief only when context was actually lost; stay silent on a fresh manual start.
    if (source === "resume" || source === "compact") {
      context =
        "[memory briefing] This session resumed or was compacted. Before continuing, " +
        "re-ground in the project's memory layer with one targeted read (entry note, " +
        "current focus, recent activity). Do not reload everything.";
    }
  } else if (name === "PreCompact") {
    context =
      "[memory checkpoint] Context is about to be compacted. If this session produced " +
      "durable knowledge not yet saved (a final diagnosis, root cause, decision, project " +
      "state, reusable runbook, or config change), persist a compressed summary now — no " +
      "raw logs, no secrets — and commit it before the thread is lost.";
  }

  if (context) {
    process.stdout.write(
      JSON.stringify({
        hookSpecificOutput: { hookEventName: name, additionalContext: context },
      })
    );
  }
  process.exit(0);
});
