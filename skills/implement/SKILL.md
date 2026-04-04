---
name: implement
description: Executes the implementation plan from plan.md task by task, following TDD. Reviews the plan critically before starting, then loops through tasks and commits at group boundaries defined in the plan. Use this whenever the user says "implement", "start implementing", "let's code", or after plan hands off to implementation.
---

# implement

Works through `plan.md` autonomously — no need to tell it which task to do next. Tasks are grouped into commit groups; `implement` commits at group boundaries, not after every task. At the end, re-validates everything and summarises what was built.

## Step 1 — Review the plan

Read `sessions/NNN-issue-title/plan.md`. If the file doesn't exist, ask:
"No `plan.md` found. I can work from a plan you paste here, a plan file you point me to, invoke `plan` to generate one, or you can describe what to implement and I'll structure it. Which would you prefer?"

The plan is self-contained and is your primary input throughout.

**Check for completed tasks first.** If tasks are already marked done (`[x]`), open with a resume summary before doing anything else:

> "I can see tasks 1–N are already done. Current state:
> - [x] Task 1
> - [x] Task 2
> - [ ] Task 3 ← resuming here
>
> Does this match where we left off?"

Wait for confirmation before proceeding. If the user corrects something, adjust before continuing.

After reading (or resuming), think critically about the remaining tasks:
- Are any tasks ambiguous or missing information?
- Does anything contradict the codebase's existing patterns?
- Is there a dependency or risk the plan didn't account for?

If something is unclear, consult `sessions/NNN-issue-title/design.md` for the architectural intent before raising it with the user. If it's still unresolved after that, raise it — describe what you found and what you'd need to proceed. Once the plan is solid, move to step 2.

## Step 2 — Implement a commit group

Find the next commit group: all consecutive tasks up to (and including) the next `Commit:` line in `plan.md`.

Work through each task in the group without stopping:

For each task:
1. Write the failing test(s) for the use cases listed — nothing beyond what the plan specifies
2. Confirm they fail
3. Implement the minimum code to make them pass
4. Refactor if needed — clean up without changing behaviour
5. Mark the task as done: `- [ ] Task name  →  - [x] Task name`

After the last task in the group, run validations once: read `TECH.md` for the package manager, then run lint → typecheck → test using whatever scripts are configured. Skip any script that doesn't exist in `package.json`.

## Step 2a — Deviation handling

Deviations from the plan happen. Handle them by scope:

**Minor deviation** — extra helper needed, slightly different file structure, small scope adjustment within the task:
- Continue without stopping
- Note it for the group report

**Significant deviation** — wrong approach identified, missing design piece, changes required beyond current task scope, would affect other tasks:
- Stop immediately
- Describe what was found
- Propose one of:
  - Patching `plan.md` inline if the fix is contained to remaining tasks
  - Escalating to `plan` if the design assumption is fundamentally wrong

Do not push through a significant deviation silently. The minor/significant split matches the mental model in `review` — use the same judgement.

## Step 3 — Group report and commit

Show:
- Validation output (full or summarised if long — errors always in full)
- Tasks completed in this group (brief description of what changed)
- Any deviations noted

Then: before invoking the `commit` skill, check if `context.md` or `plan.md` in the session directory are uncommitted (i.e. untracked or modified in `git status`). If so, stage them alongside the implementation files — they belong in this first commit.

Invoke the `commit` skill using the group's commit message.

Repeat from Step 2 for the next commit group until all tasks are done.

## Step 4 — Done

After the last commit group:
1. Say: **"I'm done with the plan."**
2. Show a short summary: what was built, which tasks were completed, any deviations worth noting.
3. Offer to chain:

> "Ready to review? I'll kick off `/review` now — ok?"

If confirmed, invoke the `review` skill.
