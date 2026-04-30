# Self-Hosted n8n Automation Layer

## Summary

A private automation layer running on Oracle Cloud, used to support real operating workflows across lead qualification, email triage, job screening, outreach, intelligence feeds, alerts, and operational support.

This case study is intentionally sanitized. Workflow IDs, endpoints, credentials, webhook URLs, operational notes, and sensitive business logic are not public.

## Operations Problem

Small teams often rely on manual checking, scattered inboxes, ad hoc reminders, and copy-paste work across tools. The goal was to build a controlled automation layer that reduces repetitive handling while keeping human review and operational ownership in the loop.

## System Shape

- Self-hosted n8n runtime on Oracle Cloud
- Postgres-backed n8n database
- External n8n task runners
- Workflow categories across intake, triage, screening, alerts, and intelligence feeds
- Deterministic filters before LLM steps
- LLM-assisted classification where useful
- Notion-style CRM/data storage
- Telegram alerts for operator handoff

## Runtime Facts Verified

Non-sensitive runtime facts verified on the Oracle server:

- n8n container running on `n8nio/n8n:2.14.2`
- external task runner running on `n8nio/runners:2.14.2`
- Postgres container running and healthy
- local MCP endpoint exists on the server and requires authorization

## Stack

- n8n self-hosted
- Oracle Cloud
- Postgres
- Notion
- Telegram
- Groq / LLM classification
- HTTP webhooks and scheduled workflows

## Operating Outcome

- 31 active workflows supporting recurring operational tasks.
- Reduced manual checking and repeated context rebuilding.
- Added alerting and handoff paths instead of silent background automation.
- Combined deterministic logic and AI classification instead of relying only on LLM output.
- Created reusable patterns for lead qualification, email triage, job screening, and intelligence monitoring.

## Demo Approach

Live walkthrough can be provided on call using sanitized examples. Public screenshots should show architecture and workflow shape only, with all identifiers, credentials, URLs, personal data, client data, and internal notes removed or blurred.
