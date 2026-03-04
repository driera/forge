---
name: plan
description: Reads exploration.md and design.md from the current session and produces bite-size implementation plan in plan.md. Use this whenever the user says "plan", "write the plan", "plan the implementation", or after explore-issue hands off to planning.
---

# plan

Turns an approved design into an ordered sequence of tasks a skilled developer can execute without knowing anything about the domain. The plan describes *what* to achieve and *which use cases to cover* — not *how* to implement it. Implementation decisions belong to the `implement` skill.

## Inputs

Read these files from the session directory before writing anything:
- `sessions/NNN-issue-title/exploration.md` — problem context, edge cases, constraints
- `sessions/NNN-issue-title/design.md` — approved approach, architecture, components
- `sessions/NNN-issue-title/review.md` — if it exists, a previous review found significant issues; the new plan must address them
- `CLAUDE.md` — project conventions, stack, patterns in use

If exploration.md or design.md is missing, tell the user and stop — the plan depends on validated exploration and design.

## Plan principles

**Write for someone with no domain knowledge.** The developer reading this plan is skilled but has never seen this codebase. They should not need to open exploration.md or design.md to understand what they're doing or why. Surface what matters.

**Bite-size tasks.** Each task should be independently executable and committable. If a task feels like it could be split, split it. The right size is roughly: write tests → implement → commit.

**TDD order.** Within each task, the implied sequence is: define what to verify first, then make it pass. The plan doesn't write tests — it specifies what behavior needs to be verified.

**YAGNI.** Only plan what the issue requires. If a generalization isn't needed for this issue, leave it out. Future issues can extend.

**One commit per task.** Include a suggested commit message for each task. This enforces focus and makes the history readable.

## plan.md format

```markdown
# Plan: [Issue title]

## Context

[Everything a developer needs before touching any code. Cover:]
- What this feature/fix is about and why it exists (one short paragraph)
- Which files are directly involved — path and what each one does
- Existing patterns or conventions they must follow
- Anything non-obvious about the domain that would trip them up

Keep this section honest and complete. If a developer skips the session docs
and only reads this plan, they should still be able to execute it correctly.

## Tasks

### 1. [Task name — verb phrase describing the outcome]

What this task achieves and why it's needed.

Use cases to cover:
- [Specific scenario or input this task must handle]
- [Edge case from exploration.md worth naming]
- …

Commit: `type(scope): short message`

---

### 2. [Next task]

…

## Dependencies

[Only include if tasks have non-obvious ordering constraints beyond the list order.
If tasks must be done in order and that's clear from reading them, omit this section.]
```

## After writing

Show the plan to the user. Ask: "Does this cover everything, or anything to adjust before implementing?"

Once confirmed, invoke the `commit` skill to commit plan.md (and any session artifacts modified during planning).
Suggest commit message: `docs: add plan for #NNN`

The commit must happen before the handoff message. Plan intent belongs in git history independently
of the implementation — reviewers and future sessions can read the plan at the exact commit it was written.

Then tell the user to invoke the `implement` skill to start.
