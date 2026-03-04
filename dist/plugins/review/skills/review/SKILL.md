---
name: review
description: Reviews the implementation of an issue before merge. Gathers context from the issue and design.md, delegates to the code-reviewer agent, then drives fixes inline or escalates to plan. Use this whenever the user says "review", "review the implementation", "let's review", "ready for review", "before I merge", or similar.
---

# review

Orchestrates a pre-merge code review with context isolation: gathers values explicitly,
fills the `code-reviewer` prompt template, dispatches a fresh agent. The agent receives
only the filled template — no conversation history, no implicit context.

---

## Step 1 — Gather context

**Get the issue number** — ask the user if not clear from context.

Run in parallel:
```bash
gh issue view NNN --json number,title,body
```
Extract: title, user story, acceptance criteria.

```bash
git log --oneline --grep="#NNN"
```
This returns all commits tagged with the issue number — the exact scope of work regardless
of branching strategy. Capture the output as `{COMMITS}`.

Read `sessions/NNN-issue-title/design.md`. Note its absence if missing — proceed with the
issue alone. Extract: chosen approach.

## Step 2 — Fill and dispatch the code-reviewer agent

Fill the template at `.claude/skills/review/agents/code-reviewer.md` with the gathered values:
- `{ISSUE_NUMBER}` + `{ISSUE_TITLE}`
- `{USER_STORY}` — the user story line from the issue
- `{ACCEPTANCE_CRITERIA}` — full list from the issue body
- `{DESIGN_APPROACH}` — chosen approach from design.md (or "design.md not found" if absent)
- `{COMMITS}` — output of `git log --oneline --grep="#NNN"`

Dispatch as a Task agent. The agent receives only the filled template.

## Step 3 — Present the report

Present the agent's findings grouped as:
- **Blocking** (❌) — must be resolved before merge
- **Important** (⚠️) — worth addressing, not strictly blocking
- **What worked well** (✅)

## Step 4 — Act on blocking issues

**If no blocking issues:** say "Ready to merge." and stop.

**If blocking issues exist**, assess scope and propose what to do — wait for confirmation before acting.

- **Minor** (missing test, small logic gap, convention miss): propose fixing inline. On confirmation,
  fix → validate → commit → go back to Step 1 and re-run. Repeat until clean.

- **Significant** (approach doesn't match design, component needs rethinking, core use case missing):
  append to `sessions/NNN-issue-title/review.md` under a `## Review — YYYY-MM-DD` header with the
  blocking issues and what the next plan must address. On first creation of review.md, invoke the
  `commit` skill to commit it. Then propose going back to `plan`. On confirmation, stop.

## Step 5 — ADR offer (if significant approach change was required)

If a significant blocking issue required an approach change, offer to write an ADR:

> "The approach changed during review — worth capturing why. Want me to write an ADR?"

If yes, invoke `write-adr` in closed decision mode. This is one of the three anchored moments
for proactive `write-adr` suggestions.
