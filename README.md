# Agent 0.1 — Skillz Camps Operations Agent

Built at the **Give(a)Go OpenClaw Event #1** — June 6, 2026 at Baseline, Dublin.

## The Event

OpenClaw is a personal AI agent that runs on your own machine — a laptop, a Mac Mini, a Raspberry Pi, or a VPS — and actually does things: runs commands, browses the web, manages files, and talks to your apps. You reach it through WhatsApp, Telegram, or whatever chat app you already use. No engineering background required.

This was the first of a three-event OpenClaw series in June 2026. The goal: leave with OpenClaw alive, connected to a messaging app, with a personality you've written, doing at least one real thing.

**Run of show:**
- 11:00 — Doors open, coffee
- 11:30 — Intro and setup overview
- 12:00 — Build time
- 13:00 — Lunch
- 13:45 — Back to building
- 15:30 — Share what you've got running
- 16:00 — Close

## What I Built

**Agent 0.1** — an AI operations agent for [Skillz Camps](https://skillzcamps.com), a Dublin-based youth sports organisation running hockey academies, holiday camps, and sports equipment sales.

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

- **Brand voice**: Electric Blue (#00a1ff), Deep Navy (#0A1628). No "Field Hockey". 5 hashtag max on Instagram. First person plural on LinkedIn.
- **Partnerships pipeline**: KidsCraft.com exploratory call (May 5, 2026) — free trial for first 20 providers, cross-promotion discussed.
- **Basketball Launch**: June 20, 2026 — content pipeline in motion. 4-phase launch checklist in Notion.
- **Academy expansion**: Targeting 10 UK locations by 2028, starting with Battersea.
- **11 past events** documented across 3 verticals.

### GitHub

Setup pushed to [github.com/LiamMaher04/openclaw_learning](https://github.com/LiamMaher04/openclaw_learning).

SSH key configured for WSL2 → GitHub push/pull.

---

## Next Steps

1. Connect Wix for bookings data (required for Weekly Bookings Digest and Camp Capacity Monitor workflows)
2. Connect Gmail and Google Calendar
3. Process and categorise full Tasks database
4. Complete remaining PoC workflows
5. Build MEMORY.md from daily session logs
6. Add team members to Telegram pairing

---

*Built by [Liam Maher](https://github.com/LiamMaher04) during Give(a)Go OpenClaw Event #1 · Dublin, June 2026*