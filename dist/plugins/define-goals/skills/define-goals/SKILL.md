---
name: define-goals
description: Creates or evolves GOALS.md — the product source of truth for a project. Use this skill when starting a new project (inception mode: no GOALS.md yet), or when the user wants to revisit, refine, or extend existing goals (evolution mode). Triggered by start-project at the end of bootstrapping, and by the user directly at any point during the project lifecycle. Always invoke this skill when the user says "define goals", "update goals", "review our goals", "what are we building toward", or similar.
---

# define-goals

Create or evolve `GOALS.md` — the document that answers "what are we building, for whom, and why?" before any code is written.

Goals express **outcomes**, never solutions. "Artists can share their work with a global audience" is a goal. "Build an upload form with S3 storage" is not.

---

## Modes

**Check whether `GOALS.md` already exists in the project root.**

- No file → **Inception mode**: interview the user and create it from scratch
- File exists → **Evolution mode**: read it, understand what needs to change, update it

---

## Inception mode

Called after `start-project` has bootstrapped the repo. The project context (README, CLAUDE.md) is already written — use it as a starting point, not a blank slate.

### 1. Read available context

Read `README.md` and `CLAUDE.md` from the project. Extract:
- Who the project is for
- What problem it addresses
- What a successful v1 looks like

This prevents redundant questions.

### 2. Interview the user

The goal of the interview is to surface **what outcomes matter**, not how to build them. Ask questions that put the user in the perspective of their product's users:

- Who are the people this is for? What role, situation, or pain point defines them?
- What are they trying to accomplish that they can't do well today?
- What does success look like from their point of view?
- Are there secondary users or stakeholders whose needs matter?

Don't ask about features or implementation. If the user starts describing solutions, reflect them back as outcomes: "So the goal is that artists can reach listeners directly — is that right?"

Typically 3–6 goals cover a v1 scope well. Don't push for more.

Also ask: **"What does the minimum showcaseable state look like?"** — the point where you'd confidently demo this to someone. This becomes Milestone 1 (MVP). Capture it as a one-sentence demo-ready threshold at the top of GOALS.md.

### 3. Draft GOALS.md

Draft goals with the status that reflects what the user expressed — `active` for things clearly in scope for v1, `proposed` for things that are on the radar but not yet committed. Don't force all goals through a proposed state first; that just adds friction when the intent is already clear.

Present the draft to the user and iterate until they're satisfied.

### 4. Surface prerequisites (if any)

Before saving, consider: are there cross-cutting design decisions that must be resolved before writing user stories? Examples: API shape that affects multiple components, storage strategy that shapes what's even possible to build.

If genuine prerequisites exist, add a `## Prerequisites` section at the end of GOALS.md:

```markdown
## Prerequisites

Design decisions that must be resolved before writing user stories.
Resolve each by triggering `write-adr` — open decision mode.

- [ ] [Decision title] — [one line on why it must be resolved first]
- [ ] [Decision title] — [one line on why it must be resolved first]
```

Only add this section if genuine prerequisites exist. Skip it if none apply — don't force it.

### 5. Save GOALS.md

Confirm the target project directory with the user before writing — write to the root of that project. The skill is done — no handoff.

The file will be linked from the README's Status section (`[Goals →](GOALS.md)`) thanks to the start-project bootstrap.

---

## Evolution mode

The user wants to add, update, refine, or reprioritize goals as the project grows.

### 1. Read GOALS.md

Understand what's currently there — statuses, intent, subject.

### 2. Understand what needs to change

If the user already stated what they want when triggering the skill (e.g. "mark the auth goal as done", "add a goal for onboarding"), act on it directly — don't re-ask. If the intent is ambiguous or incomplete, then ask.

Options include:
- A new goal to add
- A status change (e.g., a goal is now done, or one being archived)
- A refinement of an existing goal's intent or subject
- Removing a goal that no longer applies

Make the change the user asks for. Don't rewrite the whole file unless asked.

### 3. Save and confirm

Show what changed. Save the updated file. Then invoke the `commit` skill.
Suggested message: `docs: update GOALS.md`.

---

## Goal structure

Each goal has four fields:

| Field | Required | Description |
|-------|----------|-------------|
| `intent` | Yes | The outcome — what becomes true for the user. One sentence, no solution language. |
| `status` | Yes | `proposed` / `active` / `done` / `archived` |
| `subject` | Yes | Who this goal is for — a role, persona, or user type |
| `context` | No | Background that explains why this goal matters or was archived |

**Status meanings:**
- `proposed` — identified but not yet committed to; may be in scope for a future version
- `active` — currently being pursued in this iteration
- `done` — the outcome has been achieved
- `archived` — no longer relevant or intentionally dropped

---

## GOALS.md format

```markdown
# Goals

> Product source of truth. Goals express outcomes, not solutions.
> Updated as the product evolves.

**Milestone 1 (MVP):** <demo-ready threshold in one sentence — the minimum showcaseable state>

## Active

### <intent>

- **Subject**: <who>
- **Context**: <optional>

## Proposed

### <intent>

- **Subject**: <who>

## Done

### <intent>

- **Subject**: <who>

## Archived

### <intent>

- **Subject**: <who>
- **Context**: <why archived>

## Prerequisites

Design decisions that must be resolved before writing user stories.
Resolve each by triggering `write-adr` — open decision mode.

- [ ] [Decision title] — [why it must be resolved first]
```

Omit sections that have no goals. Keep the active section first.

**Goals within each section are listed in priority order** — top to bottom is highest to lowest
priority. List order is the priority signal; no explicit priority field is needed.

---

## What not to do

- Don't let goals describe solutions, features, or implementation details
- Don't invent goals the user hasn't expressed — ask, don't assume
- Don't add more goals than the scope calls for; 3–6 is healthy for a v1
- Don't create tasks or issues — goals are product scope, not work items
- Don't handoff to `write-issue` — the user decides when to start creating issues
