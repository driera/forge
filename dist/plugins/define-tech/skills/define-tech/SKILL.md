---
name: define-tech
description: Defines the tech stack and toolchain for a new project. Reads product goals, leads a conversation about language, framework, package manager, linter, type checker, test runner, build tool, and deploy target, then writes TECH.md and seeds the initial engineering backlog in BACKLOG.md. Hands off to write-issue. Use this whenever the user says "define tech", "set up the toolchain", "what stack should we use", or after define-goals hands off during project inception.
---

# define-tech

Define the tech stack and toolchain before any code is written. The output is `TECH.md` — the
technical source of truth — and a set of engineering task issues in `BACKLOG.md` ready to be
created. CI is always a backlog task, never generated here — toolchain scripts must exist first.

---

## Step 1 — Read project context

Read `GOALS.md`, `CLAUDE.md`, and `README.md`. Extract:
- What the product does and for whom
- The MVP threshold
- Any technical constraints already mentioned

This prevents redundant questions and grounds the tech conversation in product reality.

---

## Step 2 — Discuss the stack

Lead a conversation about the tech stack. Don't present a form — ask one area at a time and
confirm before moving on. Start with the highest-level decisions, which constrain the rest.

Cover these areas in order:

1. **Language and runtime** — What language? Any runtime constraints? (e.g. Node, Deno, browser-only)
2. **Framework** — What framework, if any? (e.g. React, Next.js, SvelteKit, Express, none)
3. **Package manager** — npm, yarn, pnpm, or bun?
4. **Linter** — ESLint? Biome? Other?
5. **Formatter** — Prettier? Biome? Built into linter?
6. **Type checker** — TypeScript? Flow? None?
7. **Test runner** — Vitest? Jest? Playwright? Other?
8. **Build tool** — Vite? Webpack? tsc only? Framework handles it?
9. **Deploy target** — Vercel? GitHub Pages? Railway? Docker? Other?

For each area, offer a sensible default based on what's already been decided (e.g. if React +
Vite → Vitest is a natural fit). State your recommendation and why — let the user confirm or
redirect.

If the product goals suggest a need the user hasn't raised (e.g. real-time features suggesting
a backend, or auth suggesting a session store), surface it as a question before finalising.

---

## Step 3 — Write TECH.md

Once all decisions are confirmed, write `TECH.md` to the project root:

```markdown
# Tech

> Technical source of truth. Decisions made before any code was written.
> Updated as the stack evolves.

## Stack

| Area | Decision | Notes |
|------|----------|-------|
| Language | <language> | |
| Runtime | <runtime> | |
| Framework | <framework> | |
| Package manager | <pm> | |

## Toolchain

| Tool | Decision | Notes |
|------|----------|-------|
| Linter | <linter> | |
| Formatter | <formatter> | |
| Type checker | <type-checker> | |
| Test runner | <test-runner> | |
| Build | <build-tool> | |

## Deploy

| Target | Notes |
|--------|-------|
| <target> | <any constraints or config notes> |

## CI

Runs on every PR and push to main: lint → type-check → test → build.
```

Replace all placeholders with confirmed decisions.

Then update the README Status section to link `TECH.md`:

```markdown
## Status

Current milestone: `MVP — in progress`
[Goals →](GOALS.md) · [Tech →](TECH.md) · [Roadmap →](<GitHub Projects link>)
```

---

## Step 4 — Propose engineering task issues

Based on the confirmed toolchain, propose the first engineering task issues. These are the
setup tasks that must exist before product work can start.

Typical set for a JS/TS project:

- Set up linter
- Set up formatter
- Set up type checker
- Set up test runner
- Set up build
- Set up deploy pipeline
- Set up CI workflow _(depends on all of the above — do this last)_

Only propose tasks that are real work — if the framework handles something out of the box,
don't create an issue for it. CI is always last — it can only be implemented once all other
toolchain scripts are in place.

Present the proposed list to the user:

> "Here are the engineering tasks I'd suggest as your starting backlog. Add, remove, or
> reorder before I write them to BACKLOG.md:
>
> - [ ] Set up ESLint
> - [ ] Set up Prettier
> - [ ] ..."

Wait for confirmation. Then append to `BACKLOG.md` (create if it doesn't exist):

```markdown
## Engineering tasks

- [ ] **<title>** — <one-line description of what done looks like> _(task)_
```

If `BACKLOG.md` already has a `## Product issues` section from `define-goals`, append below it.

---

## Step 6 — Commit artifacts

Invoke the `commit` skill to commit `TECH.md` and `BACKLOG.md`.
Suggested message: `chore: define tech stack and toolchain`

---

## Step 7 — Hand off to write-issue

Tell the user:

> "Tech stack and toolchain are defined. BACKLOG.md now has both product and engineering
> issues ready to create. Run `/write-issue` to work through them one by one — or pick
> whichever you want to start with."
