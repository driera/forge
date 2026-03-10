---
name: setup-project
description: Bootstrap a new project repo from scratch. Use this skill whenever the user wants to start a new project and has no existing planning files. Asks the user for all project context directly, then creates the GitHub repo, establishes directory structure, writes CLAUDE.md and README, sets up GitHub Projects and milestone, and hands off to the define-goals skill. Always invoke this before any other skill when starting a new project.
---

# Setup Project

Bootstrap a new project from zero: repo, structure, workflow setup, GitHub configuration, and
product scoping handoff.

This skill is the entry point to the entire development workflow. Done right, it produces
a repo that looks like a real product from day one — not a half-baked scaffold.

---

## Step 1 — Gather project context

Detect the user's GitHub handle:

```bash
gh auth status
```

Extract the authenticated username from the output. Confirm it with the user — if they want
to use a different handle or organisation, let them correct it now.

Then ask the user to provide the following. Ask all at once, not one by one:

- **Project name** — becomes the repo name (lowercase, kebab-case)
- **Description** — one sentence: what it is and for whom (becomes repo description + README tagline)
- **Problem** — what situation or pain does this address?
- **Goal** — what does a successful v1 look like?
- **Skills showcased** — what technical or craft strengths does this demonstrate? (optional)

Confirm all details with the user before proceeding. The information gathered here drives
the README, CLAUDE.md, and the GitHub repo description.

---

## Step 2 — Create the GitHub repo and clone it

```bash
gh repo create <handle>/<name> \
  --public \
  --description "<description from step 1>" \
  --clone

cd <name>
```

The description is the one-sentence value proposition gathered in step 1.

---

## Step 3 — Create directory structure

```bash
mkdir -p docs/ADRs
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/workflows
mkdir -p sessions
```

This creates:
- `docs/ADRs/` — ADRs, written by `write-adr` during design
- `.github/ISSUE_TEMPLATE/` — issue template for user stories
- `.github/workflows/` — CI configuration (populated by `define-tech` → CI task)
- `sessions/` — per-issue work artifacts (exploration.md, design.md, plan.md)

**Checkpoint:** confirm directory structure created before continuing.

---

## Step 4 — Write README.md

The README is a product brief, not an install guide. It should communicate what this
project IS and WHY it matters before saying anything about how to use it. Engineers at
strong engineering orgs scan repos to understand what someone cares about and how they
think — this is that first impression.

Structure:

```markdown
# <Project Name>

> <One-sentence value proposition.>

## What it is

<2–3 paragraphs: the problem this solves, the solution, why it's worth building.
Use the Problem and Goal gathered in step 1.>

## What's built here

<Bulleted list of the technical and craft skills showcased. Write these as capabilities,
not technologies — e.g., "Composable ARIA patterns" rather than "React + TypeScript".
If the user provided skills showcased in step 1, use those. Otherwise, derive from context.>

## Status

Current milestone: `MVP — in progress`
[Goals →](GOALS.md) · [Tech →](TECH.md) · [Roadmap →](<GitHub Projects link — add after step 8>)

## Development

<Brief notes on how to run locally. Placeholder for now — expands over time.>
```

---

## Step 5 — Verify Forge is installed

Forge skills are distributed as a Claude plugin — no per-project file copying needed.
Skills are available globally once the marketplace is added to Claude Code.

If Forge isn't already installed, tell the user:

> "Add the Forge marketplace to Claude Code:
> ```
> /plugin marketplace add driera/forge
> ```
> Let me know when it's done."

Wait for confirmation before continuing.

Note the current Forge version for CLAUDE.md (step 6):
```bash
gh release view --repo driera/forge --json tagName --jq .tagName
```

**Checkpoint:** confirm Forge is installed before continuing.

---

## Step 6 — Write CLAUDE.md

CLAUDE.md is the session contract — what Claude reads at the start of every working
session to resume context cleanly. Keep it accurate and concise.

```markdown
# CLAUDE.md

> Read this at the start of every session.

## Project

**<Project name>** — <one-line description>

`WORKFLOW_VERSION: forge@<version>`

---

## Session start

1. Read this file
2. Check [GitHub Projects](<link>) for the current sprint
3. Pick the next issue, run `/explore-issue <NNN>`

---

## Workflow loop

```
explore-issue → plan → implement → review
```

Work artifacts per issue live in `sessions/NNN-issue-title/`:
- `exploration.md` — problem space and edge cases
- `design.md` — architecture, components, data flow
- `plan.md` — ordered, testable tasks

---

## Commit convention

```
type: short imperative description
```

Types: `feat`, `fix`, `test`, `docs`, `refactor`, `chore`, `a11y`, `dx`

Examples:
```
feat: add loading state with aria-busy
a11y: implement keyboard navigation for listbox
docs: document token system approach
```

---

## Principles

- **TDD** — tests before or alongside implementation, always
- **Documentation-first** — README and issues written before code
- **Short, intentional commits** — each commit tells a story
- **Clean code + functional patterns** — no shortcuts for speed
```

Replace `<placeholders>` with project-specific values. Add the GitHub Projects link after step 9.

---

## Step 7 — Write the issue templates

Write two templates in `.github/ISSUE_TEMPLATE/`.

**user-story.md** — for product features and user-facing improvements:

```markdown
<!-- .github/ISSUE_TEMPLATE/user-story.md -->
---
name: User Story
about: A feature or improvement from a user's perspective
labels: ''
assignees: ''
---

## As a [user], I want [action] so that [outcome]

## Context

Why does this exist? What problem does it solve?

## Acceptance Criteria

- [ ] Specific, testable criterion
- [ ] A11y: passes axe with zero violations (if UI component)
- [ ] Tests written and passing
- [ ] Docs updated (if applicable)

## Technical Notes

Constraints, approach hints, ADR references.

## Definition of Done

- [ ] Tests passing
- [ ] Code reviewed
- [ ] Docs updated
- [ ] PR linked and merged
```

**task.md** — for engineering work not tied to a user-facing outcome (toolchain, refactors, infrastructure, dependencies):

```markdown
<!-- .github/ISSUE_TEMPLATE/task.md -->
---
name: Task
about: Engineering work
labels: ''
assignees: ''
---

## Problem

What is broken, missing, or needs addressing?

## Context

Background, why it matters, what it affects.

## Proposed Solution

Direction or approach. Not prescriptive — refined during exploration.

## Acceptance Criteria

- [ ] Specific, testable criterion
- [ ] Tests written and passing (if applicable)
- [ ] Docs updated (if applicable)

## Definition of Done

- [ ] Tests passing
- [ ] Code reviewed
- [ ] PR linked and merged
```

---

## Step 8 — GitHub Projects and milestone

Create the MVP milestone. The description comes from GOALS.md after `define-goals` runs —
leave a placeholder for now, update after step 9:

```bash
gh api repos/<handle>/<name>/milestones \
  --method POST \
  -f title="MVP" \
  -f description="<demo-ready threshold — fill after define-goals>"
```

The milestone title is `MVP` (or `v0.1 — MVP`). Moving to the next project is gated
on this milestone being closed.

Create a GitHub Projects roadmap board:

```bash
gh project create --owner <handle> --title "<Project Name> Roadmap"
```

Note the project URL from the output. Update the `[GitHub Projects]` placeholder in
CLAUDE.md and the README Status section.

**Checkpoint:** confirm milestone and project board created before continuing.

---

## Step 9 — Initial commit

Invoke the `commit` skill. Suggested message: `chore: bootstrap project structure and workflow`.

Then tell the user:

> "Bootstrap commit done. Push to make the repo live:
> ```
> git push -u origin main
> ```
> Let me know when it's done."

Wait for the user to confirm the push is complete before continuing.

---

## Step 10 — Hand off to define-goals

Tell the user:

> "Repo is live at github.com/<handle>/<name>. Next: define what this project needs to
> achieve. Open the new project repo and run `/define-goals` to start."

The full inception chain from here:
```
define-goals → BACKLOG.md (product issues)
             → define-tech → BACKLOG.md (engineering tasks) → CI workflow
                           → write-issue (works through the full backlog)
```
