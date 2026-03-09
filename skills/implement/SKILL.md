---
name: implement
description: Executes the implementation plan from plan.md task by task, following TDD. Reviews the plan critically before starting, then loops through tasks with a report-and-feedback cycle before each commit. Use this whenever the user says "implement", "start implementing", "let's code", or after plan hands off to implementation.
---

# implement

Works through `plan.md` autonomously — no need to tell it which task to do next. Each task follows a tight loop: implement → validate → report → feedback → commit. At the end, re-validates everything and summarises what was built.

## Step 1 — Review the plan

Read `sessions/NNN-issue-title/plan.md`. If the file doesn't exist, stop and tell the user:
"No `plan.md` found in `sessions/NNN-issue-title/`. Run `plan` first."

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

## Step 2 — Implement a task

Find the first task not marked as done. Mark it as in-progress in `plan.md`:
```
- [ ] Task name  →  - [~] Task name
```

Follow TDD:
1. Write the failing test(s) for the use cases listed in this task — nothing beyond what the plan specifies
2. Confirm they fail
3. Implement the minimum code to make them pass
4. Refactor if needed — clean up without changing behaviour
5. Run all validations using `scripts/validate.sh` relative to this skill's base directory (provided in the system context as `Base directory for this skill: <path>`). The script detects what npm scripts exist in `package.json` and only runs those — safe to run even on a partially configured project.
6. Mark the task as done:
```
- [~] Task name  →  - [x] Task name
```

## Step 2a — Deviation handling

Deviations from the plan happen. Handle them by scope:

**Minor deviation** — extra helper needed, slightly different file structure, small scope adjustment within the task:
- Continue without stopping
- Note the deviation in the task report
- Flag it in the final summary

**Significant deviation** — wrong approach identified, missing design piece, changes required beyond current task scope, would affect other tasks:
- Stop immediately
- Describe what was found
- Propose one of:
  - Patching `plan.md` inline if the fix is contained to remaining tasks
  - Escalating to `plan` if the design assumption is fundamentally wrong

Do not push through a significant deviation silently. The minor/significant split matches the mental model in `review` — use the same judgement.

## Step 3 — Report

Show:
- Validation output (full or summarised if long — errors always in full)
- What changed (files touched, brief description)
- Any deviations noted

End with: **"Ready for feedback."**

## Step 4 — Feedback and commit

Apply any feedback from the user. Then invoke the `commit` skill to commit the task's changes.

Once committed, go back to step 2 for the next task. Repeat until all tasks are done.

## Step 5 — Done

After the last task is committed:
1. Run all validations one final time
2. Say: **"I'm done with the plan."**
3. Show a short summary: what was built, which tasks were completed, any deviations from the plan worth noting.
