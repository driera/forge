---
name: write-opportunity
description: Captures a product opportunity — an unmet need, pain point, or intuition worth exploring before any solution is committed. Use when the user wants to register an idea, signal, or potential feature without turning it into a user story yet. Triggers on "write an opportunity", "register this idea", "log this as an opportunity", "we should explore X someday", or similar. The user describes the signal; the skill shapes it through conversation, drafts the opportunity, and creates it as a GitHub issue with the `opportunity` label.
---

# write-opportunity

Turn a raw product signal into a well-formed opportunity registered on GitHub. An opportunity is not a user story and not a task — it lives in the discovery space, before any solution or commitment exists.

---

## What the user provides

Anything — a rough idea, a pain point they heard, an intuition. No structure required. The skill extracts what's there and shapes it through conversation.

---

## Step 1 — Read available context

If `GOALS.md` exists in the project root, read it. Use it to connect the opportunity to existing product direction. Don't block if it doesn't exist.

---

## Step 2 — Understand the signal

Have a focused conversation to understand the opportunity. Don't run through a checklist — let the description guide what needs clarifying.

The only thing required is the **signal**: what was observed, heard, or intuited that suggests something worth exploring.

Everything else — who it affects, potential value, open questions — only surfaces if it emerges naturally from the conversation. Don't ask for fields the user hasn't touched on.

---

## Step 3 — Draft the opportunity

Load the body template:

1. Check if `.github/ISSUE_TEMPLATE/opportunity.md` exists
2. If yes — read it and strip the YAML frontmatter block to get the body skeleton
3. If no — use the bundled fallback from `templates/opportunity.md` in this skill

Fill in only the sections that have content. **Omit any section that is empty** — do not include empty headers or placeholder text in the final draft.

**Title format**: short noun phrase describing the opportunity space (e.g. "Onboarding drop-off after step 2", "No way to recover from a failed sync")

---

## Step 4 — Show the draft and refine

Present the full title and body. Wait for feedback. Revise until the user is satisfied.

---

## Step 5 — Create the issue on GitHub

Resolve the repo owner and name from the git remote:

```bash
git remote get-url origin
```

Parse `owner` and `repo` from the output. Handles both HTTPS (`https://github.com/owner/repo.git`) and SSH (`git@github.com:owner/repo.git`) formats.

Fetch open milestones:

```bash
gh api repos/<owner>/<repo>/milestones --jq '.[].title'
```

- **One milestone** — use it automatically
- **Multiple milestones** — present the list and ask which to assign
- **None** — omit `--milestone`

Create the issue with the `opportunity` label:

```bash
gh issue create \
  --title "<title>" \
  --body "<body>" \
  --label "opportunity" \
  --milestone "<milestone-title>"   # omit if no milestones exist
```

Then add the issue to the project board:

```bash
gh project item-add <project-number> --owner <owner> --url <issue-url>
```

To find the project number, run `gh project list --owner <owner>` if you don't already have it.

Show the user the issue URL when done. Then close with:

> "Opportunity #NNN registered. When you're ready to evaluate it, say `explore issue NNN`."
