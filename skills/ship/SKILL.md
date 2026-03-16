---
name: ship
description: Closes the lifecycle after a clean review — closes the GitHub issue, checks milestone progress, and checks whether any GOALS.md goal is now achieved. Use this whenever the user says "ship", "close the issue", "we're done", or after review hands off on the no-blockers path.
---

# ship

Closes the issue lifecycle after a clean review. Three things to check: the issue, the milestone, and the goals.

---

## Step 1 — Get the issue

Get the issue number from context. If not clear, ask.

Fetch the issue:
```bash
gh issue view NNN --json number,title,state,milestone
```

Extract: title, milestone title and number (if any). If this fails, ask the user to confirm the issue number and title — then continue.

## Step 2 — Close the issue

```bash
gh issue close NNN
```

If the command fails, note it and tell the user — don't stop.

## Step 3 — Check the milestone

If the issue had a milestone, check whether all issues in it are now closed:
```bash
gh issue list --milestone "MILESTONE_TITLE" --state open
```

- **No open issues remain** — close the milestone using the number extracted in Step 1:
  ```bash
  gh api -X PATCH repos/:owner/:repo/milestones/MILESTONE_NUMBER -f state=closed
  ```
  Tell the user the milestone is now closed.

- **Open issues remain** — note how many are left and move on.

- **No milestone** — skip this step.

If any GitHub call fails, note it and continue.

## Step 4 — Check goals

If `GOALS.md` exists, read it. Look at what was just delivered (issue title, AC, milestone context) and assess whether any goal is now fully achieved.

A goal is achieved when the delivered work closes the last remaining gap — not just partially advances it.

If one or more goals look done, present your assessment:
> "Based on what was shipped, it looks like this goal may now be achieved:
> - [Goal text]
>
> Does this match your view?"

Wait for confirmation. If the user agrees, update `GOALS.md` to mark the goal as done (add `✅` prefix or a `- Done: YYYY-MM-DD` note — match whatever convention is already in the file). If there's no existing convention, add `✅` before the goal text.

If no goals are affected, skip this step.

## Step 5 — Commit artifacts

If `GOALS.md` was updated, invoke the `commit` skill.
Suggest commit message: `docs: mark goal achieved after #NNN`

## Step 6 — Done

Summarise what happened:
- Issue #NNN closed
- Milestone status (closed / N issues remaining / no milestone)
- Goal update (if any)
