---
name: plan
description: Reads context.md from the current session and produces a bite-size implementation plan in plan.md. Use this whenever the user says "plan", "write the plan", "plan the implementation", or after explore-issue hands off to planning.
---

# plan

Turns an approved design into an ordered sequence of tasks a skilled developer can execute without knowing anything about the domain. The plan describes *what* to achieve and *which use cases to cover* — not *how* to implement it. Implementation decisions belong to the `implement` skill.

## Inputs

Read these files from the session directory before writing anything:
- `sessions/NNN-issue-title/context.md` — problem space, edge cases, constraints, approved approach, architecture, components
- `sessions/NNN-issue-title/review.md` — if it exists, a previous review found significant issues; the new plan must address them
- `CLAUDE.md` — project conventions, stack, patterns in use
- `TECH.md` — package manager, test runner, language (if it exists)

If context.md is missing, ask the user:
> "No context.md found for this session. Paste your issue description, spec, or tell me what you want to plan."
Accept any input — a JIRA ticket, a Notion doc, a plain description — and use it as the context. Continue normally.

## Plan principles

**Write for someone with no domain knowledge.** The developer reading this plan is skilled but has never seen this codebase. They should not need to open context.md to understand what they're doing or why. Surface what matters.

**Task scope.** Each task is a full vertical slice for one feature: types → tests → implementation. Never split by layer (all types first, then all tests). Never split by phase across features. If a task feels too large, find a smaller version of the feature that still works end to end — then push the rest to a follow-up task. Tasks don't map 1:1 to commits — see Commit groups.

**TDD order within each task.** The implied execution sequence is always: define types → write failing tests → implement → run validators. The plan doesn't write code — it names what types to introduce and what behavior to verify.

**YAGNI.** Only plan what the issue requires. If a generalization isn't needed for this issue, leave it out. Future issues can extend.

**Commit groups.** Tasks are fine-grained; commits are not. Group related tasks in the plan and mark each boundary with a `Commit:` line after the last task in the group. `implement` commits when it hits a marker — no runtime judgment needed. A plan for a single issue typically has 1–3 commit groups.

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

Types to define (if any):
- [Interface, enum, or type alias this task introduces]

Test cases:
- [Scenario or input — what goes in, what's expected out]
- [Edge case worth naming]

What to implement:
- [Observable outcome — what the system does or stops doing as a result of this task]

### 2. [Next task — logically related to task 1]

…

Commit: `type(scope): short message`

---

### 3. [Task — starts a new commit group]

…

Commit: `type(scope): short message`

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
