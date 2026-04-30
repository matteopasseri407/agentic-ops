# Custom 3D Printing ERP / Manager Pro

## Summary

A private ERP-style operations platform built for an Italian custom 3D printing studio. The goal was to replace fragmented quoting and project tracking with a structured system that supports the full quote-to-cash loop, reporting, and operational handoff.

Client name and project specifics are kept private.

## Operations Problem

The operation depended on manual quoting, scattered project information, and repeated context rebuilding. Quote preparation took about 25 minutes. Project status, financials, and delivery state were split across tools and memory, with no single source of truth from lead to delivery.

## Quote-to-Cash Loop Built

- Client and project management
- Quote and estimate support with AI-assisted estimation
- Work log tracking against projects
- Delivery and archive workflow
- P&L visibility per project and overall
- Analytics dashboard
- Lead webhook endpoints into the platform
- AI-assisted project context support during execution

## Architecture (Sanitized)

- Web app: Next.js, React, TypeScript, Tailwind
- Database and auth: Supabase
- Charts and analytics: Recharts
- AI estimation and context: Groq and Gemini integrations
- Tests: Vitest

Schema details, webhook URLs, credentials, prices, and client data are kept private.

## Operating Outcome

- Quote turnaround reduced from about 25 minutes to under 2 minutes.
- End-to-end pipeline visibility from lead intake to delivery and P&L.
- Manual process turned into a repeatable platform workflow with operational handoff.
- Single source of truth across clients, projects, financials, and delivery state.

## Demo Approach

Live walkthrough provided on call, with all client data, prices, project IDs, and operational notes blurred or replaced with fixtures.
