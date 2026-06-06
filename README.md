# Agent 0.1 — Skillz Camps Operations Agent

I built this at the **Give(a)Go OpenClaw Event #1** — a Saturday afternoon at Baseline in Dublin, coffee in hand, figuring out how to make an AI agent actually useful for my business.

OpenClaw is a personal AI agent that runs on your own machine — not someone else's cloud, not a SaaS dashboard. It reads your files, talks to your apps, searches the web, and messages you through Telegram or WhatsApp like a real teammate. No engineering background required. The whole thing runs locally.

This was the first of three OpenClaw events this June. By the end of the afternoon I had an agent with a personality, connected to Notion and Telegram, already flagging things in my content calendar that I'd missed. Not bad for a few hours.

## What I Built

**Agent 0.1** — an AI operations agent for [Skillz Camps](https://skillzcamps.com), the youth sports business I co-founded. We run hockey academies, holiday camps, and sell hockey equipment in Dublin.

### Stack

| Component | Detail |
|---|---|
| **Runtime** | OpenClaw v2026.6.1 on WSL2 (Ubuntu) |
| **Model** | DeepSeek V4 Pro via Tensorix |
| **Channels** | Web (webchat), Telegram (@agent01_skillz_bot), WhatsApp |
| **Integrations** | Notion (read/write via API), DuckDuckGo (web search) |

### Identity Files

- **SOUL.md** — Personality and behavioural rules. Direct, warm tone. Youth sports context. PoC safety constraints.
- **IDENTITY.md** — Functional definition. Scope across three verticals: Hockey Academy, Camps & Masterclasses, Products. Priority workflow definitions.
- **AGENTS.md** — Operating rules, memory management, heartbeat config, group chat etiquette.
- **HEARTBEAT.md** — Periodic task definitions and scheduling.
- **USER.md** — User context template (to be filled in).
- **TOOLS.md** — Environment-specific tool notes and configurations.

### Integrations Connected

- ✅ **Notion** — Connected to Skillz Camps HQ workspace. Accessed wiki (core pages: About, Programmes, Key People, Partnerships, Brand & Marketing, Events History, Academy Expansion Plan, Launch Checklist), Content Calendar (30 entries), and Tasks database (100+ entries).
- ✅ **Telegram** — Bot (@agent01_skillz_bot) configured for DMs and group chat ("Skillz Team Chat"). Pairing-based access control.
- ✅ **WhatsApp** — Configured for self-chat (DM allowlist).
- ⬜ **Wix** — Not yet connected (PoC target).
- ⬜ **Gmail** — Not yet connected.
- ⬜ **Google Calendar** — Not yet connected.
- ⬜ **Google Drive** — Not yet connected.

### PoC Workflows Progress

| Workflow | Status |
|---|---|
| **Notion Task Sync from Call Notes** | ✅ First draft task created via `ntn task` — demo of call-notes-to-Notion pipeline |
| **Content Calendar Gap Alert** | ✅ Hockey Masterclass gap identified (last published Feb 12, 2025 — 8 weeks stale vs. weekly target) |
| **Weekly Bookings Digest** | ⬜ Not started (needs Wix connection) |
| **Camp Capacity Monitor** | ⬜ Not started (needs Wix connection) |

### Key Business Context Loaded

- **Brand voice**: Public-facing tone, colours, hashtag rules, platform conventions
- **Partnerships pipeline**: Exploratory stages — cross-promotion and sponsorship opportunities being evaluated
- **Marketing calendar**: Upcoming launch events with multi-phase content pipelines in motion
- **Expansion planning**: New market entry programme in development
- **Historical events**: Past programme data documented for reference

### GitHub

Setup pushed to [github.com/LiamMaher04/openclaw_learning](https://github.com/LiamMaher04/openclaw_learning).

SSH key configured for WSL2 → GitHub push/pull.

---

---

*Built by me, [Liam Maher](https://github.com/LiamMaher04), at Give(a)Go OpenClaw Event #1 — Dublin, June 2026*