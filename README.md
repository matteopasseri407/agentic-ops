# Matteo Passeri - Operations Systems Portfolio

Sanitized case studies for operations systems, CRM workflows, ERP transition, quote-to-cash visibility, n8n automation, AI agent orchestration (MCP), and AI-assisted implementation.

I build practical operating systems for small teams: lead intake, qualification workflows, quoting, pipeline visibility, reporting, alerting, SOPs, and handoff documentation.

The real source repositories remain private to protect client data, business logic, workflow exports, credentials, endpoints, and operational details. This repository is the public proof layer: outcomes, architecture summaries, and sanitized case studies.

Open to **full-remote EU roles** in Operations, Implementation, CRM / Workflow Automation, Marketing Ops, Growth Ops-adjacent work, and AI Workflow operations.

## Nota per recruiter italiani

Questo repository è una vetrina sanificata: mostra problemi risolti, architetture logiche, risultati operativi e metodo di lavoro senza esporre sorgenti privati, dati cliente, endpoint, workflow n8n grezzi o credenziali.

Il profilo è tecnico-operativo: operations, ERP/CRM, workflow automation, sistemi interni, documentazione e AI applicata ai processi. Non è pensato per presentarmi come developer puro, ma come una persona capace di trasformare problemi operativi in sistemi funzionanti usando anche AI-assisted execution.

## How To Read This Portfolio

| Signal | Where to look | What it proves |
| --- | --- | --- |
| 65-node AI workflow orchestration | [n8n Lead Qualifier demo](https://github.com/matteopasseri407/n8n-demo) | End-to-end lead intake, LLM scoring, CRM updates, alerts, booking lifecycle, fallback handling, and recovery |
| Sanitized operations systems | Case studies in this repository | System thinking, process ownership, handoff design, safe public documentation |
| Public technical source | [HP EliteBook Ryzen Tuning](https://github.com/matteopasseri407/hp-elitebook-845-g8-ryzen-tuning) | Linux/systemd/udev automation, CI, releases, packaging discipline |
| Multi-agent orchestration | OpsVault case study | AI-agent orchestration, tiered routing, escalation protocols, Git-backed command layer and persistent memory |
| Live business-facing work | [ME3Design](https://me3design.it) | Ability to connect public-facing experiences with private operational workflows |

## Focus Areas

- Multi-Agent Orchestration: tiered routing, escalation protocols, handoff automation
- Model Context Protocol (MCP) & Cross-Agent Context Engineering
- AI Agent Tiering & Quality-Cost Governance
- Git-backed, event-driven Personal Knowledge Management (PKM) systems
- Hybrid semantic retrieval (RAG): self-hosted embeddings + BM25 + rank fusion over a private knowledge base, CPU-only and privacy-preserving
- Lead lifecycle management: intake, qualification, scoring, routing
- CRM-style handoff: structured fields, alerts, status tracking, fallback paths
- Quote-to-cash visibility: clients, quotes, work logs, delivery, P&L
- ERP transition and process standardization
- n8n automation and operational alerting
- Pipeline reporting and dashboard foundations
- SQL fundamentals and data hygiene
- Documentation, SOPs, and operational handoff

## Selected Systems

### n8n Lead Qualifier - 65-Node AI Workflow

A self-hosted n8n workflow for B2B lead intake and qualification. It combines deterministic pre-filtering, duplicate detection, homepage/social enrichment, Groq LLM scoring, Notion CRM updates, Calendly booking/cancellation handling, Telegram alerts, fallback paths, and abandoned-form recovery.

Public demo: [matteopasseri407/n8n-demo](https://github.com/matteopasseri407/n8n-demo)

### Multi-Agent Orchestration Architecture (OpsVault)

A working architecture that coordinates AI agents across capability tiers (L0-L4), runtime environments, and devices. A single Git-versioned bootstrap governs every agent: routing rules, escalation triggers, delegation templates, and quality-cost guardrails. MCP endpoints expose the knowledge base with tiered access controls. It now includes a self-hosted hybrid semantic retrieval layer (RAG): CPU-only embeddings + BM25 + rank fusion, served to agents through MCP. In daily use — not a blueprint, but the operating layer through which all AI-assisted work flows.

Case study: [English Version](case-studies/agentic-knowledge-vault-mcp.md) | [Versione Italiana](case-studies/agentic-knowledge-vault-mcp-it.md)

### Public Linux Workstation Automation

A public source project for HP AMD business laptops, built from a real workstation tuning need. It includes thermal/power profiles, systemd services, udev rules, sleep hooks, a GNOME Shell indicator, CI checks, GitHub releases, Fedora COPR packaging, and conservative hardware guardrails.

Repo: [hp-elitebook-845-g8-ryzen-tuning](https://github.com/matteopasseri407/hp-elitebook-845-g8-ryzen-tuning)

### AI-Assisted Lead Qualification & Booking Funnel

A live consulting site connected to a private lead lifecycle workflow. The system replaces a typical "contact form into nowhere" flow with a documented operating pipeline: form intake, deterministic pre-checks, LLM-assisted scoring and brief generation, CRM storage, Calendly event handling, Telegram alerts, email fallbacks, and handoff logic.

Case study: [case-studies/ai-enabled-ops-funnel.md](case-studies/ai-enabled-ops-funnel.md)

### ME3Design ERP / Manager Pro

A private ERP-style operations platform built for a custom 3D printing workflow. It covers clients, projects, quoting, estimate support, work logs, delivery and archive workflow, P&L visibility, analytics, lead webhooks, and AI-assisted estimation.

Operating outcome: quote turnaround reduced from about 25 minutes to under 2 minutes.

Case study: [case-studies/custom-3d-printing-erp.md](case-studies/custom-3d-printing-erp.md)

### Self-Hosted n8n Automation Layer

An Oracle Cloud automation layer running active workflows for lead qualification, email triage, job screening, outreach, intelligence feeds, alerts, and operational support.

Case study: [case-studies/self-hosted-n8n-automation-layer.md](case-studies/self-hosted-n8n-automation-layer.md)

### 3D Services Commercial Website

A public commercial website for a 3D scanning and design workflow, built to connect service presentation to structured quote intake and the internal operating system.

Live site: https://me3design.it

Case study: [case-studies/3d-services-website.md](case-studies/3d-services-website.md)

## Screenshots and Walkthroughs

![Sanitized agent context map](assets/agent-context-map.png)

This sanitized context map is a public visual proof of the way I structure operational knowledge for AI-assisted work: project state, implementation notes, workflow documentation, reusable runbooks, and handoff material.

It does not expose private source code, client data, credentials, endpoints, workflow IDs, or internal labels. More detailed walkthroughs can be provided on call with sanitized data.

## Public Sharing Rule

Real source repositories remain private. The safer public approach is:

1. Keep operational source private.
2. Publish sanitized case studies, screenshots, and architecture notes.
3. Link to live public sites where appropriate.
4. Provide live demos and walkthroughs on call instead of exposing internal source.

See [SANITIZATION-CHECKLIST.md](SANITIZATION-CHECKLIST.md) before making any source or screenshot public.

## Contact

- Email: matteo.passeri.407@outlook.it
- LinkedIn: https://linkedin.com/in/matteo-passeri-me3d
