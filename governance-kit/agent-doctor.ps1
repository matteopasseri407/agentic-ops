#!/usr/bin/env pwsh
# agent-doctor - structural alignment check for a multi-agent setup.
#
# Reads a manifest (agents.json in the cwd, else agents.example.json next to this script) and
# verifies, per agent, that the expected MCP connectors are ACTUALLY configured - parsed from the
# config's STRUCTURE (the mcpServers/mcp object keys, the [mcp_servers.*] sections), not grepped
# from raw text. A naive whole-file grep gives false passes when a name appears in logs/comments.
#
# Exits non-zero on any FAIL, so it can gate CI or a pre-commit hook.
#   pwsh agent-doctor.ps1            full report
#   pwsh agent-doctor.ps1 -Summary   one-line summary

[CmdletBinding()]
param([string]$Manifest, [switch]$Summary)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Manifest) {
  $cwdManifest = Join-Path (Get-Location) "agents.json"
  $Manifest = if (Test-Path -LiteralPath $cwdManifest) { $cwdManifest } else { Join-Path $root "agents.example.json" }
}

$script:PASS = 0; $script:WARN = 0; $script:FAILN = 0; $script:FAILS = @()
function ok($m)   { $script:PASS++;  if (-not $Summary) { Write-Host "  [OK]   $m" -ForegroundColor Green } }
function warn($m) { $script:WARN++;  if (-not $Summary) { Write-Host "  [WARN] $m" -ForegroundColor Yellow } }
function bad($m)  { $script:FAILN++; $script:FAILS += $m; if (-not $Summary) { Write-Host "  [FAIL] $m" -ForegroundColor Red } }
function expand($p) { if ($p -like "~*") { Join-Path $HOME ($p.Substring(1).TrimStart('/', '\')) } else { $p } }

if (-not (Test-Path -LiteralPath $Manifest)) { Write-Error "manifest not found: $Manifest"; exit 2 }
$cfg = Get-Content -Raw -LiteralPath $Manifest | ConvertFrom-Json
if (-not $Summary) { Write-Host "=== agent-doctor: $Manifest ===" -ForegroundColor White }

# 1. policy file present
if ($cfg.instructions_file) {
  $inst = expand $cfg.instructions_file
  if (Test-Path -LiteralPath $inst) { ok "policy file present: $($cfg.instructions_file)" }
  else { bad "policy file missing: $($cfg.instructions_file)" }
}

# 2. required env vars
foreach ($v in @($cfg.required_env)) {
  if (-not $v) { continue }
  if ([Environment]::GetEnvironmentVariable($v)) { ok "env $v present" } else { bad "env $v missing" }
}

# 3. per-agent connectors (STRUCTURAL)
foreach ($a in @($cfg.agents)) {
  $f = expand $a.config
  if (-not (Test-Path -LiteralPath $f)) { warn "$($a.name): config absent ($($a.config))"; continue }
  $keys = @()
  try {
    if ($a.format -eq "toml") {
      $keys = @([regex]::Matches((Get-Content -Raw -LiteralPath $f), "(?m)^\[mcp_servers\.([^\]]+)\]") | ForEach-Object { $_.Groups[1].Value })
    }
    else {
      $obj = Get-Content -Raw -LiteralPath $f | ConvertFrom-Json
      $node = if ($a.mcp_path) { $obj.($a.mcp_path) } else { $obj.mcpServers }
      if ($node) { $keys = @($node.PSObject.Properties.Name) }
    }
  }
  catch { bad "$($a.name): config unreadable/invalid"; continue }
  $miss = @(); foreach ($s in @($a.expected_mcp)) { if (-not ($keys | Where-Object { $_ -like "*$s*" })) { $miss += $s } }
  if ($miss.Count -eq 0) { ok "$($a.name): expected connectors configured ($($keys.Count) found)" }
  else { bad "$($a.name): connectors NOT configured: $($miss -join ', ')" }
}

if ($Summary) {
  $line = "agent-doctor PASS=$($script:PASS) WARN=$($script:WARN) FAIL=$($script:FAILN)"
  if ($script:FAILN -gt 0) { $line += " | FAIL: " + ($script:FAILS -join '; ') }
  Write-Output $line
}
else {
  Write-Host ""
  Write-Host ("  PASS={0}  WARN={1}  FAIL={2}" -f $script:PASS, $script:WARN, $script:FAILN)
}
if ($script:FAILN -eq 0) { exit 0 } else { exit 1 }
