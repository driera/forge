---
name: commit
description: Commits work done during the current session. Use this skill whenever the user wants to commit their changes — whether they say "commit", "save my work", "let's commit", "commit what we did", or similar. The skill inspects git status and diff, uses the session context to understand what was done, stages the right files, writes short one-line conventional commit messages (feat/fix/docs/chore/etc.), and splits into multiple commits if the changes are logically distinct (always confirming with the user first). Never pushes.
---

# commit

Commit the changes made during this session into one or more clean, descriptive git commits.

## What to do

### 1. Understand what changed

Run these in parallel:
- `git status` — what files are new, modified, deleted
- `git diff` — what the actual content changes are
- `git diff --staged` — anything already staged

Also draw on the session history: what tasks were completed, what problems were solved, what files were created or edited. This context makes commit messages much more accurate than reading diffs alone.

### 2. Decide: one commit or many?

Group changes by logical intent. Ask yourself: if someone looked at this commit a year from now, would these changes make sense together?

**Default to one commit** unless the session clearly contained distinct, independent pieces of work (e.g., a bug fix unrelated to the feature that was added).

**Before splitting into multiple commits, confirm with the user.** Propose the split and explain why — let them approve or merge everything into one.

Avoid over-splitting. Don't create a commit per file or per small change.

### 3. Stage selectively

Use `git add <file>` for specific files — never `git add -A` or `git add .`. This prevents accidentally committing unintended files (.env, secrets, generated artifacts, etc.).

If unsure whether a file should be included, leave it out and mention it to the user.

**Session artifacts** (`context.md`, `plan.md`, `review.md`) are first-class
deliverables — always include them when modified:

- **First creation** of a session artifact is committed as the closing step of the skill that
  produced it (e.g. `explore-issue` commits context.md; `plan` commits plan.md;
  `review` commits review.md on first write). These skills invoke `commit` directly at the end
  of their flow — don't skip them.
- **Subsequent updates** to existing artifacts travel with the related code changes that
  triggered them — staged in the same commit as the code.

Never treat session artifacts as noise to be excluded from commits.

### 4. Write the commit message

Format: `<type>: <short description>`

- One line only — no body, no footer
- Under 72 characters
- Imperative mood: "add", "fix", "update" — not "added" or "adding"

**Issue tagging:** when committing during the delivery loop (an active issue number is in
context — i.e. working inside `explore-issue`, `plan`, `implement`, or `review`), append
the issue number to the message: `feat: add button component (#12)`. Omit the tag for
commits outside the delivery loop (bootstrap, ADRs not tied to an issue, skill updates).

**Types:**
- `feat` — new functionality
- `fix` — bug fix
- `docs` — documentation only
- `chore` — maintenance, config, tooling, deps
- `refactor` — restructure without behavior change
- `test` — adding or updating tests
- `style` — formatting, naming (no logic change)

**Examples:**
- `feat: add JWT login flow`
- `fix: correct bounds calculation on resize`
- `docs: add setup instructions to README`
- `chore: update eslint config to v9`
- `refactor: extract button variant logic to hook`

Use the session context to write a message that captures *why* this change was made, not just *what* changed. A diff already shows what changed.

### 5. Commit

```bash
git commit -m "<message>"
```

Never use `--no-verify`. Never push. Never add Claude as a co-author — the commit is the user's work.

### 6. Confirm

After each commit, show the user the commit hash and message. If there are multiple commits, list them all at the end.

---

## What not to do

- Don't push to remote under any circumstances
- Don't use `git add -A` or `git add .`
- Don't write multi-line commit bodies (one line only)
- Don't commit files that look like secrets, env files, or generated output unless the user explicitly says to
- Don't split into multiple commits without first confirming with the user
- Don't add Claude or any AI as a co-author in the commit message
