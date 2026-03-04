---
name: write-issue
description: Creates a GitHub issue in user-story format. Use this skill whenever the user wants to create an issue — whether they say "write an issue", "create an issue", "let's add an issue for X", "open a ticket for", or similar. The user provides the what and why; the skill asks clarifying questions if needed, drafts the full issue, lets the user refine it, then creates it on GitHub after confirmation. Always invoke this skill for issue creation requests.
---

# write-issue

Turn a user's idea into a well-formed GitHub issue in user-story format — with clear acceptance criteria, context, and technical notes — then create it on GitHub.

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

## Step 2 — Clarify what's missing

If the user already described the issue when triggering the skill (e.g. "write an issue for keyboard navigation in the button component"), use that as your starting point and draft directly — don't re-ask what they just told you. Ask only for what's genuinely still missing.

Things to check for:

- **Subject** — who is this for? (if not obvious from the "what")
- **Acceptance criteria** — what does done look like, specifically and testably?
- **Technical notes** — any constraints, approach hints, ADR references, or
  dependencies the implementer should know about?
- **References** — designs, related issues, external docs?

Ask only what you genuinely need. Don't pepper the user with questions if the intent
is already clear.

---

## Step 3 — Draft the issue

Write a title and body using the template below.

**Title format**: `As a <subject>, I want <action> so that <outcome>`

Keep it on one line, imperative, specific. The title is the user story itself.

**Body template:**

```markdown
## As a [subject], I want [action] so that [outcome]

## Context

[Why does this exist? What problem does it solve? What's the background?]

## Acceptance Criteria

- [ ] [Specific, testable criterion]
- [ ] A11y: passes axe with zero violations (if UI component)
- [ ] Tests written and passing
- [ ] Docs updated (if applicable)

## Technical Notes

[Constraints, approach hints, ADR references, links to related issues or designs.]

## Definition of Done

- [ ] Tests passing
- [ ] Code reviewed
- [ ] Docs updated
- [ ] PR linked and merged
```

Good acceptance criteria are **testable** and **specific**. "Works correctly" is not
a criterion. "User sees an error message when the field is empty" is.

Technical Notes can be brief or empty if there's nothing relevant — but if the user
mentioned constraints or references, include them here.

---

## Step 4 — Show the draft and refine

Present the full title and body to the user. Wait for their feedback. Revise until
they're satisfied.

---

## Step 5 — Create the issue on GitHub

Once confirmed, fetch the open milestones for this repo:

```bash
gh api repos/driera/<name>/milestones --jq '.[].title'
```

- **One milestone** — use it automatically
- **Multiple milestones** — present the list and ask the user which to assign
- **None** — omit `--milestone` from the create command

Then create the issue:

```bash
gh issue create \
  --title "<title>" \
  --body "<body>" \
  --milestone "<milestone-title>"   # omit if no milestones exist
```

Then add the issue to the project board:

```bash
# Get the issue number from the URL returned above
gh project item-add <project-number> --owner driera --url <issue-url>
```

To find the project number, run `gh project list --owner driera` if you don't already have it.

Show the user the issue URL when done. Then close with:

> "Issue #NNN created. When you're ready to start, say `explore issue NNN`."
