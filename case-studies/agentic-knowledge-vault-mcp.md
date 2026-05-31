# The Agentic Second Brain: Git-Backed Multi-Agent MCP Knowledge Architecture

## Summary
A production-grade, secure context-delivery and memory architecture built to support local and cloud-based AI agents (Claude Code, Codex CLI, custom ChatGPT connectors). By mapping structured business operations, personal capabilities, and system runbooks into a Git-versioned Markdown database, this system provides AI agents with instant, high-density operational context.

This architecture solves the "context drift" and "token waste" problems by implementing a strict, agent-targeted retrieval protocol coupled with event-driven synchronization and hybrid Model Context Protocol (MCP) server endpoints.

*Note: This case study is completely sanitized. Server IPs, domains, security tokens, private system paths, and GPG-encrypted credentials are strictly isolated and private.*

---

## The Operational Problem
When collaborating with advanced AI coding and automation agents across different devices, three major challenges arise:
1. **Context Drift & Inefficiency:** AI agents lose context between sessions, requiring manual bootstrapping or massive, repetitive file dumps that clutter the context window and drive up token consumption.
2. **Security Risks:** Storing sensitive information (credentials, API webhooks, client data) directly in active workspaces or in plain-text prompts leads to inevitable security leaks.
3. **Synchronicity & Friction:** Keeping operational memory updated across multiple physical workstations (e.g., Fedora Linux laptops, Windows desktops) and cloud-based automation environments without manual copy-pasting.

---

## The 4-Layer Architecture Built

```mermaid
graph TD
    subgraph Client Workstations (Fedora / Windows)
        Obsidian["Human Interface (Obsidian)"] -->|Local Edit| LocalVault["Local Markdown Vault"]
        LocalVault -->|Event-driven Watchdog (Python)| GitPush["Auto Git Commit & Push"]
        LocalAgents["Local Agents (Claude Code, Codex)"] <-->|Direct Filesystem MCP| LocalVault
    end

    subgraph Version Control
        GitPush -->|SSH / HTTPS| GitHubPrivate["GitHub Private Repository"]
        GitPush -->|SSH Push| OracleBareGit["Oracle Cloud Bare Git Repo"]
    end

    subgraph Cloud Runtime (Oracle Cloud VPS)
        OracleBareGit -->|post-receive git hook| WorkingCopy["Oracle Active Working Copy"]
        
        Caddy["Caddy Reverse Proxy (TLS)"] <--> TrustedMCP["Trusted MCP Server (Bearer Auth)"]
        Caddy <--> PublicMCP["Public MCP Server (Read-only)"]
        
        WorkingCopy <-->|Trusted Writes (Commit-Backed)| TrustedMCP
        WorkingCopy --->|Read-only Path Filtered| PublicMCP
    end

    subgraph External AI
        CustomChatGPT["ChatGPT Custom Connector"] <-->|API Calls| Caddy
    end
```

### Layer 1: The Canonical Markdown Vault (Knowledge Layer)
The foundation is a structured Obsidian-compatible Markdown vault organized for precision retrieval. It acts as the single source of truth for facts, capability limits, active projects, system runbooks, and brand voice.
* **Requirements-First Routing:** A strict entry-point protocol (`00-START-HERE.md`) forces agents to read the map first and then query only the specific note required for the active task.
* **Security Isolation:** Plain-text credentials are strictly banned from the sync loop. The vault contains only an unencrypted systems index (`99-SECRETS/secrets-registry.md`), while all actual sensitive configurations are kept in an offline GPG-encrypted archive.

### Layer 2: Hybrid Sync & Deployment Pipeline
Memory updates are entirely automated using Git and a lightweight local daemon:
* **Event-Driven Auto-Sync:** A background Python daemon utilizing `watchdog` runs as a systemd user service on Linux (and replicated on Windows). It monitors vault changes, debounces file saves by 60 seconds, commits changes automatically, and pushes them.
* **Server-Side Deployment:** Changes are pushed to a bare Git repository on Oracle Cloud. A custom `post-receive` git hook automatically checks out the newest master branch to an active working copy, making updates instantly live.

### Layer 3: Model Context Protocol (MCP) Access Layer
To make this second brain accessible to all AI assistants securely, the environment runs dual MCP servers hosted behind a Caddy reverse proxy with automatic SSL:
1. **Local Filesystem MCP:** Local agents (Claude Code, Codex CLI) query the local vault instance, ensuring zero network latency.
2. **Remote Trusted MCP Server (Read/Write):** Allows authenticated cloud agents or remote tasks to access the vault. Every write action (e.g., creating a note, updating status) is serialized with a file lock, automatically committed back to Git with metadata, and deployed.
3. **Remote Public MCP Server (Read-Only):** A highly restricted, path-filtered endpoint designed to connect external services like ChatGPT custom connectors without exposing private modules or backend architectures.

---

## Core Outcomes
* **Zero-Overhead Bootstrapping:** Spinning up a new workspace with Claude Code or Codex takes less than 3 seconds. The agent queries `00-START-HERE.md` and immediately knows the user's working style, exact machine specs, and capability limits.
* **Up to 80% Token Savings:** Instead of loading full documents or heavy instruction sets, agents pull short, hyper-focused Markdown files on-demand using the MCP search and read tools.
* **Multi-Workstation Synchronicity:** Any workflow update or system configuration adjustment committed by an agent on one machine is pushed to the cloud, synchronized, and pulled down by other machines at logon, keeping the entire ecosystem aligned.

---

## What's Next: OpsVault

This architecture is currently being refactored and packaged into a reusable open-source tool named **[OpsVault](https://github.com/matteopasseri407/opsvault)**. 

The goal is to provide a single-command deployable stack (MCP Server + Caddy reverse proxy), a lightweight Python autosync daemon for background Git syncing, and standard token-optimized Obsidian templates. This will allow any developer to set up their own secure, cloud-first multi-agent memory layer in minutes.

*Stay tuned! The repository is currently being prepared for its public release under the **AI Enabled Ops** brand.*
