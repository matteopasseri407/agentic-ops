#!/usr/bin/env bash
# agent-doctor - structural alignment check for a multi-agent setup.
#
# Reads a manifest (agents.json in the cwd, else agents.example.json next to this script) and
# verifies, per agent, that the expected MCP connectors are ACTUALLY configured - parsed from the
# config's STRUCTURE (mcpServers/mcp object keys, [mcp_servers.*] sections), not grepped from raw
# text. A naive whole-file grep gives false passes when a name appears in logs/comments.
#
# Needs jq for JSON configs. Exits non-zero on any FAIL, so it can gate CI or a pre-commit hook.
#   bash agent-doctor.sh             full report
#   bash agent-doctor.sh --summary   one-line summary
set -u

SUMMARY=0; [ "${1:-}" = "--summary" ] && SUMMARY=1
ROOT="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="${MANIFEST:-}"
if [ -z "$MANIFEST" ]; then
  if [ -f "./agents.json" ]; then MANIFEST="./agents.json"; else MANIFEST="$ROOT/agents.example.json"; fi
fi

command -v jq >/dev/null 2>&1 || { echo "agent-doctor needs jq"; exit 2; }
[ -f "$MANIFEST" ] || { echo "manifest not found: $MANIFEST"; exit 2; }

PASS=0; WARN=0; FAILN=0; FAILS=""
ok()   { PASS=$((PASS+1));  [ "$SUMMARY" = 1 ] || printf '  \033[32m[OK]\033[0m   %s\n' "$1"; }
warn() { WARN=$((WARN+1));  [ "$SUMMARY" = 1 ] || printf '  \033[33m[WARN]\033[0m %s\n' "$1"; }
bad()  { FAILN=$((FAILN+1)); FAILS="$FAILS; $1"; [ "$SUMMARY" = 1 ] || printf '  \033[31m[FAIL]\033[0m %s\n' "$1"; }
expand() { case "$1" in "~"*) printf '%s' "$HOME${1#\~}";; *) printf '%s' "$1";; esac; }

[ "$SUMMARY" = 1 ] || echo "=== agent-doctor: $MANIFEST ==="

# 1. policy file present
inst=$(jq -r '.instructions_file // empty' "$MANIFEST")
if [ -n "$inst" ]; then
  ip=$(expand "$inst")
  [ -f "$ip" ] && ok "policy file present: $inst" || bad "policy file missing: $inst"
fi

# 2. required env vars
while IFS= read -r v; do
  [ -z "$v" ] && continue
  [ -n "$(printenv "$v" 2>/dev/null)" ] && ok "env $v present" || bad "env $v missing"
done < <(jq -r '.required_env[]? // empty' "$MANIFEST")

# 3. per-agent connectors (STRUCTURAL)
n=$(jq '.agents | length' "$MANIFEST")
i=0
while [ "$i" -lt "$n" ]; do
  name=$(jq -r ".agents[$i].name" "$MANIFEST")
  conf=$(jq -r ".agents[$i].config" "$MANIFEST")
  fmt=$(jq -r ".agents[$i].format // \"json\"" "$MANIFEST")
  mpath=$(jq -r ".agents[$i].mcp_path // \"mcpServers\"" "$MANIFEST")
  f=$(expand "$conf")
  if [ ! -f "$f" ]; then warn "$name: config absent ($conf)"; i=$((i+1)); continue; fi
  if [ "$fmt" = "toml" ]; then
    keys=$(grep -oE '^\[mcp_servers\.[^]]+\]' "$f" 2>/dev/null)
  else
    keys=$(jq -r "(.$mpath // {}) | keys[]" "$f" 2>/dev/null)
  fi
  miss=""
  while IFS= read -r s; do
    [ -z "$s" ] && continue
    printf '%s\n' "$keys" | grep -q "$s" || miss="$miss $s"
  done < <(jq -r ".agents[$i].expected_mcp[]? // empty" "$MANIFEST")
  [ -z "$miss" ] && ok "$name: expected connectors configured" || bad "$name: connectors NOT configured:$miss"
  i=$((i+1))
done

if [ "$SUMMARY" = 1 ]; then
  line="agent-doctor PASS=$PASS WARN=$WARN FAIL=$FAILN"
  [ "$FAILN" -gt 0 ] && line="$line | FAIL:$FAILS"
  printf '%s\n' "$line"
else
  printf '\n  PASS=%s  WARN=%s  FAIL=%s\n' "$PASS" "$WARN" "$FAILN"
fi
[ "$FAILN" -eq 0 ]
