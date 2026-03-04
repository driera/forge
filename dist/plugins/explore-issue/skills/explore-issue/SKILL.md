---
name: explore-issue
description: Entry point to the delivery loop. Fetches a GitHub issue, explores its problem space, then drives the design through dialogue — covering architecture, components, data flow, error handling, and testing — before handing off to plan. Use this whenever the user says "explore issue NNN", "work on NNN", "let's start issue NNN", "pick up issue NNN", or similar. Also triggers when the user says "explore issue" or "next issue" with no number — in that case, fetch open issues and let the user choose.
---

# explore-issue

Two phases in one conversation: understand the problem, then design the solution. Don't write code or propose implementations until the design is approved.

---

## Phase 1: Exploration

### 1. Get the issue

**If an issue number was provided:**
```bash
gh issue view NNN --json number,title,body,labels,milestone,state
```

**If no number was provided**, list open issues in a "todo" or "ready" state:
```bash
gh issue list --state open --label todo
```
If that returns nothing, fall back to all open issues:
```bash
gh issue list --state open
```
Present the list and ask the user which issue to work on.

### 2. Check for an existing session

Derive the session directory path: `sessions/NNN-issue-title/` (kebab-case slug from issue title, lowercase, no special characters, truncated at ~40 chars if long).

**If the directory exists and contains files**, open with a resume summary before doing anything else:

> "I can see we've already worked on this issue:
> - exploration.md: [one-line summary of what was captured]
> - design.md: [approach chosen]
> - plan.md: [N tasks, N done] _(if present)_
>
> Does this match where we left off? Anything to correct before we continue?"

Wait for confirmation. If the user confirms, resume from where the artifacts left off — don't redo completed work. If they correct something, adjust before continuing.

**If the directory doesn't exist**, create it:
```
sessions/NNN-issue-title/
```

### 3. Read project context

Read `CLAUDE.md` if it exists. Note the tech stack, conventions, and any constraints relevant to this issue.

### 4. Explore relevant code

First, check whether the repo contains implementation files related to the issue — components, modules, or tests (not just config, tooling, or docs). A quick Glob or Grep against terms from the issue title and acceptance criteria is enough.

**If relevant implementation files exist:** dispatch the `codebase-explorer` agent with the issue title, user story, and acceptance criteria as context. Use its findings to inform your problem understanding. Reserve direct Grep/Glob searches for targeted lookups that the agent's output raises.

**If only config, tooling, or docs exist** (e.g. a freshly bootstrapped repo with no source code yet): note that the issue likely introduces new code and move on — no agent dispatch needed.

### 5. Ask clarifying questions (only if needed)

Ask one question at a time. Prefer multiple choice — it's faster to answer. Focus on anything that would change how you understand the problem. If everything is clear from the issue and codebase, skip this step.

### 6. Present problem understanding

Give the user a short summary — a few sentences covering the problem, who it's for, what success looks like, and any notable edge cases or constraints. Then ask: "Does this capture the problem correctly? Anything to correct before I design?"

When they confirm, write `sessions/NNN-issue-title/exploration.md` using the template at `.claude/skills/explore-issue/templates/exploration.md`.

---

## Phase 2: Design

### 7. Propose approaches

Before diving into design, propose 2–3 different approaches with tradeoffs. Lead with your recommendation and explain why. Keep it conversational — a few sentences per option. Wait for the user to choose one or redirect.

### 8. Present the design section by section

Once you have a direction, present the design incrementally. Scale each section to its complexity — a few sentences if straightforward, up to 200–300 words if nuanced. After each section, ask: "Does this look right?"

Cover these sections in order:
1. **Architecture** — how the pieces fit together at a high level
2. **Components** — what gets built and roughly how each piece works
3. **Data flow** — how data moves through the system
4. **Error handling** — failure modes and how they're addressed
5. **Testing** — what gets tested and at what level

Be ready to go back and revise. If a later section reveals a problem with an earlier one, surface it and correct it.

### 9. Write design.md

Once the user approves the full design, write to `sessions/NNN-issue-title/design.md` using the template at `.claude/skills/explore-issue/templates/design.md`.

### 10. ADR offers — two distinct paths

After writing design.md, look back over the decisions made during the conversation. Sort them into two buckets:

**Closed decisions** (made and settled during design, with real tradeoffs):
> "During design we made a few decisions worth capturing as ADRs:
> - X over Y because …
> - A over B because …
>
> Want me to write ADRs for any of these?"

If yes, invoke `write-adr` in **closed decision mode** for each confirmed one.

**Open questions** (surfaced but not yet resolved):
> "These questions came up but are still open:
> - [Question] — [why it matters]
>
> Want to work through any of these now?"

If yes, resolve through dialogue, then invoke `write-adr` in **open decision mode** once decided.

If no decisions had meaningful tradeoffs and no questions are open, skip this step.

### 11. Commit artifacts

Invoke the `commit` skill to commit exploration.md and design.md (and any ADRs written).
Suggest commit message: `docs: add exploration and design for #NNN`

### 12. Hand off to plan

Tell the user exploration and design are saved and committed. Suggest invoking the `plan` skill next.
