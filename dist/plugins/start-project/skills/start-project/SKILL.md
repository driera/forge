---
name: start-project
description: Bootstrap a new project repo. Use this skill whenever the user wants to initialize a new project from scratch. Reads context.md and PLAN.md to gather what's known about the project, asks the user to supply anything missing, then creates the GitHub repo, establishes directory structure, copies workflow skills, writes CLAUDE.md and README, sets up GitHub Projects and milestone, and hands off to the define-goals skill to establish the initial product scope. Always invoke this before any other skill when starting a new project.
---

# Start Project

Bootstrap a new project from zero: repo, structure, workflow skills, GitHub setup, and
project scoping handoff.

This skill is the entry point to the entire development workflow. Done right, it produces
a repo that looks like a real product from day one — not a half-baked scaffold.

---

## Before you begin

Read `context.md` and `PLAN.md` from this planning repo. These give you the full picture:
who is building, why, what each project is about, and what the workflow looks like. The
quality of the README, CLAUDE.md, and everything else depends on understanding this context.

---

## Step 1 — Gather project context

Ask the user which project to start. Then look it up in `PLAN.md` and `context.md`.

If enough information is already there (problem it solves, goal, skills showcased), use
it — no need to ask again. If the project isn't described or details are thin, ask the
user to provide:

- **Name** — becomes the repo name (lowercase, kebab-case)
- **Problem** — what situation or pain does this address?
- **Goal** — what does a successful v1 look like?
- **Skills showcased** — what technical or craft strengths does this demonstrate?
- **Any constraints** — stack preferences, time, integrations, etc.

Confirm all details with the user before proceeding. The information gathered here drives
the README and CLAUDE.md.

---

## Step 2 — Create the GitHub repo and clone it

```bash
gh repo create driera/<name> \
  --public \
  --description "<one-line goal statement>" \
  --clone

cd <name>
```

The description is the project's Goal in one sentence — terse and product-focused.

---

## Step 3 — Create directory structure

Run the bundled script:
```bash
bash .claude/skills/start-project/scripts/create-dirs.sh
```

This creates:
- `docs/ADRs/` — ADRs, created by `write-adr` during design
- `.github/ISSUE_TEMPLATE/` — issue template for user stories
- `.claude/skills/` — workflow skills (populated in step 5)
- `sessions/` — per-issue work artifacts (exploration.md, design.md, plan.md)

**Checkpoint:** confirm directory structure created before continuing.

---

## Step 4 — Write README.md

The README is a product brief, not an install guide. It should communicate what this
project IS and WHY it matters before saying anything about how to use it. Engineers at
strong engineering orgs scan repos to understand what someone cares about and how they
think — this is that first impression.

Each repo stands alone — no links to other repos in this portfolio, no links to the
portfolio site. Cross-repo linking is `me`'s responsibility.

Structure:

```markdown
# <Project Name>

> <One-sentence value proposition.>

## What it is

<2–3 paragraphs: the problem this solves, the solution, why it's worth building.
Use the Problem and Goal gathered in step 1.>

## What's built here

<Bulleted list of the technical and craft skills showcased. Write these as capabilities,
not technologies — e.g., "Composable ARIA patterns" rather than "React + TypeScript".>

## Status

Current milestone: `MVP — in progress`
[Goals →](GOALS.md) · [Roadmap →](<GitHub Projects link — add after step 8>)

## Development

<Brief notes on how to run locally. Placeholder for now — expands over time.>
```

---

## Step 5 — Pull workflow skills from forge

Pull skills from `github.com/driera/forge` at the current stable tag:

```bash
# Check the current forge tag
gh release view --repo driera/forge --json tagName

# Pull skills into project
gh api repos/driera/forge/tarball/<tag> | tar xz --strip=1 skills/ -C .claude/skills/
```

Skills to pull: `commit`, `define-goals`, `explore-issue`, `plan`, `implement`, `review`,
`write-issue`, `write-adr`.

Do **not** pull `start-project/` (planning repo only) or `skill-creator/` (meta-tool).

> **Note (pre-forge):** Until forge is published, copy from the planning repo:
> ```bash
> for skill in commit define-goals explore-issue plan implement review write-issue write-adr; do
>   cp -r /path/to/portfolio/.claude/skills/$skill .claude/skills/
> done
> ```
> When forge is published and tagged, add `WORKFLOW_VERSION: forge@x.x.x` to the project's
> CLAUDE.md — that's the meaningful moment to introduce it, not before.

**Checkpoint:** confirm skills are in place before continuing.

---

## Step 6 — Write CLAUDE.md

CLAUDE.md is the session contract — what Claude reads at the start of every working
session to resume context cleanly. Keep it accurate and concise.

```markdown
# CLAUDE.md

> Read this at the start of every session.

## Project

**<Project name>** — <one-line description>

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

Replace `<placeholders>` with project-specific values. Add the GitHub Projects link after
step 8.

---

## Step 7 — Write the issue template

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

---

## Step 8 — CI/CD baseline

Scaffold a baseline CI workflow using the bundled script:
```bash
cp .claude/skills/start-project/scripts/scaffold-ci.yml .github/workflows/ci.yml
```

This adds lint + test + build on every PR — deterministic, no model variance.
Project-specific CD (Storybook deploy, Vercel, etc.) is handled in the first relevant
`explore-issue` session, not at bootstrap time.

**Checkpoint:** confirm CI workflow file is in place before continuing.

---

## Step 9 — GitHub Projects and milestone

Create the MVP milestone. The description comes from GOALS.md after `define-goals` runs —
leave a placeholder for now, update after step 10:

```bash
gh api repos/driera/<name>/milestones \
  --method POST \
  -f title="MVP" \
  -f description="<demo-ready threshold — fill after define-goals>"
```

The milestone title is `MVP` (or `v0.1 — MVP`). Moving to the next project is gated
on this milestone being closed.

Create a GitHub Projects roadmap board:

```bash
gh project create --owner driera --title "<Project Name> Roadmap"
```

Note the project URL from the output. Update the `[GitHub Projects]` placeholder in
CLAUDE.md and the README Status section.

**Checkpoint:** confirm milestone and project board created before continuing.

---

## Step 10 — Initial commit

Invoke the `commit` skill. Suggested message: `chore: bootstrap project structure and workflow`.

Then tell the user:

> "Bootstrap commit done. Push to make the repo live:
> ```
> git push -u origin main
> ```
> Let me know when it's done."

Wait for the user to confirm the push is complete before continuing.

---

## Step 11 — Hand off to define-goals

Tell the user:

> "Repo is live at github.com/driera/<name>. Next step: define the product goals — what
> this project needs to achieve, for whom, and in what order of priority. Open the new
> project repo and run `/define-goals` to start."

`define-goals` will create `GOALS.md` — the product source of truth for the project.
Goals drive issues; issues drive the delivery loop. Nothing gets built without a goal
behind it.
