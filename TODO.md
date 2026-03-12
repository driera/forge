# TODO

Issues ordered by number, descending — highest (most recent) first.

---

## 10. Gap: no skill owns the outer delivery loop

After bootstrap and the initial backlog are created, the workflow relies entirely on the user to manage the backlog, pick the next issue, and decide when to reprioritize or evolve goals. No skill covers:

- Sprint planning or issue prioritization
- Deciding what to work on next from GitHub Projects
- Knowing when to run `/define-goals` again to evolve product scope

The delivery loop (`explore-issue` → `plan` → `implement` → `review`) is well defined per issue, but the outer loop — across issues and sprints — has no owner. This may warrant a new skill (`plan-sprint`?) or a convention documented in CLAUDE.md templates.

---

## 7. Design vision gap: advisory tone is absent across all skills

Skills currently execute — they don't propose. No skill opens with a suggestion and asks for validation before acting. The intended experience is:

> "As I know how to help you, here's what I'd suggest for this step: [proposal]. Does this match where you want to go? Any changes before I proceed?"

This consultative moment is missing everywhere. `setup-project` creates things without proposing the structure. `define-goals` interviews without framing what a healthy outcome looks like. `explore-issue` is the closest — it proposes approaches and asks section by section — but even it doesn't open with an upfront orientation.

This is not a single-skill fix. It is a tone and interaction design principle that needs to be applied across the whole skill set, starting with `setup-project` and `define-goals` where first impressions are formed.

---

## 6. Lifecycle gap: `review` ends before the lifecycle closes

**File:** `skills/review/SKILL.md` — Step 4

When no blocking issues are found, the skill says "Ready to merge." and stops. There is no step for closing the issue, updating milestone progress, or checking whether a goal is now achieved.

**Trunk-based development context:** no branches or PRs. Work lands directly on main. So "merge" is implicit — the closing sequence is: close the GitHub issue, check milestone progress, check if any GOALS.md goal is now done.

**Two exit paths from `review`:**
1. No blockers → issue is done → needs a closing sequence
2. Blockers found → new tasks created → back into `plan` or `implement`

Closing only happens on exit path 1. It requires judgment — is this goal actually done? does this issue complete the milestone? — so it's not purely mechanical.

**Proposed direction:** a dedicated `/ship` skill (not `/close-issue`) invoked explicitly on exit path 1. It owns the full wiring:
- Close the GitHub issue
- Check milestone: if all issues done, close it
- Check GOALS.md: if a goal is now achieved, mark it done
- Invoke `commit` for any artifact updates

`review` on exit path 1 ends with: "No blockers. Run `/ship` to close the issue and update progress."

**What not to do:** don't add closing steps inside `review` — review has two exits and closing logic would only apply to one of them. A separate skill keeps the boundary clean.

---

---

## Done

---

## ✅ 12. Update `write-issue` skill

Short descriptive titles, story sentence moved to `## Goal` in body. Removed "PR linked and merged" from DoD. `Proposed Solution` made optional for complex tasks only. Label guidance added — suggests based on context, always confirms. AC quality guidance per type: user-observable for stories, technical verifiable states for tasks. Links to referenced files encouraged.

---

## ✅ 11. Update `define-tech` skill

Removed CI workflow generation — CI was never generated anywhere, only claimed. The skill now correctly seeds CI as a backlog task. Commit no longer references `.github/workflows/ci.yml`.

---

## ✅ 15. `plan` has no fallback for missing session files

**File:** `skills/plan/SKILL.md` — Inputs

`plan` hard-stops if `exploration.md` or `design.md` is missing. But a user may arrive at `plan` from a Notion spec, a JIRA ticket, a verbal description, or any non-Forge workflow — none of which produce session files.

**Proposed fix:** if expected files are absent, ask the user to describe the work or point to a file, then proceed normally.

---

## ✅ 13. `explore-issue` has no fallback for non-GitHub users

**File:** `skills/explore-issue/SKILL.md` — Step 1

Step 1 is entirely `gh` CLI. If the user tracks issues in JIRA, Linear, Notion, or any other platform, the skill has no path forward — it either errors or leaves the user stuck.

**Proposed fix:** if `gh issue view` fails or no GitHub issue is found, fall back to asking the user directly: "Couldn't find a GitHub issue. Paste the issue description or tell me what you want to work on." The rest of the skill runs identically from that point.

---

## ✅ 14. Merge `exploration.md` into `design.md`

`exploration.md` is intermediate work — it captures problem understanding before design. No skill after `plan` reads it, and `review` ignores it entirely. `plan` reads it only for problem context and edge cases, which a complete `design.md` should already carry.

**Proposed change:** remove `exploration.md` as a separate deliverable. `design.md` gains a brief problem context section at the top. `explore-issue` writes one file, `plan` reads one file.

**Affected:** `skills/explore-issue/SKILL.md`, `skills/plan/SKILL.md`, `skills/commit/SKILL.md`, `skills/setup-project/SKILL.md` (directory scaffold + templates).

---

## ✅ 1. Bug: `write-issue` has a hardcoded author handle

**File:** `skills/write-issue/SKILL.md` — Step 5

The milestone-fetching command is hardcoded:
```bash
gh api repos/driera/<name>/milestones
```

Any user other than `driera` gets a 404 on milestone fetch. The handle should be resolved dynamically from `gh auth status` or from the repo's git remote, not hardcoded into the skill.

---

## ✅ 2. Bug: plugin path references are broken across three skills

**Files:** `skills/explore-issue/SKILL.md`, `skills/write-adr/SKILL.md`, `skills/implement/SKILL.md`

These skills reference local file paths that assume the skills are copied into the target project:

- `explore-issue` → `.claude/skills/explore-issue/templates/exploration.md` and `design.md`
- `write-adr` → `.claude/skills/write-adr/scripts/next-number.sh` and `templates/adr.md`
- `implement` → `.claude/skills/implement/scripts/validate.sh`

`setup-project` Step 5 explicitly states Forge is now a **plugin** — "no per-project file copying needed." These local paths no longer exist in any project bootstrapped with the current skill. Every call to these resources will silently fail or error at runtime. The plugin model broke them and nothing was updated.

---

## ✅ 3. Hidden dependency: `codebase-explorer` agent is undocumented

**File:** `skills/explore-issue/SKILL.md` — Step 4

`explore-issue` dispatches a `codebase-explorer` sub-agent when implementation files are found:

> "dispatch the `codebase-explorer` agent with the issue title, user story, and acceptance criteria as context"

This agent is not listed in the skill manifest, not documented anywhere in the repo, and has no fallback if it doesn't exist. Any `explore-issue` run on a repo with existing source files will hit this invisibly. It needs to either be defined as a bundled resource, or the step needs a fallback that uses direct Glob/Grep instead.

---

## ✅ 4. Silent assumption: tech stack is never asked, npm is hardcoded

**File:** `skills/setup-project/SKILL.md` — Steps 1 and 8

`setup-project` gathers project name, description, problem, goal, and skills showcased — but never asks about the tech stack or package manager. Step 8 then silently writes a CI workflow that assumes Node.js and npm (`npm ci`, `npm run lint`, etc.).

A React + Vite project, a Next.js project, and a SvelteKit project all get identical CI scaffolding. The toolchain assumption is never surfaced or validated with the user.

---

## ✅ 5. Lifecycle gap: `define-goals` ends with no guidance

**File:** `skills/define-goals/SKILL.md` — Inception mode, Step 5

After writing `GOALS.md`, the skill explicitly states: "The skill is done — no handoff." The user is left with a goals document and no signal about what comes next. The natural next step — creating the first issues — has no owner and no prompt.

---

## ✅ 8. Gap: no skill owns the creation of toolchain issues at project start

The workflow goes `setup-project` → `define-goals` → `explore-issue`, but there is no step that seeds the initial engineering backlog. For any React/frontend project, before product work can start, the following tooling concerns need to exist as issues:

- Linter
- Type-checker
- Test runner
- Build
- GitHub Pages deploy
- CI workflow (depends on all of the above)

No current skill creates these. `setup-project` is infrastructure only. `define-goals` explicitly does not create issues. There is an ownership gap between bootstrapping and the first `explore-issue` call.

---

## ✅ 9. Gap: only one issue template, only one issue type

The skill ecosystem only scaffolds a `user-story` issue template, and `write-issue` only drafts in user-story format. Engineering work — toolchain setup, refactors, dependency upgrades, infrastructure — does not fit the "As a user, I want... so that..." format.

A second template type is needed, called `task`, with this structure:

- **Problem** — what is broken, missing, or needs addressing
- **Context** — background, why it matters, what it affects
- **Proposed solution** — direction or approach (not prescriptive, refined during `explore-issue`)

Two changes required: add the `task` template to `setup-project`'s scaffold step, and extend `write-issue` to detect issue type and draft using the appropriate template.
