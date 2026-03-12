---
name: write-issue
description: Creates a GitHub issue — either a user story or an engineering task. Use this skill whenever the user wants to create an issue — whether they say "write an issue", "create an issue", "let's add an issue for X", "open a ticket for", or similar. The user provides the what and why; the skill determines the issue type, asks clarifying questions if needed, drafts the full issue, lets the user refine it, then creates it on GitHub after confirmation. Always invoke this skill for issue creation requests.
---

# write-issue

Turn a user's idea into a well-formed GitHub issue, then create it on GitHub. Supports two issue types: **user-story** (product features, user-facing improvements) and **task** (engineering work — toolchain, refactors, infrastructure, dependencies).

---

## What the user provides

The user typically gives:
- **What** — the action or capability they want to enable
- **Why** — the outcome or benefit it delivers
- **Some context** — background, motivation, or related work
- **Maybe some acceptance criteria** — rough checkboxes they have in mind

They may not use formal language. That's fine — extract the intent and shape it.

---

## Step 1 — Read available context

If `GOALS.md` exists in the project root, read it. Use it to understand the product direction and ground the issue in existing goals. Don't block if it doesn't exist.

---

## Step 2 — Determine issue type

Infer the type from the user's description:

- **user-story** — the outcome benefits an end user directly ("as a user, I want to…", feature work, UI, UX)
- **task** — engineering work with no direct user-facing outcome (toolchain setup, refactors, dependency upgrades, infrastructure, CI)

If the type is ambiguous, ask: "Is this user-facing or engineering work?"

---

## Step 3 — Clarify what's missing

If the user already described the issue when triggering the skill, use that as your starting point and draft directly — don't re-ask what they just told you. Ask only for what's genuinely still missing.

**For user-story:**
- **Subject** — who is this for? (if not obvious)
- **Acceptance criteria** — what does done look like, specifically and testably?
- **Technical notes** — constraints, ADR references, dependencies?

**For task:**
- **Problem** — what is broken, missing, or needs addressing? (if not clear)
- **Proposed solution** — any direction or approach already in mind?

Ask only what you genuinely need. Don't pepper the user with questions if the intent is already clear.

---

## Step 4 — Draft the issue

### User story

**Title format**: short descriptive title (e.g. "Login with Google", "Empty state for task list")

```markdown
## Goal

As a [subject], I want [action] so that [outcome].

## Context

[Why does this exist? What problem does it solve? What's the background?
Link any referenced files — e.g. [GOALS.md](../GOALS.md), [TECH.md](../TECH.md).]

## Acceptance Criteria

- [ ] [User-observable outcome — what the user sees or experiences]
- [ ] A11y: passes axe with zero violations (if UI component)
- [ ] Tests written and passing
- [ ] Docs updated (if applicable)

## Technical Notes

[Constraints, approach hints, ADR references, links to related issues or designs.]

## Definition of Done

- [ ] Tests passing
- [ ] Code reviewed
- [ ] Docs updated
```

Good acceptance criteria describe **what a user observes**, not what the code does. "Works correctly" is not a criterion. "User sees an error message when the field is empty" is.

### Task

**Title format**: short imperative description of the engineering work (e.g. "Set up ESLint", "Migrate state to Zustand")

```markdown
## Problem

[What is broken, missing, or needs addressing?]

## Context

[Background, why it matters, what it affects.
Link any referenced files — e.g. [TECH.md](../TECH.md).]

<!-- Proposed Solution: include only for complex tasks where the approach isn't obvious. Omit for straightforward setup tasks. -->

## Acceptance Criteria

- [ ] [Technical verifiable state — what is true about the system when done]
- [ ] Tests written and passing (if applicable)
- [ ] Docs updated (if applicable)

## Definition of Done

- [ ] Tests passing
- [ ] Code reviewed
```

Good acceptance criteria for tasks describe **verifiable technical states** — "ESLint runs with zero errors on `npm run lint`", not "add ESLint config".

---

## Step 5 — Show the draft and refine

Present the full title and body to the user. Wait for their feedback. Revise until
they're satisfied.

---

## Step 6 — Create the issue on GitHub

Ask the user which label to apply. Suggest a starting point based on context — `feature` for user stories, `tooling` for toolchain/infrastructure tasks, `bug` for fixes, `chore` for maintenance. The user confirms or overrides before the issue is created.

Resolve the repo owner and name from the git remote:

```bash
git remote get-url origin
```

Parse `owner` and `repo` from the output. Handles both HTTPS (`https://github.com/owner/repo.git`) and SSH (`git@github.com:owner/repo.git`) formats. If parsing fails, fall back to `gh auth status` to get the authenticated handle.

Fetch the open milestones for this repo:

```bash
gh api repos/<owner>/<repo>/milestones --jq '.[].title'
```

- **One milestone** — use it automatically
- **Multiple milestones** — present the list and ask the user which to assign
- **None** — omit `--milestone` from the create command

Then create the issue:

```bash
gh issue create \
  --title "<title>" \
  --body "<body>" \
  --label "<label>" \
  --milestone "<milestone-title>"   # omit if no milestones exist
```

Then add the issue to the project board:

```bash
# Get the issue number from the URL returned above
gh project item-add <project-number> --owner <owner> --url <issue-url>
```

To find the project number, run `gh project list --owner <owner>` if you don't already have it.

Show the user the issue URL when done. Then close with:

> "Issue #NNN created. When you're ready to start, say `explore issue NNN`."
