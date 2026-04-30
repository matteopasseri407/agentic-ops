# AI-Assisted Lead Qualification & Booking Funnel

## Summary

A public consulting site (aienabledops.it) connected to a private lead lifecycle and qualification workflow. The system was built to demonstrate that a small business can run a documented, auditable lead pipeline instead of losing context between form, qualification, booking, CRM, and follow-up.

This is the flagship lead lifecycle build of the portfolio: it covers the flow from public intake to qualified booking, with deterministic rules, AI-assisted scoring, CRM storage, alerting, and explicit operational handoff.

## Lead Lifecycle Problem

Most small-business lead flows lose context across:

- form submission and proxying
- qualification and scoring
- booking
- CRM storage and enrichment
- follow-up and fallback

The result is dropped context, unqualified meetings on the calendar, and no audit trail. The goal was a single operating pipeline that combines deterministic checks, AI assistance, and human-in-the-loop control.

## Lifecycle Built

- Public website and booking entry point
- Form intake proxy with deterministic pre-checks
- LLM-assisted lead scoring and brief generation
- CRM storage with structured fields
- Calendly event handling and confirmation
- Telegram alerts on qualified leads
- Email fallback paths
- Documented operational handoff between automated and human steps

## Architecture (Sanitized)

- Public marketing site (React, TypeScript, Vite, Vercel)
- n8n automation layer running on a private endpoint
- Notion as CRM
- Calendly for booking
- Telegram for operator alerts
- Resend for transactional email
- LLM scoring via Groq

Workflow exports, endpoint URLs, webhook IDs, credentials, and operational notes are kept private.

## Operating Outcome

- Public site connected to a workflow-backed intake system instead of a static contact form.
- Combined deterministic rules with LLM classification, avoiding "AI-only" failure modes.
- Added alerting, fallback paths, and explicit handoff documentation.
- Created a reusable model for SME lead lifecycle management.

## Demo Approach

Live walkthrough provided on call. The public site is the entry point; the internal pipeline is shown screen-share with sanitized data.
