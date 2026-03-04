# explore-issue

Entry point to the delivery loop. Fetches a GitHub issue, explores its problem space, drives design through dialogue, then hands off to `plan`.

## When to use

Say "explore issue NNN", "work on NNN", "let's start issue NNN", or "next issue". With no number, fetches open issues and lets you choose.

## Two phases

**Exploration** — understands the problem: fetches the issue, reads project context, searches relevant code, asks clarifying questions, writes `sessions/NNN-issue-title/exploration.md`.

**Design** — proposes 2–3 approaches with tradeoffs, walks through architecture section by section, writes `sessions/NNN-issue-title/design.md` on approval.

## Resume

Detects existing session files and summarises where you left off before continuing.

## Handoff

Commits session artifacts, then hands off to `plan`.
