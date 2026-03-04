---
name: write-adr
description: Creates an Architecture Decision Record in docs/ADRs/. Floats across both workflow loops — proactively suggested by Claude when a significant architectural decision is detected, or triggered directly by the user at any point. Use this whenever the user says "write an ADR", "document this decision", "capture this", or when a decision with real tradeoffs has been made and isn't yet recorded.
---

# write-adr

Captures an architectural decision so future developers (and future you) understand not just what was decided, but why — and what was ruled out. An ADR is worth writing when the decision had real tradeoffs and the reasoning isn't obvious from the code.

---

## Two entry modes

At invocation, determine which mode applies — or ask: "Have you already decided, or do you need to work through it?"

### Open decision mode (decision not yet made)

Claude drives the exploration first. Do not jump to documentation.

1. Present the problem space — what's the decision about, what forces are at play
2. Propose 2–3 options with tradeoffs; lead with a recommendation and explain why
3. Reach a decision with the user through dialogue
4. Then document it as an ADR (step 3 below)

Use this mode when triggered from a GOALS.md prerequisite, or when it's clear from context that the decision is still open.

### Closed decision mode (decision already made)

Go straight to documentation.

1. If invoked proactively (Claude detected the decision), summarise what you understood was decided and why — ask the user to confirm or correct before writing
2. If invoked directly by the user, ask what was decided if it isn't already clear from context: what was chosen, what was the main alternative, what drove the choice
3. Then document it (step 3 below)

---

## When to suggest it proactively

Only at these three moments — nowhere else:

1. **End of `explore-issue` design phase** — when a closed decision was made during design with real tradeoffs worth capturing
2. **End of a prerequisite resolution** triggered from a GOALS.md prerequisite item
3. **End of `review`** — if a significant approach change was required during the review

Outside these moments, do not proactively suggest `write-adr`. The user can always trigger it manually.

Signals that a decision warrants an ADR:
- A technology or approach was chosen over a reasonable alternative
- A constraint shaped the design in a non-obvious way
- A decision closes off future options worth knowing about

---

## Step 1 — Understand the decision

See entry modes above. Don't proceed to writing until the decision is clear and confirmed.

## Step 2 — Determine the next ADR number

Run:
```bash
.claude/skills/write-adr/scripts/next-number.sh
```

This reads `docs/ADRs/` and returns the next sequential number (e.g. `003`).

If `docs/ADRs/` doesn't exist, create it and the script will start at `001`.

## Step 3 — Draft the ADR

Fill the template at `.claude/skills/write-adr/templates/adr.md` with:
- `{NUMBER}` — from step 2
- `{TITLE}` — short, decision-focused title
- `{DATE}` — today's date (YYYY-MM-DD)
- `{CONTEXT}` — situation that prompted the decision and forces at play
- `{DECISION}` — what was decided, stated directly
- `{ALTERNATIVES}` — options considered and why each was not chosen
- `{CONSEQUENCES}` — what becomes easier, harder, or newly open
- `{REFERENCES}` — links to issues, PRs, or external resources (omit section if none)

Keep it concise. A good ADR fits on one screen.

## Step 4 — Present and confirm

Show the draft to the user. Ask: "Does this capture it correctly?"

Apply any corrections, then write to `docs/ADRs/NNN-kebab-title.md`.

## Step 5 — Commit

Invoke the `commit` skill. Suggested message: `docs: add ADR NNN — <kebab-title>`.
